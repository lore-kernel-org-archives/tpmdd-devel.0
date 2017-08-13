From: msuchanek <msuchanek@suse.de>
Subject: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send() performance
 by ignoring burstcount
Date: Mon, 14 Aug 2017 01:53:59 +0200
Message-ID: <20170814015359.30177c87@naga>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
        <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
        <20170808191145.kggmoczd5laiccrn@linux.intel.com>
        <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
        <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
        <9cb350b6-32fd-529e-eb31-6800339cddb2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <9cb350b6-32fd-529e-eb31-6800339cddb2@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hello,

On Fri, 11 Aug 2017 17:32:12 -0400
Ken Goldman <kgold@linux.vnet.ibm.com> wrote:

> On 8/9/2017 5:00 PM, Peter Huewe wrote:
> > 
> > Since we are the linux kernel, we do have to care for legacy
> > devices. And a system with LPC, PS2Mouse on SuperIO and a TPM are
> > not that uncommon.
> > 
> > And heck, we even have support for 1.1b TPM devices....  
> 
> Understood.  However, remember that SuperIO is a 1980's device that
> predates the TPM.  Since the TPM requires special LPC bus cycles, it's
> even less likely that an old chipset has an attached TPM.

Where are the PS/2 ports attached today? 

About 500 out of 700 mainboards sold today has a PS/2 port which is
probably due to prevalence of legacy devices and usbhid limitations.

Similarily many boards have serial and parallel hardware ports.

In all diagrams detailed enough to show these ports I have seen them
attached to the LPC bus.

Thanks

Michal
