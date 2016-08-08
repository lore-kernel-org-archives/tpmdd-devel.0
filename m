From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix build error
Date: Mon, 8 Aug 2016 23:27:58 +0300
Message-ID: <20160808202758.GA32391@intel.com>
References: <1470687926-32267-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470687926-32267-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

As the fix is quite trivial I already pushed this fixup on tip of my
master branch in order to make testing easy.

/Jarkko

On Mon, Aug 08, 2016 at 11:25:26PM +0300, Jarkko Sakkinen wrote:
> tpm_getcap and tpm2_get_tpm_pt were not properly exported. This commit
> adds the exports. The build error exist only in the master (bleeding
> edge) branch so this problem does not concern 4.8 release.
> 
> The commit will be folded to 4d970e733b09 as soon as it is tested and
> reviewed.
> 
> Fixes: 4d970e733b09
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-interface.c | 1 +
>  drivers/char/tpm/tpm2-cmd.c      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index ef5ad80..43ef0ef 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -458,6 +458,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
>  		*cap = tpm_cmd.params.getcap_out.cap;
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(tpm_getcap);
>  
>  #define TPM_ORD_STARTUP cpu_to_be32(153)
>  #define TPM_ST_CLEAR cpu_to_be16(1)
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index e1db404..499f405 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -707,6 +707,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
>  
>  #define TPM2_STARTUP_IN_SIZE \
>  	(sizeof(struct tpm_input_header) + \
> -- 
> 2.7.4
> 
