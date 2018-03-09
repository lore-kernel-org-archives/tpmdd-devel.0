From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Fri, 9 Mar 2018 10:29:04 +0100
Message-ID: <29c1640a-cf19-ca19-7de9-96f202edfb5a@redhat.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
 <e7c2be5c-cf21-fc2d-efda-d9222d93ffad@redhat.com>
 <b32f335c-0d77-1749-f7fe-65f512280255@redhat.com>
 <ade378f6-c997-1d48-a30d-cceee6435fc8@redhat.com>
 <a3b5f822-f8f4-e2f5-46da-e23e13174f28@redhat.com>
 <cec36124-0950-6ad9-58a8-9bd69e63aa04@redhat.com>
 <0100016206a68850-bd5c96b3-f275-46ea-98b1-1317e02a5d6e-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0100016206a68850-bd5c96b3-f275-46ea-98b1-1317e02a5d6e-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>, Javier Martinez Canillas <javierm@redhat.com>, Thiebaud Weksteen <tweek@google.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi,

On 08-03-18 18:26, Jeremy Cline wrote:
> On 03/08/2018 11:50 AM, Hans de Goede wrote:
>> <somehow this part of the thread was missing some email addresses, I've
>> added these now>
>>
>> Hi,
>>
>> On 07-03-18 12:34, Javier Martinez Canillas wrote:
> 
> <snip>
> 
>>> Are you also able to read the TPM event logs?
>>>
>>> $ hexdump /sys/kernel/security/tpm0/binary_bios_measurements
>>
>> Yes for me that outputs a lot of hex :)
> 
> For me, /sys/kernel/security/tmp0 doesn't exist on 4.15.6 or 4.16 with
> the patch reverted.

Hmm, have you re-enabled the TPM in the BIOS?

>>> The UEFI firmware does some measurements and so does shim. So you should
>>> have some event logs. What version of shim are you using? And also would
>>> be good to know if it's the same shim version that Jeremy is using.
>>
>> That is a very good question, I'm using: shim-ia32-13-0.7.x86_64, which is
>> the last version for F27 AFAICT.
> 
> All my tablet has installed is shim-0.8-10.x86_64, no shim-ia32.

Yes my bad, although if the kernel changes break booting on systems
without the shim that is still good to know and something which
we probably ought to fix.

>> But Jeremy's tablet might very well be not using the shim at all, as
>> I manually installed Fedora 25 on the tablet he now has, before Fedora
>> supported
>> machines with 32 bit EFI. I then later did a "dnf distro-sync" to
>> Fedora-27.
>>
>> Jeremy might also very well still be booting using a grub binary I build
>> manually back then, without any shim being involved.
>>
>> Jeremy what does efibootmgr -v output on your device ?
> 
> # efibootmgr -v
> BootCurrent: 0003
> Timeout: 4 seconds
> BootOrder: 0003,0000,0001,2001,2002,2003
> Boot0000* Android X64 OS
> HD(1,GPT,215e6cf3-e97d-4735-9c4e-7338c8f5a645,0x800,0x32000)/File(\EFI\BOOT\bootx64.efi)RC
> Boot0001* Internal EFI Shell
> FvVol(a881d567-6cb0-4eee-8435-2e72d33e45b5)/FvFile(c57ad6b7-0515-40a8-9d21-551652854e37)RCM&".
> Boot0003* Fedora
> HD(1,GPT,215e6cf3-e97d-4735-9c4e-7338c8f5a645,0x800,0x32000)/File(\EFI\fedora\grubx64.efi)
> Boot2001* EFI USB Device	RC
> Boot2002* EFI DVD/CDROM	RC
> Boot2003* EFI Network	RC
> Boot8087* Udm
> FvVol(a881d567-6cb0-4eee-8435-2e72d33e45b5)/FvFile(9a9ab4c1-ee1b-488b-b300-24544a7bd418)
> 
> I think you're right about it using the old grub binary. I'm
> embarrassingly unfamiliar with both UEFI and grub, but I'm guessing you
> set the location of grub.cfg at compile time? When I boot
> \EFI\fedora\grubx64.efi, it's pulling the grub.cfg from
> \EFI\redhat\grub.cfg.

Ah yes, so I did not build my own grub I took one from RHEL as that had
32 bit UEFI support before Fedora got it and as I was lazy I copied the
32 bit binary over the 64 bit one, so don't let the filename fool you.

What you could do is install grub2-efi-ia32 from the Fedora 27 repos
and then use efibootmgr to add an entry pointing to \EFI\fedora\grubia32.efi
note that one will look at \EFI\fedora\grub.cfg .

Then see if the problem persists. A second step would be to also install
shim-ia32 and point to that...

Regards,

Hans
