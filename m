From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [patch] tpm: silence an array overflow warning
Date: Mon, 6 Feb 2017 16:15:20 +0200
Message-ID: <20170206141520.nc7v4u2dysv3lsgj@intel.com>
References: <20170203103040.GA5467@mwanda>
	<20170203181120.d3r7ab4twbvelwmi@intel.com>
	<20170206092007.GA11103@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170206092007.GA11103@mwanda>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 06, 2017 at 12:20:07PM +0300, Dan Carpenter wrote:
> On Fri, Feb 03, 2017 at 08:11:20PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Feb 03, 2017 at 01:30:40PM +0300, Dan Carpenter wrote:
> > > We should check that we're within bounds first before checking that
> > > "chip->active_banks[i] != TPM2_ALG_ERROR" so I've re-ordered the two
> > > checks.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > Thank you, good catch! Do you mind if I squash this.
> > 
> 
> Not at all.
> 
> regards,
> dan carpenter

Already went as a separate commit in a pull request to James :-)

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
