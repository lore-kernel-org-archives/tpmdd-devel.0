From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v3 1/4] tpm_tis: Improve reporting of IO
 errors
Date: Tue, 7 Jun 2016 16:56:38 +0300
Message-ID: <20160607135638.GE3855@intel.com>
References: <1465270649-22498-1-git-send-email-eswierk@skyportsystems.com>
 <1465270649-22498-2-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465270649-22498-2-git-send-email-eswierk@skyportsystems.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ed Swierk <eswierk@skyportsystems.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 06, 2016 at 08:37:26PM -0700, Ed Swierk wrote:
> Mysterious TPM behavior can be difficult to track down through all the
> layers of software. Add error messages for conditions that should
> never happen. Also include the manufacturer ID along with other chip
> data printed during init.
> 
> Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

PS. Please include at minimum also linux-kernel@vger.kernel.org and
linux-security-module@vger.kernel.org for these patches. Thanks.

> ---
>  drivers/char/tpm/tpm_tis.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 65f7eec..088fa86 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -299,6 +299,8 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  	expected = be32_to_cpu(*(__be32 *) (buf + 2));
>  	if (expected > count) {
> +		dev_err(chip->pdev, "Response too long (wanted %zd, got %d)\n",
> +			count, expected);
>  		size = -EIO;
>  		goto out;
>  	}
> @@ -366,6 +368,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  				  &chip->vendor.int_queue, false);
>  		status = tpm_tis_status(chip);
>  		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
> +			dev_err(chip->pdev, "Chip not accepting %zd bytes\n",
> +				len - count);
>  			rc = -EIO;
>  			goto out_err;
>  		}
> @@ -378,6 +382,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  			  &chip->vendor.int_queue, false);
>  	status = tpm_tis_status(chip);
>  	if ((status & TPM_STS_DATA_EXPECT) != 0) {
> +		dev_err(chip->pdev, "Chip not accepting last byte\n");
>  		rc = -EIO;
>  		goto out_err;
>  	}
> @@ -689,8 +694,9 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
>  	chip->vendor.manufacturer_id = vendor;
>  
> -	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> +	dev_info(dev, "%s TPM (manufacturer-id 0x%X, device-id 0x%X, rev-id %d)\n",
>  		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> +		 chip->vendor.manufacturer_id,
>  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>  
>  	if (!itpm) {
> -- 
> 1.9.1

/Jarko
