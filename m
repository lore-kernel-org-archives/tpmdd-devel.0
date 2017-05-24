From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix byte order related arithmetic
 inconsistency in tpm_getcap()
Date: Wed, 24 May 2017 09:59:50 -0700
Message-ID: <20170524165950.mdaqortjrdhtabke@intel.com>
References: <20170507175002.9558-1-jarkko.sakkinen@linux.intel.com>
	<20170509141353.klo7lilef4qiqfoc@intel.com>
	<20170509151308.GA13586@obsidianresearch.com>
	<20170510123458.fh3ef3c55y2wiu35@intel.com>
	<20170515113602.2jypna4keatq73qy@intel.com>
	<20170515153934.GB3433@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515153934.GB3433-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, May 15, 2017 at 09:39:34AM -0600, Jason Gunthorpe wrote:
> On Mon, May 15, 2017 at 02:36:02PM +0300, Jarkko Sakkinen wrote:
> > On Wed, May 10, 2017 at 03:34:58PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, May 09, 2017 at 09:13:08AM -0600, Jason Gunthorpe wrote:
> > > > On Tue, May 09, 2017 at 05:13:53PM +0300, Jarkko Sakkinen wrote:
> > > > > On Sun, May 07, 2017 at 08:50:02PM +0300, Jarkko Sakkinen wrote:
> > > > > > You should not do arithmetic with __be32 or __le32 types because
> > > > > > sometimes it results incorrect results. Calculations must be done only
> > > > > > with integers that are in in the CPU byte order. This commit migrates
> > > > > > tpm_getcap() to struct tpm_buf in order to sort out these issues.
> > > > > > 
> > > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > Now this should work as Robertos patches move byte order conversion
> > > > > > where it should be. Sadly I'm out of reach to my Dell E6400 laptop
> > > > > > that I use for TPM 1.2 testing.
> > > > > >  drivers/char/tpm/tpm-interface.c | 30 ++++++++++++++++--------------
> > > > > >  drivers/char/tpm/tpm.h           | 13 -------------
> > > > > >  2 files changed, 16 insertions(+), 27 deletions(-)
> > > > > 
> > > > > I've now tested this with TPM 1.2. Any complains?
> > > > 
> > > > Seems reasonable, but which linke had the problematic arithmetic?
> > > > 
> > > > Jason
> > > 
> > > Arithmetic should work but it's not a good practice to do additions,
> > > substractions or multiplications in any other byte order than the CPU
> > > byte order.
> > > 
> > > sparse also complains about this.
> > 
> > Can I get your Reviewed-by for this one?
> 
> Sure, but I'm still wondering what the sparse warning was?
> 
> Jason

This type of errors

drivers/char/tpm//tpm-interface.c:492:42: warning: bad assignment (-=) to restricted __be32

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
