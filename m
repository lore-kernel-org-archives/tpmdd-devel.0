From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RESEND][RFC] tpm_tis: broken on TPMs with a static burst count
Date: Tue, 10 Jan 2017 00:09:03 +0200
Message-ID: <20170109220903.vr36mux3nr2bp6z5@intel.com>
References: <77221b3a-40b3-f5db-e821-10e258f869dc@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77221b3a-40b3-f5db-e821-10e258f869dc@maciej.szmigiero.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 06:47:52PM +0100, Maciej S. Szmigiero wrote:
> (Resending as no reply received, this time with CCs to TPM maintainers and
> author of the original commit).
> 
> Hi all,
> 
> Commit 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
> broke TPM support on ThinkPad X61S (and likely also on other machines which
> use TPMs with a static burst count).
> 
> It looks like tpm_tis code before this commit had spun on TPM_STS_DATA_AVAIL |
> TPM_STS_VALID status bits in the read case and TPM_STS_VALID in the write case
> when it got a zero burst count.
> 
> I have attached a patch against current code (linux-tpmdd tree) that brings
> back this old behavior.
> With this patch the TPM works again on X61S.
> However, somebody with more TPM experience should comment whether such behavior
> was OK or the change brought by commit 1107d065fdf1 was intentional.
> 
> Maciej Szmigiero

For me this commit makes perfect sense. Could you do the following things:

1. Clean up the description a little bit
2. Add your Signed-off-by tag.
3. Add "Cc: stable@vger.kernel.org" tag right after your signed-off-by.
4. CC this linux-security-module@vger.kernel.org, stable@vger.kernel.org,
   linux-kernel@vger.kernel.org.
5. Run scripts/checkpatch.pl
6. Re-send for review.

Thanks for fixing the issue. Keep up the good work!

/Jarkko


> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 7993678954a2..72d365db7c61 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -188,7 +188,9 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  		if (rc < 0)
>  			return rc;
>  		burstcnt = get_burstcount(chip);
> -		if (burstcnt < 0) {
> +		if (burstcnt == -EBUSY)
> +			continue;
> +		else if (burstcnt < 0) {
>  			dev_err(&chip->dev, "Unable to read burstcount\n");
>  			return burstcnt;
>  		}
> @@ -282,18 +284,20 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  	while (count < len - 1) {
>  		burstcnt = get_burstcount(chip);
> -		if (burstcnt < 0) {
> +		if (burstcnt < 0 && burstcnt != -EBUSY) {
>  			dev_err(&chip->dev, "Unable to read burstcount\n");
>  			rc = burstcnt;
>  			goto out_err;
> +		} else if (burstcnt > 0) {
> +			burstcnt = min_t(int, burstcnt, len - count - 1);
> +			rc = tpm_tis_write_bytes(priv,
> +						 TPM_DATA_FIFO(priv->locality),
> +						 burstcnt, buf + count);
> +			if (rc < 0)
> +				goto out_err;
> +
> +			count += burstcnt;
>  		}
> -		burstcnt = min_t(int, burstcnt, len - count - 1);
> -		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> -					 burstcnt, buf + count);
> -		if (rc < 0)
> -			goto out_err;
> -
> -		count += burstcnt;
>  
>  		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>  					&priv->int_queue, false) < 0) {
