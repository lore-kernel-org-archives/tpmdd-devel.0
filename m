From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 1/2] tpm: do not suspend/resume if power stays on
Date: Thu, 31 May 2018 02:56:21 +0300
Message-ID: <20180530235621.GA32293@linux.intel.com>
References: <20180530204440.27299-1-jarkko.sakkinen@linux.intel.com>
 <20180530204440.27299-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530204440.27299-2-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>, Sonny Rao <sonnyrao@chromium.org>, James Morris <james.l.morris@oracle.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 30, 2018 at 11:44:39PM +0300, Jarkko Sakkinen wrote:
> From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> 
> commit b5d0ebc99bf5d0801a5ecbe958caa3d68b8eaee8 upstream
> 
> The suspend/resume behavior of the TPM can be controlled by setting
> "powered-while-suspended" in the DTS. This is useful for the cases
> when hardware does not power-off the TPM.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> ---
>  drivers/char/tpm/tpm-chip.c      | 12 ++++++++++++
>  drivers/char/tpm/tpm-interface.c |  3 +++
>  drivers/char/tpm/tpm.h           |  1 +
>  3 files changed, 16 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index a0d9ac6b6cc9..a8d7220f613c 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -324,8 +324,20 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
>   */
>  int tpm_chip_register(struct tpm_chip *chip)
>  {
> +#ifdef CONFIG_TCG_IBMVTPM
> +	struct device_node *np;
> +#endif
>  	int rc;
>  
> +#ifdef CONFIG_TCG_IBMVTPM
> +	np = of_find_node_by_name(NULL, "vtpm");
> +	if (!np)
> +		return -ENODEV;
> +	if (of_property_read_bool(np, "powered-while-suspended"))
> +		chip->flags |= TPM_CHIP_FLAG_ALWAYS_POWERED;
> +	of_node_put(np);
> +#endif

I'll have to revise this as more config flag should be CONFIG_OF
and property should be conditionally read if the node is found.
Then it can be relocated without interference.

/Jarkko
