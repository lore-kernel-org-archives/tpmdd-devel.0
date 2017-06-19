From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: initialise priv->cmd_size sooner
Date: Mon, 19 Jun 2017 02:13:38 +0200
Message-ID: <1497831218.2552.12.camel@linux.intel.com>
References: <20170616194848.232936-1-manuel.lauss@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170616194848.232936-1-manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Manuel Lauss <manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-06-16 at 21:48 +0200, Manuel Lauss wrote:
> priv->cmd_size is never initialised if  the cmd and rsp buffers reside
> at different addresses.  Move initialisation to right after the buffer
> was mapped.
> 
> This bug was introduced by commit aa77ea0e43dc5bb0c1dcc9bad76afa
> ("tpm/tpm_crb: cache cmd_size register value.").

Please, use a Fixes tag.

> Signed-off-by: Manuel Lauss <manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_crb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index b917b9d5f710..17d846d00417 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -495,6 +495,8 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		goto out;
>  	}
>  
> +	priv->cmd_size = cmd_size;
> +

Should be done only if rsp is succesfully mapped.

>  	memcpy_fromio(&rsp_pa, &priv->regs_t->ctrl_rsp_pa, 8);
>  	rsp_pa = le64_to_cpu(rsp_pa);
>  	rsp_size = crb_fixup_cmd_size(dev, &io_res, rsp_pa,
> @@ -515,8 +517,6 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		goto out;
>  	}
>  
> -	priv->cmd_size = cmd_size;
> -
>  	priv->rsp = priv->cmd;
>  
>  out:

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
