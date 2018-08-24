From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 01/23] TPM: Add new TPMs to the tail of
 the list to prevent inadvertent change of dev
Date: Fri, 24 Aug 2018 09:19:56 +0300
Message-ID: <20180824061956.GA3584@linux.intel.com>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
 <153486701644.13066.13372706238885253812.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <153486701644.13066.13372706238885253812.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Use "tpm" instead of "TPM" in the short summary.

On Tue, Aug 21, 2018 at 04:56:56PM +0100, David Howells wrote:
> Add newly registered TPMs to the tail of the list, not the beginning, so that
> things that are specifying TPM_ANY_NUM don't find that the device they're
> using has inadvertently changed.  Adding a second device would break IMA, for
> instance.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Usually I add Cc-tag before signed-off-by's (and have the first c in
upper case).

Peter's singed-off-by should be accompanied with a co-developed-by tag
if he has participated to the development of this commit.

As far as I see signed-off-by without co-developed-by makes sense in two
occasions:

* You own the subsystem tree i.e. you have to sign the changes that you
  include part of your pull request.
* You are the initial authoer of the change.  

> ---
> 
>  drivers/char/tpm/tpm-interface.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 6af17002a115..cfb9089887bd 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -1122,7 +1122,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
>  
>  	/* Make chip available */
>  	spin_lock(&driver_lock);
> -	list_add_rcu(&chip->list, &tpm_chip_list);

I would add here a comment just as a remainder.
> +	list_add_tail_rcu(&chip->list, &tpm_chip_list);
>  	spin_unlock(&driver_lock);
>  
>  	return chip;

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
