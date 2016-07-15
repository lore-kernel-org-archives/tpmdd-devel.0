From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/2] tpm: fix byte-order for the value read by
 tpm2_get_tpm_pt
Date: Thu, 14 Jul 2016 21:10:46 -0600
Message-ID: <20160715031046.GC9347@obsidianresearch.com>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
 <1468544838-9990-3-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468544838-9990-3-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 06:07:18PM -0700, Andrey Pronin wrote:
> Change-Id: I7d71cd379b1a3b7659d20a1b6008216762596590
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
>  drivers/char/tpm/tpm2-cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index a1673dc..a88b31e 100644
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -703,7 +703,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  
>  	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
>  	if (!rc)
> -		*value = cmd.params.get_tpm_pt_out.value;
> +		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);

Huh.

Jarkko: Are you running sparse on the tpm stuff? The annotations look
right here, sparse should have complained on this? Andrey, did sparse
complain here or is there something more serious wrong as well??

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
