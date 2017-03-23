From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] tpm2: fix off-by-one comparison and out-of-bounds read
 error
Date: Thu, 23 Mar 2017 19:42:09 +0300
Message-ID: <20170323164209.GO32449@mwanda>
References: <20170320142336.10997-1-colin.king@canonical.com>
 <20170322114256.pdwg6buj2wkhcooy@intel.com>
 <d96bb5c9-e1b3-abe5-2273-fc525dc00190@canonical.com>
 <20170322131248.GJ32449@mwanda>
 <20170323155358.jpotoweghjnl4vjx@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323155358.jpotoweghjnl4vjx@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Colin Ian King <colin.king@canonical.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 23, 2017 at 05:53:58PM +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 22, 2017 at 04:12:49PM +0300, Dan Carpenter wrote:
> > On Wed, Mar 22, 2017 at 11:45:37AM +0000, Colin Ian King wrote:
> > > On 22/03/17 11:42, Jarkko Sakkinen wrote:
> > > > On Mon, Mar 20, 2017 at 02:23:36PM +0000, Colin King wrote:
> > > >> From: Colin Ian King <colin.king@canonical.com>
> > > >>
> > > >> The comparison of an out of range index into space->context_tbl is
> > > >> off-by-one and should be using >= rather than > in the comparison.
> > > >>
> > > >> Detected by CoverityScan, CID#1419694 ("Out-of-bounds read")
> > > >>
> > > >> Fixes: 849246e7ce9ce ("tpm2: add session handle context saving and restoring to the space code")
> > > >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > >> ---
> > > >>  drivers/char/tpm/tpm2-space.c | 2 +-
> > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >>
> > > >> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> > > >> index d36d81e07076..009934269514 100644
> > > >> --- a/drivers/char/tpm/tpm2-space.c
> > > >> +++ b/drivers/char/tpm/tpm2-space.c
> > > >> @@ -229,7 +229,7 @@ static bool tpm2_map_to_phandle(struct tpm_space *space, void *handle)
> > > >>  	int i;
> > > >>  
> > > >>  	i = 0xFFFFFF - (vhandle & 0xFFFFFF);
> > > >> -	if (i > ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
> > > >> +	if (i >= ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
> > > >>  		return false;
> > > >>  
> > > >>  	phandle = space->context_tbl[i];
> > > >> -- 
> > > >> 2.11.0
> > > > 
> > > > Thanks. If you don't mind, I would squash this to that patch?
> > > > 
> > > > /Jarkko
> > > > 
> > > Sure squash it, and maybe add a Reported-by: Colin Ian King
> > > <colin.king@canonical.com> if that's OK with you.
> > 
> > Reported-by isn't really correct though...  We should have a Fixes-from:
> > tag for squashed fixes.
> > 
> > regards,
> > dan carpenter
> 
> Hmm... Maybe so depending on how you interpret Reported-by but
> Fixes-from is not something that is used at the moment, is it?

No, but we should create it.

regards,
dan carpenter
