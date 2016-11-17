From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Thu, 17 Nov 2016 12:34:06 -0800
Message-ID: <20161117203406.co7c6xsbiabntxrf@intel.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
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

On Wed, Nov 16, 2016 at 01:07:59PM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 16, 2016 at 12:07:23PM -0500, Stefan Berger wrote:
> > The culprit seems to be 'tpm: fix the missing .owner in
> > tpm_bios_measurements_ops'
> 
> That is unlikely, it is probably the patch before which calls read_log
> unconditionally now. That suggests the crashing is a little random..
> 
> tpm_read_log_acpi should check if the chip has a acpi_dev_handle
> before running, but it also shouldn't crash - so there are two bugs
> here I guess.. Please do that instead of the checking the virual flag.
> 
> Jarkko, you know acpi better, we switched ppi to search starting from
> the acpi_dev_handle for its data - can we do the same for event log?

Here we read the data from completely separate ACPI table i.e. TCPA. PPI
on the other hand is located in the device node of DSDT or SSDT.

You are right. The acpi_dev_handle should be checked in the sense that
it is a gate for using the ACPI functionality but trying to open TCPA
should not cause anything devastating.

> > The crash looks like this:
> 
> > [  173.608722]  [<ffffffff8140ca11>] dump_stack+0x63/0x82
> > [  173.608722]  [<ffffffff8106b99f>] iounmap.part.1+0x7f/0x90
> > [  173.608722]  [<ffffffff8106b9dc>] iounmap+0x2c/0x30
> > [  173.608722]  [<ffffffff81496c75>] acpi_os_map_cleanup.part.10+0x31/0x3e
> > [  173.608722]  [<ffffffff8179629c>] acpi_os_unmap_iomem+0xcb/0xd2
> > [  173.608722]  [<ffffffffa00e1b28>] read_log+0xc8/0x19e [tpm]
> 
> This seems really strange ACPI should not crash like this - yes it
> will wrongly read the log for the system into the vtpm, but that
> *should* work.
> 
> Are you doing anything special with this test like high parallism or
> something?  Any chance you can look at little more? The tpm code looks
> OK to me, the map and unmap are properly paired - but the bad address
> from the iounmap suggests the refcounting in acpi is not working or
> something along those lines?

acpi_get_table() should be safe and the code also calls
acpi_os_unmap_iomem() correctly.

Maybe there's something wrong in the kernel outside the TPM driver...

> Jason

/Jarkko

------------------------------------------------------------------------------
