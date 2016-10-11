From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm_crb: encapsulate
 crb_wait_for_reg_32
Date: Tue, 11 Oct 2016 14:29:16 +0300
Message-ID: <20161011112916.GD21688@intel.com>
References: <1476177787-15003-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1476177787-15003-4-git-send-email-jarkko.sakkinen@linux.intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F7FD8@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F7FD8-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 11, 2016 at 10:21:03AM +0000, Winkler, Tomas wrote:
> > Encapsulated crb_wait_for_reg32() so that state changes in other CRB registers
> > than TPM_CRB_CTRL_REQ_x can be waited.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 40 +++++++++++++++++++++++-----------------
> >  1 file changed, 23 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c index
> > c34318b..45f53c2 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -121,6 +121,25 @@ static int __maybe_unused crb_go_idle(struct device
> > *dev, struct crb_priv *priv)
> >  	return 0;
> >  }
> > 
> > +static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
> > +				unsigned long timeout)
> This is a boiler plate register polling function  I would call it _poll_ rather the _wait_
> 
> > +{
> > +	ktime_t start;
> > +	ktime_t stop;
> > +
> > +	start = ktime_get();
> > +	stop = ktime_add(start, ms_to_ktime(timeout));
> > +
> > +	do {
> > +		if ((ioread32(reg) & mask) == value)
> I prefer the register value is synced to  variable, this inlining is
> harder to add adhoc debug prints.  Also you removed the debug print
> out that I know when this settled which is important for catching
> bugs. 

I can add it but can you just briefly explain why the warning
is not enough?

> > +			return true;
> > +
> > +		usleep_range(50, 100);
> How do you know this is correct sleep time, I've tuned that for power
> gating I'm not sure you this fits also for locality. 

Does it matter as long as it is less than for the timeout?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
