From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix the cleanup of struct tpm_chip
Date: Thu, 11 Feb 2016 12:34:15 -0700
Message-ID: <20160211193415.GA24465@obsidianresearch.com>
References: <1454988630-27942-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454988630-27942-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, stable@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 09, 2016 at 05:30:30AM +0200, Jarkko Sakkinen wrote:
> If the initialization fails before tpm_chip_register(), put_device()
> will be not called, which causes release callback not to be called.
> This patch fixes the issue by adding put_device() to devres list of
> the parent device.
> 
> Fixes: 313d21eeab ("tpm: device class for tpm")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> cc: stable@vger.kernel.org
>  drivers/char/tpm/tpm-chip.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 1a9dcee..ea904d1 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -136,6 +136,8 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
>  	chip->cdev.owner = chip->pdev->driver->owner;
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
>  
> +	devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
> +

Erm, don't forget the error handling here.

Something like this:

	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
	if (rc) {
		put_device(&chip->dev);
		return ERR_PTR(rc);
	}

Jason
