From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: Aw: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Fri, 11 Aug 2017 17:32:12 -0400
Message-ID: <9cb350b6-32fd-529e-eb31-6800339cddb2@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
 <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 8/9/2017 5:00 PM, Peter Huewe wrote:
> 
> Since we are the linux kernel, we do have to care for legacy
> devices. And a system with LPC, PS2Mouse on SuperIO and a TPM are not
> that uncommon.
> 
> And heck, we even have support for 1.1b TPM devices....

Understood.  However, remember that SuperIO is a 1980's device that
predates the TPM.  Since the TPM requires special LPC bus cycles, it's
even less likely that an old chipset has an attached TPM.

> Interesting - let me check with Georg tomorrow. Unfortunately I do
> not have access to my tcg mails from home (since I'm not working :), 
> but did you _explicitly_ talk about LPC and the system? I'm sure the
> TPM does not care about the waitstates...

Yes, Infineon was one of the 3 TPM vendors who confirmed this.


