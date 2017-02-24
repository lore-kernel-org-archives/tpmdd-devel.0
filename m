From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Fri, 24 Feb 2017 19:02:38 +0200
Message-ID: <20170224170238.pfkx7vgkgp7t34wi@intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
 <20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
 <1487940802.2249.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487940802.2249.14.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, dhowells@redhat.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 07:53:22AM -0500, James Bottomley wrote:
> On Thu, 2017-02-16 at 21:25 +0200, Jarkko Sakkinen wrote:
> > Added an ability to virtualize TPM commands into an isolated context
> > that we call a TPM space because the word context is already heavily
> > used in the TPM specification. Both the handle areas and bodies
> > (where
> > necessary) are virtualized.
> > 
> > The mechanism works by adding a new parameter struct tpm_space to the
> > tpm_transmit() function. This new structure contains the list of
> > virtual
> > handles and a buffer of page size (currently) for backing storage.
> > 
> > When tpm_transmit() is called with a struct tpm_space instance it
> > will
> > execute the following sequence:
> > 
> > 1. Take locks.
> > 2. Load transient objects from the backing storage by using
> > ContextLoad
> >    and map virtual handles to physical handles.
> > 3. Perform the transaction.
> > 4. Save transient objects to backing storage by using ContextSave and
> >    map resulting physical handle to virtual handle if there is such.
> > 
> > This commit does not implement virtualization support for hmac and
> > policy sessions.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> For patches 1-4 you can add 
> 
> Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Just re-running a build with the latest kernel for my laptop to add
> tested by.
> 
> James

Thank you!

/Jarkko
