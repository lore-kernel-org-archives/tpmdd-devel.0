From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: improve tpm_tis send() performance by ignoring
 burstcount
Date: Tue, 8 Aug 2017 22:07:39 +0300
Message-ID: <20170808190739.bpmet2jqni3lt6pa@linux.intel.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 07, 2017 at 07:46:32AM -0400, Nayna Jain wrote:
> The TPM burstcount status indicates the number of bytes that can
> be sent to the TPM without causing bus wait states.  Effectively,
> it is the number of empty bytes in the command FIFO. Further,
> some TPMs have a static burstcount, when the value remains zero
> until the entire FIFO is empty.
> 
> This patch ignores burstcount, permitting wait states, and thus
> writes the command as fast as the TPM can accept the bytes.
> The performance of a 34 byte extend on a TPM 1.2 improved from
> 52 msec to 11 msec.
> 
> Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
> conjunction with the TPM Device Driver work group.
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_tis_core.c | 45 ++---------------------------------------
>  1 file changed, 2 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index b617b2eeb080..478cbc0f61c3 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -255,9 +255,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	int rc, status, burstcnt;
> -	size_t count = 0;
> -	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
> +	int rc, status;

As you anyway edit that line you could turn this as:

int rc;
int status;

>  	status = tpm_tis_status(chip);
>  	if ((status & TPM_STS_COMMAND_READY) == 0) {
> @@ -270,49 +268,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  		}
>  	}
>  
> -	while (count < len - 1) {
> -		burstcnt = get_burstcount(chip);
> -		if (burstcnt < 0) {
> -			dev_err(&chip->dev, "Unable to read burstcount\n");
> -			rc = burstcnt;
> -			goto out_err;
> -		}
> -		burstcnt = min_t(int, burstcnt, len - count - 1);
> -		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> -					 burstcnt, buf + count);
> -		if (rc < 0)
> -			goto out_err;
> -
> -		count += burstcnt;
> -
> -		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
> -					&priv->int_queue, false) < 0) {
> -			rc = -ETIME;
> -			goto out_err;
> -		}
> -		status = tpm_tis_status(chip);
> -		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
> -			rc = -EIO;
> -			goto out_err;
> -		}
> -	}
> -
> -	/* write last byte */
> -	rc = tpm_tis_write8(priv, TPM_DATA_FIFO(priv->locality), buf[count]);
> +	rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality), len, buf);
>  	if (rc < 0)
>  		goto out_err;
>  
> -	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
> -				&priv->int_queue, false) < 0) {
> -		rc = -ETIME;
> -		goto out_err;
> -	}
> -	status = tpm_tis_status(chip);
> -	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
> -		rc = -EIO;
> -		goto out_err;
> -	}
> -
>  	return 0;
>  
>  out_err:
> -- 
> 2.13.3

Here's an open question that I do not know the answer: can ignoring
burst count cause hardware issues in the field? The commit message
does not sort it out so I don't really feel safe merging this commit.

/Jarkko
