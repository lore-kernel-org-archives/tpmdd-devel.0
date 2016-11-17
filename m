From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Thu, 17 Nov 2016 07:35:05 -0500
Message-ID: <ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161116200759.GA19593-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/16/2016 03:07 PM, Jason Gunthorpe wrote:
> On Wed, Nov 16, 2016 at 12:07:23PM -0500, Stefan Berger wrote:
>> The culprit seems to be 'tpm: fix the missing .owner in
>> tpm_bios_measurements_ops'
> That is unlikely, it is probably the patch before which calls read_log
> unconditionally now. That suggests the crashing is a little random..

I ran the vtpm driver test suite (with -j32) a few times at that patch 
and it didn't crash. It crashes severely with later patches applied. 
Here's the current experimental patch that fixes these problems:

iff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 0cb43ef..a73295a 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -56,6 +56,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)

      log = &chip->log;

+    if (!chip->acpi_dev_handle)
+        return 0;
+

// So ACPI is not supported on this device, but ACPI support is compiled 
in. I am returning 0 here, assuming it's not an OF device and the 
corresponding OF function need not be called (see below).

      /* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
      status = acpi_get_table(ACPI_SIG_TCPA, 1,
                  (struct acpi_table_header **)&buff);
diff --git a/drivers/char/tpm/tpm_eventlog.c 
b/drivers/char/tpm/tpm_eventlog.c
index fb603a7..12b0356 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -380,7 +380,8 @@ static int tpm_read_log(struct tpm_chip *chip)
      if ((rc == 0) || (rc == -ENOMEM))
          return rc;

-    rc = tpm_read_log_of(chip);
+    if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
+        rc = tpm_read_log_of(chip);

// I am not sure how to handle this case, in case we get here, which 
would only be on an OF device (following 'return 0;' above), but we 
don't want to attempt to read the log there, either. I think the most 
straight-forward way would be to gate this whole function with a flag 
that only the vtpm proxy driver has: TPM_CHIP_FLAG_NO_FIRMWARE_LOG.

      return rc;


    Stefan

>
> tpm_read_log_acpi should check if the chip has a acpi_dev_handle
> before running, but it also shouldn't crash - so there are two bugs
> here I guess.. Please do that instead of the checking the virual flag.
>
> Jarkko, you know acpi better, we switched ppi to search starting from
> the acpi_dev_handle for its data - can we do the same for event log?
>
>> The crash looks like this:
>> [  173.608722]  [<ffffffff8140ca11>] dump_stack+0x63/0x82
>> [  173.608722]  [<ffffffff8106b99f>] iounmap.part.1+0x7f/0x90
>> [  173.608722]  [<ffffffff8106b9dc>] iounmap+0x2c/0x30
>> [  173.608722]  [<ffffffff81496c75>] acpi_os_map_cleanup.part.10+0x31/0x3e
>> [  173.608722]  [<ffffffff8179629c>] acpi_os_unmap_iomem+0xcb/0xd2
>> [  173.608722]  [<ffffffffa00e1b28>] read_log+0xc8/0x19e [tpm]
> This seems really strange ACPI should not crash like this - yes it
> will wrongly read the log for the system into the vtpm, but that
> *should* work.
>
> Are you doing anything special with this test like high parallism or
> something?  Any chance you can look at little more? The tpm code looks
> OK to me, the map and unmap are properly paired - but the bad address
> from the iounmap suggests the refcounting in acpi is not working or
> something along those lines?
>
> Jason
>


------------------------------------------------------------------------------
