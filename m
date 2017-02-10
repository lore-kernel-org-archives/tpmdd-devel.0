From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 6/6] tpm2: add session handle context
 saving and restoring to the space code
Date: Fri, 10 Feb 2017 21:10:04 +0200
Message-ID: <20170210191004.yv5hgnd3h5scj5zt@intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
	<20170208110713.14070-7-jarkko.sakkinen@linux.intel.com>
	<20170210123249.nrppoez2kdr2q4nw@intel.com>
	<1486743431.2502.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486743431.2502.6.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 10, 2017 at 08:17:11AM -0800, James Bottomley wrote:
> On Fri, 2017-02-10 at 14:32 +0200, Jarkko Sakkinen wrote:
> > On Wed, Feb 08, 2017 at 01:07:08PM +0200, Jarkko Sakkinen wrote:
> > > From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> [...] 
> > > +static int tpm2_session_add(struct tpm_chip *chip, u32 handle)
> > > +{
> > > +	struct tpm_space *space = &chip->work_space;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
> > > +		if (space->session_tbl[i] == 0)
> > > +			break;
> > > +	if (i == ARRAY_SIZE(space->session_tbl)) {
> > > +		dev_err(&chip->dev, "out of session slots\n");
> > 
> > This really should be dev_dbg.
> 
> This was my reply to the comment the last time:
> 
>     I can do that, but I think this should be higher than debug.  If
>     this trips, something an application was doing will fail with a non
>     TPM error and someone may wish to investigate why.  Having a kernel
>     message would help with that (but they won't see it if it's debug).
> 
>     I'm also leaning towards the idea that we should actually have one
>     more _tbl slot than we know the TPM does, so that if someone goes
>     over it's the TPM that gives them a real TPM out of memory error
>     rather than the space code returning -ENOMEM.
> 
>     If you agree, I think it should be four for both sessions_tbl and
>     context_tbl.
> 
> So I really don't think it should be debug.  Could we compromise on
> dev_info?
> 
> James

Oops, I'm sorry about that. I use the release chaos as an excuse :-)
I would lower it to dev_warn().

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
