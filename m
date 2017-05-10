From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix byte order related arithmetic inconsistency in
 tpm_getcap()
Date: Wed, 10 May 2017 15:34:58 +0300
Message-ID: <20170510123458.fh3ef3c55y2wiu35@intel.com>
References: <20170507175002.9558-1-jarkko.sakkinen@linux.intel.com>
 <20170509141353.klo7lilef4qiqfoc@intel.com>
 <20170509151308.GA13586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509151308.GA13586@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 09, 2017 at 09:13:08AM -0600, Jason Gunthorpe wrote:
> On Tue, May 09, 2017 at 05:13:53PM +0300, Jarkko Sakkinen wrote:
> > On Sun, May 07, 2017 at 08:50:02PM +0300, Jarkko Sakkinen wrote:
> > > You should not do arithmetic with __be32 or __le32 types because
> > > sometimes it results incorrect results. Calculations must be done only
> > > with integers that are in in the CPU byte order. This commit migrates
> > > tpm_getcap() to struct tpm_buf in order to sort out these issues.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Now this should work as Robertos patches move byte order conversion
> > > where it should be. Sadly I'm out of reach to my Dell E6400 laptop
> > > that I use for TPM 1.2 testing.
> > >  drivers/char/tpm/tpm-interface.c | 30 ++++++++++++++++--------------
> > >  drivers/char/tpm/tpm.h           | 13 -------------
> > >  2 files changed, 16 insertions(+), 27 deletions(-)
> > 
> > I've now tested this with TPM 1.2. Any complains?
> 
> Seems reasonable, but which linke had the problematic arithmetic?
> 
> Jason

Arithmetic should work but it's not a good practice to do additions,
substractions or multiplications in any other byte order than the CPU
byte order.

sparse also complains about this.

/Jarkko
