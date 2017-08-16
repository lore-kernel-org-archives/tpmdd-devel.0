From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send() performance
 by ignoring burstcount
Date: Wed, 16 Aug 2017 12:24:23 +0200
Message-ID: <20170816122423.315817c7@kitsune.suse.cz>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
        <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
        <20170808191145.kggmoczd5laiccrn@linux.intel.com>
        <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
        <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
        <9cb350b6-32fd-529e-eb31-6800339cddb2@linux.vnet.ibm.com>
        <20170814015359.30177c87@naga>
        <869cc1b1-0836-a53b-31d7-9fec50d8cc52@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <869cc1b1-0836-a53b-31d7-9fec50d8cc52@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 15 Aug 2017 18:02:57 -0400
Ken Goldman <kgold@linux.vnet.ibm.com> wrote:

> On 8/13/2017 7:53 PM, msuchanek wrote:
> > About 500 out of 700 mainboards sold today has a PS/2 port which is
> > probably due to prevalence of legacy devices and usbhid limitations.
> > 
> > Similarily many boards have serial and parallel hardware ports.
> > 
> > In all diagrams detailed enough to show these ports I have seen them
> > attached to the LPC bus.  
> 
> Do these boards have a TPM?  Remember that the TPM requires special
> LPC bus cycles.

Out of nearly 700 boards over 500 have PS/2 connector and over 400
have TPM slot (which is subset of the PS/2 enabled boards). Some more
possibly have on-board TPM chip.

> 
> Even if so, the TPM LPC bus wait states are less than a usec.  My 
> thought is that  it's unlikely that any device (serial port, mouse, 
> keyboard, printer) will be adversely affected.

Yes, in theory this is negligible. So unless there is a possibility
these wait states chain or the device otherwise takes over the bus for
extended period of time this should be fine.

Thanks

Michal
