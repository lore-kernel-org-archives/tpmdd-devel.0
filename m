From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm2: fix off-by-one comparison and
 out-of-bounds read error
Date: Thu, 23 Mar 2017 20:12:25 +0200
Message-ID: <20170323181225.3hz4rsuzr35yk7uw@intel.com>
References: <20170320142336.10997-1-colin.king@canonical.com>
	<20170322114256.pdwg6buj2wkhcooy@intel.com>
	<d96bb5c9-e1b3-abe5-2273-fc525dc00190@canonical.com>
	<20170322131248.GJ32449@mwanda>
	<20170323155358.jpotoweghjnl4vjx@intel.com>
	<20170323164209.GO32449@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323164209.GO32449@mwanda>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 23, 2017 at 07:42:09PM +0300, Dan Carpenter wrote:
> On Thu, Mar 23, 2017 at 05:53:58PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Mar 22, 2017 at 04:12:49PM +0300, Dan Carpenter wrote:
> > > On Wed, Mar 22, 2017 at 11:45:37AM +0000, Colin Ian King wrote:
> > > > On 22/03/17 11:42, Jarkko Sakkinen wrote:
> > > > > On Mon, Mar 20, 2017 at 02:23:36PM +0000, Colin King wrote:
> > > > >> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > > >>
> > > > >> The comparison of an out of range index into space->context_tbl is
> > > > >> off-by-one and should be using >= rather than > in the comparison.
> > > > >>
> > > > >> Detected by CoverityScan, CID#1419694 ("Out-of-bounds read")
> > > > >>
> > > > >> Fixes: 849246e7ce9ce ("tpm2: add session handle context saving and restoring to the space code")
> > > > >> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > > >> ---
> > > > >>  drivers/char/tpm/tpm2-space.c | 2 +-
> > > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >>
> > > > >> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> > > > >> index d36d81e07076..009934269514 100644
> > > > >> --- a/drivers/char/tpm/tpm2-space.c
> > > > >> +++ b/drivers/char/tpm/tpm2-space.c
> > > > >> @@ -229,7 +229,7 @@ static bool tpm2_map_to_phandle(struct tpm_space *space, void *handle)
> > > > >>  	int i;
> > > > >>  
> > > > >>  	i = 0xFFFFFF - (vhandle & 0xFFFFFF);
> > > > >> -	if (i > ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
> > > > >> +	if (i >= ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
> > > > >>  		return false;
> > > > >>  
> > > > >>  	phandle = space->context_tbl[i];
> > > > >> -- 
> > > > >> 2.11.0
> > > > > 
> > > > > Thanks. If you don't mind, I would squash this to that patch?
> > > > > 
> > > > > /Jarkko
> > > > > 
> > > > Sure squash it, and maybe add a Reported-by: Colin Ian King
> > > > <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> if that's OK with you.
> > > 
> > > Reported-by isn't really correct though...  We should have a Fixes-from:
> > > tag for squashed fixes.
> > > 
> > > regards,
> > > dan carpenter
> > 
> > Hmm... Maybe so depending on how you interpret Reported-by but
> > Fixes-from is not something that is used at the moment, is it?
> 
> No, but we should create it.
> 
> regards,
> dan carpenter

Fully agreed. Using reported-by in the commit in question implies as if
the whole commit was proposed by Colin.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
