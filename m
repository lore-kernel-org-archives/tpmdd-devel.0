From: "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device link /dev/tpms<n>
Date: Sun, 26 Feb 2017 12:30:40 -0600
Message-ID: <20170226183040.GA4272@wind.enjellic.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com> <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com> <20170223090917.jq7thil5ggjmagil@intel.com> <1487941328.2249.23.camel@HansenPartnership.com> <20170226114440.5ksg3lx27ylekvbx@intel.com>
Reply-To: "Dr. Greg Wettstein" <greg@enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170226114440.5ksg3lx27ylekvbx@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, dhowells@redhat.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, kgold@linux.vnet.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Feb 26, 2017 at 01:44:40PM +0200, Jarkko Sakkinen wrote:

Good day, I hope this note finds the week starting well for everyone.

> On Fri, Feb 24, 2017 at 08:02:08AM -0500, James Bottomley wrote:
> > On Thu, 2017-02-23 at 11:09 +0200, Jarkko Sakkinen wrote:
> > > On Thu, Feb 16, 2017 at 09:25:19PM +0200, Jarkko Sakkinen wrote:
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > Currently the tpm spaces are not exposed to userspace.  Make this
> > > > exposure via a separate device, which can now be opened multiple 
> > > > times because each read/write transaction goes separately via the
> > > > space.
> > > > 
> > > > Concurrency is protected by the chip->tpm_mutex for each read/write
> > > > transaction separately.  The TPM is cleared of all transient 
> > > > objects by the time the mutex is dropped, so there should be no
> > > > interference between the kernel and userspace.
> > > > Signed-off-by: James Bottomley <
> > > > 
> > > > James.Bottomley@HansenPartnershp.com>
> > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
> > > Tested-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
> > 
> > Thanks!
> > 
> > > Nitpicking but I've been thinking about naming. What about calling 
> > > the device as tpmrc0 as in resource context. I think that would be a
> > > better name than TPM space.
> > 
> > Well the original name was tpmrm<n> for TPM with Resource Manager.  You
> > wanted it to be tpms<n> for TPM with Spaces.
> > 
> > I'm not entirely sold on the Resource Context name ... I think
> > Resource Manager (because it's what the TCG calls it) or Spaces
> > (because it's what all the code comments call it) are better.
> > Resource Context sounds like what TPM2_SaveContext() creates for you
> > rather than the interface.
> > 
> > >  You do not mix it up with namespaces and/or virtualization. With
> > > resource in front it cannot be easily mixed up with TPM contexts
> > > either.
> > 
> > I'm a containers person.  What this set of patches does is precisely OS
> > level virtualization in my book, so I don't think you need to pretend
> > it is't; and OS level virtualization is what a namespace does.  The
> > only difference between this and the other kernel namespaces is that
> > you get a new namespace automatically when you open the device and you
> > can't enter an existing namespace.
> > 
> > I think therefore that tpmns<n> for TPM Namespace would be very
> > appropriate.

> Sorry for going back and forth with this but I turn it back to your
> original tpmrm. It's in the end of the day the least confusing
> option. I think this has been anyway useful to trip a bit around the
> options because it is hard to rollback API...

Indeed, which is why we have watched this conversation with some
interest regarding exactly what the tpm{rm,ns} will represent.

In order to get a handle on how the resource manager will affect
Trusted Execution Technology (TXT) environments we downloaded your
branch and experimented with it a bit.  Our overall impression is that
it will be important to educate the user community on exactly what the
'tpm spaces' management device actually represents.

It is not a TPM device as much as it is a method of surfacing a subset
of TPM functionality over the lifespan of a file descriptor.  There is
certainly nothing wrong with this but users and system administrators
will need to understand the implications of this and not confuse the
two devices.

For example, Ken's tools which come in his TSS2 library, don't work
properly with the 'spaces' device due to the virtualization lifetime.
As an example, the getcapability call will 'lie' about the number of
transient handles which are available through the device.  Attempts to
string multiple transaction sequences together will fail as well.

So I think it will be important to stress that the 'spaces' device is
something an individual application will use to gain unimpeded access
to TPM functionality and not a representation of the device itself.
Given the quality of userspace simulators and their flexibility and
operational fidelity, I anticipate we will eventually come to the
conclusion that this problem will have been best solved by creating
and adopting a framework which provides the anchoring and spawning of
userspace TPM2 instances.

Just as an aside we still haven't been able to verify the
inter-operability of the 'spaces' driver with TXT.  There are larger
TXT/TPM2 operational issues which we are working to run down before we
can determine how the two systems will inter-operate or not.

> /Jarkko

Have a good day.

Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"You've got to be kidding me Nate.  You've seen the shit that has come
 through my office in the last two hours.  You think I'm even remotely
 worried about one SATA cable being six inches longer than the other."
                                -- Dr. Greg Wettstein
                                   Resurrection
