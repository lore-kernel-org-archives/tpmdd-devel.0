From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [backport v4.9] tpm_tis: use default timeout
 value if chip reports it as zero
Date: Wed, 19 Apr 2017 18:12:02 +0300
Message-ID: <20170419151202.kgx73gepo7zqgv2p@intel.com>
References: <20170415152622.14451-1-user@jsakkine-mobl1>
	<420a825b-9845-7029-482c-aec297265107@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <420a825b-9845-7029-482c-aec297265107-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Apr 15, 2017 at 06:04:05PM +0200, Maciej S. Szmigiero wrote:
> Hi Jarkko,
> 
> On 15.04.2017 17:26, Jarkko Sakkinen wrote:
> > From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> > 
> > Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for
> > TPM access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 13.9)
> > no longer works.  The initialization proceeds fine until we get and
> > start using chip-reported timeouts - and the chip reports C and D
> > timeouts of zero.
> > 
> > It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
> > means to override the chip returned timeouts") we had actually let
> > default timeout values remain in this case, so let's bring back this
> > behavior to make chips like Atmel 3203 work again.
> > 
> > Use a common code that was introduced by that commit so a warning is
> > printed in this case and /sys/class/tpm/tpm*/timeouts correctly says the
> > timeouts aren't chip-original.
> > 
> > Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM access")
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> > Backport v4.9. Can you test it?
> >  drivers/char/tpm/tpm-interface.c | 59 ++++++++++++++++++++++------------------
> >  drivers/char/tpm/tpm_tis.c       |  2 +-
> >  drivers/char/tpm/tpm_tis_core.c  |  6 ++--
> >  drivers/char/tpm/tpm_tis_core.h  |  2 +-
> >  4 files changed, 38 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > index 3a9149cf0110..4c914fe25802 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> (..)
> > @@ -537,16 +537,15 @@ int tpm_get_timeouts(struct tpm_chip *chip)
> >  		goto duration;
> >  	}
> > 
> > -	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> > -	    be32_to_cpu(tpm_cmd.header.out.length)
> > -	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
> > -		return -EINVAL;
> > -
> 
> Is this part right?
> These tests weren't removed by this commit as present in the mainline kernel.
> 
> Maciej

No it is not right. It is my bad. Sorry about this. My only excuse
is that I was rushing to the Easter holiday and that is not really
a good excuse.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
