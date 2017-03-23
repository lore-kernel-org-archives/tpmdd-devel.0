From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Thu, 23 Mar 2017 17:56:46 +0200
Message-ID: <20170323155646.2xauos5pjjscg5pg@intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
 <20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
 <58AC85F2.5000406@linux.vnet.ibm.com>
 <1487785159.2376.27.camel@HansenPartnership.com>
 <f8d414fa-03f9-2c22-8ddf-497c1d281536@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8d414fa-03f9-2c22-8ddf-497c1d281536@us.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 22, 2017 at 04:09:21PM -0400, Ken Goldman wrote:
> On 2/22/2017 12:39 PM, James Bottomley wrote:
> > 
> > Right at the moment the kernel use of tpm2 looks like
> > 
> > acquire chip->tpm_mutex
> > load key
> > process key
> > unload key
> > release chip->tpm_mutex
> > 
> > While it does this, there's no need for it to have a RM interface
> > because what it does between the acquisition and drop of the mutex
> > can't be seen by or have any effect on userspace (whether it uses the
> > RM or not).  So currently, the question doesn't arise, which is the
> > situation you see.
> 
> 1 - This appears to depend on the RM not releasing the mutex until all
> objects are swapped out.  Correct?  Same for sessions?

Yes.

> 2 - A startauthsession can cause a regap error.  Does the above depend on
> the RM doing early regapping so the RM won't see that error?

We are not trying to resolve that for 4.12. It can happen.

> 3 - There's also the problem where the TPM saved session slots (typically
> 64) are full.  My intuition is that the best solution is for the RM to
> reserve 3 slots for the kernel.

Maybe but at the moment kernel does not use sessions.

/Jarkko
