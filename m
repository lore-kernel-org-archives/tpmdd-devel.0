From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm, tpm_crb: remove redundant CRB_FL_CRB_START flag
Date: Tue, 18 Oct 2016 01:51:13 +0300
Message-ID: <20161017225113.qnghq5vroxlmsurc@intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 17, 2016 at 11:42:24PM +0300, Jarkko Sakkinen wrote:
> Because all the existing hardware have HID MSFT0101 we end up always
> setting CRB_FL_CRB_START flag as a workaround for 4th Gen Core CPUs.
> Even if ACPI start is used, the driver will always issue also CRB start.
> 
> This commit makes the invocation of CRB start unconditional.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm_crb.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)

I will include this to the next version of locale series if this is
accepted. Just wanted to make sure that this is OK before I make the
next version of the series.

/Jarkko

> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 65040d7..5928ec8 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -72,7 +72,6 @@ enum crb_status {
>  
>  enum crb_flags {
>  	CRB_FL_ACPI_START	= BIT(0),
> -	CRB_FL_CRB_START	= BIT(1),
>  };
>  
>  struct crb_priv {
> @@ -226,8 +225,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	/* Make sure that cmd is populated before issuing start. */
>  	wmb();
>  
> -	if (priv->flags & CRB_FL_CRB_START)
> -		iowrite32(CRB_START_INVOKE, &priv->cca->start);
> +
> +	/* At least some of the 4th Gen Core CPUs that report only needing ACPI
> +	 * start require also CRB start so we always set it just in case.
> +	 */
> +	iowrite32(CRB_START_INVOKE, &priv->cca->start);
>  
>  	if (priv->flags & CRB_FL_ACPI_START)
>  		rc = crb_do_acpi_start(chip);
> @@ -407,14 +409,6 @@ static int crb_acpi_add(struct acpi_device *device)
>  	if (!priv)
>  		return -ENOMEM;
>  
> -	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
> -	 * report only ACPI start but in practice seems to require both
> -	 * ACPI start and CRB start.
> -	 */
> -	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
> -	    !strcmp(acpi_device_hid(device), "MSFT0101"))
> -		priv->flags |= CRB_FL_CRB_START;
> -
>  	if (sm == ACPI_TPM2_START_METHOD ||
>  	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>  		priv->flags |= CRB_FL_ACPI_START;
> -- 
> 2.9.3
> 
