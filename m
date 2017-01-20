From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Fri, 20 Jan 2017 15:39:14 +0200
Message-ID: <20170120133914.2wk43nteh2hh7n3c@intel.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
 <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
 <1484751663.2717.10.camel@HansenPartnership.com>
 <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
 <1484828380.3140.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484828380.3140.11.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 19, 2017 at 07:19:40AM -0500, James Bottomley wrote:
> On Thu, 2017-01-19 at 12:49 +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 18, 2017 at 10:01:03AM -0500, James Bottomley wrote:
> > > On Mon, 2017-01-16 at 15:12 +0200, Jarkko Sakkinen wrote:
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > Currently the Resource Manager (RM) is not exposed to userspace. 
> > > >  Make this exposure via a separate device, which can now be 
> > > > opened multiple times because each read/write transaction goes 
> > > > separately via the RM.
> > > > 
> > > > Concurrency is protected by the chip->tpm_mutex for each 
> > > > read/write transaction separately.  The TPM is cleared of all 
> > > > transient objects by the time the mutex is dropped, so there 
> > > > should be no interference between the kernel and userspace.
> > > 
> > > There's actually a missing kfree of context_buf on the tpms_release
> > > path as well.  This patch fixes it up.
> > 
> > Can you send me a fresh version of the whole patch so that I can 
> > include to v4 that includes also changes that I requested in my 
> > recent comments + all the fixes?
> 
> Sure, I think the attached is basically it
> 
> James

Thank you!

/Jarkko
