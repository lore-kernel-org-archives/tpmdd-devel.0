From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/4] Small fixes and cleanups for tpm_crb
Date: Sat, 3 Sep 2016 09:41:49 +0300
Message-ID: <20160903064149.GA7543@intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160903062754.GA2223@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160903062754.GA2223@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Sep 03, 2016 at 09:27:54AM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2016 at 10:34:16PM +0300, Jarkko Sakkinen wrote:
> > A set of small fixes and clean ups for tpm_crb.
> > 
> > Jarkko Sakkinen (4):
> >   tpm_crb: fix crb_req_canceled behavior
> >   tpm_crb: remove wmb()'s
> >   tpm_crb: refine the naming of constants
> >   tpm_crb: fix incorrect values of cmdReady and goIdle bits
> > 
> >  drivers/char/tpm/tpm_crb.c | 32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> I guess these should be no-brainers?

Actually I'm picking these patches to my runtime PM patch set.
Still reviews are always welcome of course.

/Jarkko
