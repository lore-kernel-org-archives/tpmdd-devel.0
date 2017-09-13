From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 3/3] tpm: fix type of a local variables in tpm_tis_spi.c
Date: Wed, 13 Sep 2017 11:52:40 -0700
Message-ID: <20170913185240.wgzdlzeuc3fhf7fb@linux.intel.com>
References: <20170913172654.25036-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913172654.25036-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Applied (as other similar) already to master because these are
very obvious things to fix. I'll wait for reviews and tests before
applying to next.

/Jarkko

On Wed, Sep 13, 2017 at 10:26:54AM -0700, Jarkko Sakkinen wrote:
> Use __le32 type for data in that format.
> 
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm_tis_spi.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 7e97eb07b200..bfe972959183 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -153,29 +153,40 @@ static int tpm_tis_spi_write_bytes(struct tpm_tis_data *data, u32 addr,
>  
>  static int tpm_tis_spi_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
>  {
> +	__le16 result_le;
>  	int rc;
>  
> -	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16), (u8 *)result);
> +	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16),
> +				       (u8 *)&result_le);
>  	if (!rc)
> -		*result = le16_to_cpu(*result);
> +		*result = le16_to_cpu(result_le);
> +
>  	return rc;
>  }
>  
>  static int tpm_tis_spi_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
>  {
> +	__le32 result_le;
>  	int rc;
>  
> -	rc = data->phy_ops->read_bytes(data, addr, sizeof(u32), (u8 *)result);
> +	rc = data->phy_ops->read_bytes(data, addr, sizeof(u32),
> +				       (u8 *)&result_le);
>  	if (!rc)
> -		*result = le32_to_cpu(*result);
> +		*result = le32_to_cpu(result_le);
> +
>  	return rc;
>  }
>  
>  static int tpm_tis_spi_write32(struct tpm_tis_data *data, u32 addr, u32 value)
>  {
> -	value = cpu_to_le32(value);
> -	return data->phy_ops->write_bytes(data, addr, sizeof(u32),
> -					   (u8 *)&value);
> +	__le32 value_le;
> +	int rc;
> +
> +	value_le = cpu_to_le32(value);
> +	rc = data->phy_ops->write_bytes(data, addr, sizeof(u32),
> +					(u8 *)&value_le);
> +
> +	return rc;
>  }
>  
>  static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
> -- 
> 2.14.1
> 
