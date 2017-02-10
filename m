From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 6/6] tpm2: add session handle context saving and
 restoring to the space code'
Date: Fri, 10 Feb 2017 21:07:27 +0200
Message-ID: <20170210190727.abaxbbpqq45kb2mm@intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
 <20170208110713.14070-7-jarkko.sakkinen@linux.intel.com>
 <20170210085256.eqhnrmdug2fcz4ql@intel.com>
 <1486743078.2502.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486743078.2502.4.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 10, 2017 at 08:11:18AM -0800, James Bottomley wrote:
> On Fri, 2017-02-10 at 10:52 +0200, Jarkko Sakkinen wrote:
> > On Wed, Feb 08, 2017 at 01:07:08PM +0200, Jarkko Sakkinen wrote:
> > > +		rc = tpm2_load_context(chip, space->session_buf,
> > > +				       &offset, &handle);
> > > +		if (rc == -ENOENT) {
> > > +			/* load failed, just forget session */
> > > +			space->session_tbl[i] = 0;
> > 
> > This is my only concern in this commit. Should we also in this case 
> > just flush the space or not?
> 
> I elected not to.  If the handle is flushed by an external resource
> manager, we get this event.  If the RM and the app agreed to release
> the session handle, then flushing the space would be overkill because
> it would destroy the client session, so simply removing the handle
> works.  If the client tries to use the session again, it gets an error
> and if it doesn't everything just works, which seems to be optimal.
> 
> James

Makes sense. Just wanted the check the logic you had in this decision.

/Jarkko
