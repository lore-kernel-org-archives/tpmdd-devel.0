From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: consolidate the TPM startup code
Date: Tue, 20 Jun 2017 23:46:22 +0200
Message-ID: <20170620214622.lqt72f6fiqgno2rh@linux.intel.com>
References: <20170620181334.28363-1-jarkko.sakkinen@linux.intel.com>
	<20170620193152.GA3368@obsidianresearch.com>
	<20170620205529.ku3nueglj3mqkd3s@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170620205529.ku3nueglj3mqkd3s-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
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

On Tue, Jun 20, 2017 at 10:55:29PM +0200, Jarkko Sakkinen wrote:
> On Tue, Jun 20, 2017 at 01:31:52PM -0600, Jason Gunthorpe wrote:
> > On Tue, Jun 20, 2017 at 08:13:34PM +0200, Jarkko Sakkinen wrote:
> > > Consolidated all the "manual" TPM startup code to a single function
> > > in order to make code flows a bit cleaner and migrate to tpm_buf.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >  drivers/char/tpm/tpm-interface.c | 67 +++++++++++++++++++++++++---------------
> > >  drivers/char/tpm/tpm.h           |  6 +---
> > >  drivers/char/tpm/tpm2-cmd.c      | 32 +------------------
> > >  3 files changed, 44 insertions(+), 61 deletions(-)
> > 
> > Makes sense to me
> > 
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index d2b4df6d9894..fbef47d8bd06 100644
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -540,6 +540,47 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> > >  }
> > >  EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
> > >  
> > > +#define TPM_ORD_STARTUP 153
> > > +#define TPM_ST_CLEAR 1
> > 
> > We should really have a tpm1.h and tpm2.h that has all these various
> > constants and things instead of open coding them randomly all over..
> > 
> > Jason
> 
> I agree.

I agree means here that I agree if you mean only protocol specific
constants. I do not think it would make sense with things like struct
tpm_readpubek_out that is a throw away only used by that one function as
helper (would compare it to a helper function). It would only make
reading the code slower.

It would make sense, for example, to have enum tpm_ordinals for all
TPM 1.2 ordinals in tpm1_proto.h (yes would add _proto for clarity).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
