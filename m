From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix rollback when adding char dev
 fails
Date: Tue, 2 Feb 2016 16:17:35 -0700
Message-ID: <20160202231735.GB32711@obsidianresearch.com>
References: <1454113694-7997-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454113694-7997-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, stable@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 29, 2016 at 04:28:14PM -0800, Jarkko Sakkinen wrote:
> Fixed rollback and gave better names to the functions (more
> self-documenting, less confusing).
> 
> Fixes: d972b0523f ("tpm: fix call order in tpm-chip.c")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> cc: stable@vger.kernel.org
>  drivers/char/tpm/tpm-chip.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 45cc39a..1a9dcee 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -140,7 +140,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
>  
> -static int tpm_dev_add_device(struct tpm_chip *chip)
> +static int tpm_add_char_device(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> @@ -151,7 +151,6 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
>  			chip->devname, MAJOR(chip->dev.devt),
>  			MINOR(chip->dev.devt), rc);
>  
> -		device_unregister(&chip->dev);
>  		return rc;
>  	}
> @@ -162,13 +161,14 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
>  			chip->devname, MAJOR(chip->dev.devt),
>  			MINOR(chip->dev.devt), rc);
>  
> +		cdev_del(&chip->cdev);
>  		return rc;

Yep.

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
