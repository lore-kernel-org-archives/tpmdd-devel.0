From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device link /dev/tpms<n>
Date: Fri, 24 Feb 2017 19:39:22 +0200
Message-ID: <20170224173922.qwuhfxeitbyct52o@intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
 <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
 <20170223090917.jq7thil5ggjmagil@intel.com>
 <1487941328.2249.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487941328.2249.23.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, dhowells@redhat.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 08:02:08AM -0500, James Bottomley wrote:
> On Thu, 2017-02-23 at 11:09 +0200, Jarkko Sakkinen wrote:
> > On Thu, Feb 16, 2017 at 09:25:19PM +0200, Jarkko Sakkinen wrote:
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > 
> > > Currently the tpm spaces are not exposed to userspace.  Make this
> > > exposure via a separate device, which can now be opened multiple 
> > > times because each read/write transaction goes separately via the
> > > space.
> > > 
> > > Concurrency is protected by the chip->tpm_mutex for each read/write
> > > transaction separately.  The TPM is cleared of all transient 
> > > objects by the time the mutex is dropped, so there should be no
> > > interference between the kernel and userspace.
> > > Signed-off-by: James Bottomley <
> > > 
> > > James.Bottomley@HansenPartnershp.com>
> 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
> > Tested-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
> 
> Thanks!
> 
> > Nitpicking but I've been thinking about naming. What about calling 
> > the device as tpmrc0 as in resource context. I think that would be a
> > better name than TPM space.
> 
> Well the original name was tpmrm<n> for TPM with Resource Manager.  You
> wanted it to be tpms<n> for TPM with Spaces.
> 
> I'm not entirely sold on the Resource Context name ... I think Resource Manager (because it's what the TCG calls it) or Spaces (because it's what all the code comments call it) are better.  Resource Context sounds like what TPM2_SaveContext() creates for you rather than the interface.
> 
> >  You do not mix it up with namespaces and/or virtualization. With
> > resource in front it cannot be easily mixed up with TPM contexts
> > either.
> 
> I'm a containers person.  What this set of patches does is precisely OS
> level virtualization in my book, so I don't think you need to pretend
> it is't; and OS level virtualization is what a namespace does.  The
> only difference between this and the other kernel namespaces is that
> you get a new namespace automatically when you open the device and you
> can't enter an existing namespace.
> 
> I think therefore that tpmns<n> for TPM Namespace would be very
> appropriate.

Makes sense. We can go with tpmns.

/Jarkko
