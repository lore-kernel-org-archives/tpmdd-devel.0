From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Mon, 14 Aug 2017 08:12:53 -0400
Message-ID: <1502712773.6179.26.camel@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
         <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
         <20170808191145.kggmoczd5laiccrn@linux.intel.com>
         <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
         <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
         <20170811111421.bg2we53rdeecjtac@linux.intel.com>
         <1502465419.3579.109.camel@linux.vnet.ibm.com>
         <20170814105130.4jjdcop4mqkoxhgh@linux.intel.com>
         <20170814105651.eo3e7tokt7mujeba@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170814105651.eo3e7tokt7mujeba@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Ken Goldman <kgold@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-08-14 at 13:56 +0300, Jarkko Sakkinen wrote:

> > > Since the main concern about this change is breaking old systems that
> > > might potentially have other peripherals hanging off the LPC bus, can
> > > we define a new Kconfig option, with the default as 'N'?
> > > 
> > > Mimi
> > 
> > I guess that could make sense but I would like to hear feedback first.
> > 
> > /Jarkko
> 
> And I'm worried would that it'd be left for many years to come as an
> option.  I do not have any metrics what portion of hardware in the field
> would break if this is turned on.
> 
> It would slow down kernel testing as I would have to run tests for the
> driver with that option turned on and off because it is a major shift
> from how driver functions. And I have zero idea how long I would go on
> doing this.
> 
> One maybe a little bit better option would be to have a sysfs attribute
> for this functionality (disable_burst_count). What do you think about
> that?

That works!  So we'll define a module_param named disable_burst_count,
which can be specified on the boot command line.

Mimi

