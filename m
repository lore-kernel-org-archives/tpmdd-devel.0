From: "Peter Huewe" <PeterHuewe@gmx.de>
Subject: Aw: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Wed, 9 Aug 2017 23:00:36 +0200
Message-ID: <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Ken,
(again speaking only on my behalf, not my employer)

> Does anyone know of platforms where this occurs?
> I suspect (but not sure) that the days of SuperIO connecting floppy
> drives, printer ports, and PS/2 mouse ports on the LPC bus are over, and
> such legacy systems will not have a TPM. Would SuperIO even support the
> special TPM LPC bus cycles?

Since we are the linux kernel, we do have to care for legacy devices.
And a system with LPC, PS2Mouse on SuperIO and a TPM are not that uncommon.

And heck, we even have support for 1.1b TPM devices....


>> One more viewpoint: TCG must added the burst count for a reason (might
>> be very well related what Peter said). Is ignoring it something that TCG
>> recommends? Not following standard exactly in the driver code sometimes
>> makes sense on *small details* but I would not say that this a small
>> detail...

> I checked with the TCG's device driver work group (DDWG). Both the spec
> editor and 3 TPM vendors - Infineon, Nuvoton, and ST Micro - agreed that
> ignoring burst count may incur wait states but nothing more. Operations
> will still be successful.

Interesting - let me check with Georg tomorrow.
Unfortunately I do not have access to my tcg mails from home (since I'm not working :), 
but did you _explicitly_ talk about LPC and the system?
I'm sure the TPM does not care about the waitstates...

If my memory does not betray me, 
it is actually possible to "freeze up" a system completly by flooding the lpc bus.
Let me double check tomorrow...


In anycase - I really would like to see a much more performant tpm subsystem - 
however it will be quite an effort with a lot of legacy testing.
(which I unfortunately cannot spend on my private time ... and also of course lacking test systems).

Thanks,
Peter
