From: Jeremy Cline <jeremy@jcline.org>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Fri, 9 Mar 2018 16:54:42 +0000
Message-ID: <010001620bafa06b-41525407-603e-40a9-ba11-6033b2f5dcc7-000000@email.amazonses.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
 <e7c2be5c-cf21-fc2d-efda-d9222d93ffad@redhat.com>
 <b32f335c-0d77-1749-f7fe-65f512280255@redhat.com>
 <ade378f6-c997-1d48-a30d-cceee6435fc8@redhat.com>
 <a3b5f822-f8f4-e2f5-46da-e23e13174f28@redhat.com>
 <cec36124-0950-6ad9-58a8-9bd69e63aa04@redhat.com>
 <0100016206a68850-bd5c96b3-f275-46ea-98b1-1317e02a5d6e-000000@email.amazonses.com>
 <29c1640a-cf19-ca19-7de9-96f202edfb5a@redhat.com>
 <CA+zpnLebtbjbA-Jg+RvMOqwDE5R--9V3hTwMk95Br4vM1LgBjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+zpnLebtbjbA-Jg+RvMOqwDE5R--9V3hTwMk95Br4vM1LgBjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>
Cc: hdegoede@redhat.com, Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 09, 2018 at 10:43:50AM +0000, Thiebaud Weksteen wrote:
> Thanks a lot for trying out the patch!
> 
> Please don't modify your install at this stage, I think we are hitting a
> firmware bug and that would be awesome if we can fix how we are handling it.
> So, if we reach that stage in the function it could either be that:
> * The allocation did not succeed, somehow, but the firmware still returned
> EFI_SUCCEED.
> * The size requested is incorrect (I'm thinking something like a 1G of
> log). This would be due to either a miscalculation of log_size (possible)
> or; the returned values of GetEventLog are not correct.
> I'm sending a patch to add checks for these. Could you please apply and
> retest?
> Again, thanks for helping debugging this.

No problem, thanks for the help :)

With the new patch:

Locating the TCG2Protocol
Calling GetEventLog on TCG2Protocol
Log returned
log_location is not empty
log_size != 0
log_size < 1M
Allocating memory for storing the logs
Returned from memory allocation
Copying log to new location

And then it hangs. I added a couple more print statements:

diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
index ee3fac109078..1ab5638bc50e 100644
--- a/drivers/firmware/efi/libstub/tpm.c
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -148,8 +148,11 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
        efi_printk(sys_table_arg, "Copying log to new location\n");
 
        memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
+       efi_printk(sys_table_arg, "Successfully memset log_tbl to 0\n");
        log_tbl->size = log_size;
+       efi_printk(sys_table_arg, "Set log_tbl->size\n");
        log_tbl->version = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
+       efi_printk(sys_table_arg, "Set log_tbl-version\n");
        memcpy(log_tbl->log, (void *) first_entry_addr, log_size);
 
        efi_printk(sys_table_arg, "Installing the log into the configuration table\n");

and it's hanging at "memset(log_tbl, 0, sizeof(*log_tbl) + log_size);"

Regards,
Jeremy
