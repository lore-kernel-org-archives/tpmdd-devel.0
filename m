From: Jeremy Cline <jeremy@jcline.org>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Thu, 8 Mar 2018 18:20:05 +0000
Message-ID: <0100016206d770c7-11c5bffc-70e7-41bf-a62a-d8aad8209f7e-000000@email.amazonses.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
 <CA+zpnLdSyuyKjJEH3Oowmha2mF0B-j5b4A7CLuXXY7RH47SiFQ@mail.gmail.com>
 <0100016201863c0f-70600bd6-12d3-461d-9173-e4d61e8d09d5-000000@email.amazonses.com>
 <CA+zpnLf1WNxYY-FaoFbas480GmkUW6kw_L7zi5mES3EPhL7egA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+zpnLf1WNxYY-FaoFbas480GmkUW6kw_L7zi5mES3EPhL7egA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, hdegoede@redhat.com, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/08/2018 03:45 AM, Thiebaud Weksteen wrote:
> Jeremy, Hans, could you both describe precisely how your boot is
> configured? This feature is only triggered when booting the EFI stub of the
> kernel so this may be not executed if you are using something else in
> between.

I put everything I know in the other sub-thread.
> Jeremy, would you be able to modify the efi_retrieve_tpm2_eventlog_1_2
> function to add multiple efi_printk(sys_table_arg,  "message\n"); to test:
> if you get the output on your screen; and isolate which call might be the
> cause of the hang?
> I can forward a debug patch if that helps.

Thanks for the patch, here's the output:

Locating the TCG2Protocol
Calling GetEventLog on TCG2Protocol
Log returned
log_location is not empty
log_size != 0
Allocating memory for storing the logs
Returned from memory allocation
Copying log to new location

At this point it hangs.


Regards,
Jeremy
