From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Mon, 14 Aug 2017 13:56:51 +0300
Message-ID: <20170814105651.eo3e7tokt7mujeba@linux.intel.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
 <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
 <20170811111421.bg2we53rdeecjtac@linux.intel.com>
 <1502465419.3579.109.camel@linux.vnet.ibm.com>
 <20170814105130.4jjdcop4mqkoxhgh@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170814105130.4jjdcop4mqkoxhgh@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Ken Goldman <kgold@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 14, 2017 at 01:51:30PM +0300, Jarkko Sakkinen wrote:
> On Fri, Aug 11, 2017 at 11:30:19AM -0400, Mimi Zohar wrote:
> > On Fri, 2017-08-11 at 14:14 +0300, Jarkko Sakkinen wrote:
> > > On Wed, Aug 09, 2017 at 11:00:36PM +0200, Peter Huewe wrote:
> > > > Hi Ken,
> > > > (again speaking only on my behalf, not my employer)
> > > > 
> > > > > Does anyone know of platforms where this occurs?
> > > > > I suspect (but not sure) that the days of SuperIO connecting floppy
> > > > > drives, printer ports, and PS/2 mouse ports on the LPC bus are over, and
> > > > > such legacy systems will not have a TPM. Would SuperIO even support the
> > > > > special TPM LPC bus cycles?
> > > > 
> > > > Since we are the linux kernel, we do have to care for legacy devices.
> > > > And a system with LPC, PS2Mouse on SuperIO and a TPM are not that uncommon.
> > > > 
> > > > And heck, we even have support for 1.1b TPM devices....
> > > > 
> > > > 
> > > > >> One more viewpoint: TCG must added the burst count for a reason (might
> > > > >> be very well related what Peter said). Is ignoring it something that TCG
> > > > >> recommends? Not following standard exactly in the driver code sometimes
> > > > >> makes sense on *small details* but I would not say that this a small
> > > > >> detail...
> > > > 
> > > > > I checked with the TCG's device driver work group (DDWG). Both the spec
> > > > > editor and 3 TPM vendors - Infineon, Nuvoton, and ST Micro - agreed that
> > > > > ignoring burst count may incur wait states but nothing more. Operations
> > > > > will still be successful.
> > > > 
> > > > Interesting - let me check with Georg tomorrow.
> > > > Unfortunately I do not have access to my tcg mails from home (since I'm not working :), 
> > > > but did you _explicitly_ talk about LPC and the system?
> > > > I'm sure the TPM does not care about the waitstates...
> > > > 
> > > > If my memory does not betray me, 
> > > > it is actually possible to "freeze up" a system completly by flooding the lpc bus.
> > > > Let me double check tomorrow...
> > > > 
> > > > 
> > > > In anycase - I really would like to see a much more performant tpm subsystem - 
> > > > however it will be quite an effort with a lot of legacy testing.
> > > > (which I unfortunately cannot spend on my private time ... and also of course lacking test systems).
> > > > 
> > > > Thanks,
> > > > Peter
> > > 
> > > I would like to see tpm_msleep() wrapper to replace current msleep()
> > > usage across the subsystem before considering this. I.e. wrapper that
> > > internally uses usleep_range(). This way we can mechanically convert
> > > everything to a more low latency option.
> > 
> > Fine.  I assume you meant tpm_sleep(), not tpm_msleep().
> 
> I think it would sense to have a function that takes msecs because msecs
> are mostly used everywhere in the subsystem. This way we don't have to
> change any of the existing constants.
> 
> > > This should have been done already for patch that Mini and Nayna
> > > provided instead of open coding stuff.
> > 
> > At that time, we had no idea what caused the major change in TPM
> > performance.  We only knew that the change occurred somewhere between
> > linux-4.7 and linux-4.8.  Even after figuring out it was the change to
> > msleep(), we were hoping that msleep() would be fixed.  So your
> > comment, that we should have done it differently back then, is
> > unwarranted.
> 
> I wasn't trying to point the blame to you at all. I didn't bring this to
> table back then myself. I agree what you are saying.
> 
> I was mainly trying to explain why I think it should be done this way
> now while I didn't suggest it back then :-)
> 
> > > That change is something that can be applied right now. On the other
> > > hand, this is a very controversial change.
> > 
> > Since the main concern about this change is breaking old systems that
> > might potentially have other peripherals hanging off the LPC bus, can
> > we define a new Kconfig option, with the default as 'N'?
> > 
> > Mimi
> 
> I guess that could make sense but I would like to hear feedback first.
> 
> /Jarkko

And I'm worried would that it'd be left for many years to come as an
option.  I do not have any metrics what portion of hardware in the field
would break if this is turned on.

It would slow down kernel testing as I would have to run tests for the
driver with that option turned on and off because it is a major shift
from how driver functions. And I have zero idea how long I would go on
doing this.

One maybe a little bit better option would be to have a sysfs attribute
for this functionality (disable_burst_count). What do you think about
that?

/Jarkko
