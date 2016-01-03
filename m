From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 5/7] tpm_tis: Clean up the force=1 module parameter
Date: Sun, 3 Jan 2016 19:26:50 +0200
Message-ID: <20160103172650.GD4155@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1450376600-6970-6-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450376600-6970-6-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Martin Wilck <Martin.Wilck@ts.fujitsu.com>, Peter Huewe <peterhuewe@gmx.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 17, 2015 at 11:23:18AM -0700, Jason Gunthorpe wrote:
> The TPM core has long assumed that every device has a driver attached,
> however the force path was attaching the TPM core outside of a driver
> context. This isn't generally reliable as the user could detatch the
> driver using sysfs or something, but commit b8b2c7d845d5 ("base/platform:
> assert that dev_pm_domain callbacks are called unconditionally")
> forced the issue by leaving the driver pointer NULL if there is
> no probe.
> 
> Rework the TPM setup to create a platform device with resources and
> then allow the driver core to naturally bind and probe it through the
> normal mechanisms. All this structure is needed anyhow to enable TPM
> for OF environments.
> 
> Finally, since the entire flow is changing convert the init/exit to use
> the modern ifdef-less coding style when possible
> 
> Reported-by: "Wilck, Martin" <martin.wilck@ts.fujitsu.com>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Tested-by: Wilck, Martin <martin.wilck@ts.fujitsu.com>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm_tis.c | 173 +++++++++++++++++++++++++++------------------
>  1 file changed, 106 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 856fb35e574c..12aa96a69b6c 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -60,7 +60,6 @@ enum tis_int_flags {
>  };
>  
>  enum tis_defaults {
> -	TIS_MEM_BASE = 0xFED40000,
>  	TIS_MEM_LEN = 0x5000,
>  	TIS_SHORT_TIMEOUT = 750,	/* ms */
>  	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
> @@ -75,15 +74,6 @@ struct tpm_info {
>  	int irq;
>  };
>  
> -static struct tpm_info tis_default_info = {
> -	.res = {
> -		.start = TIS_MEM_BASE,
> -		.end = TIS_MEM_BASE + TIS_MEM_LEN - 1,
> -		.flags = IORESOURCE_MEM,
> -	},
> -	.irq = 0,
> -};
> -
>  /* Some timeout values are needed before it is known whether the chip is
>   * TPM 1.0 or TPM 2.0.
>   */
> @@ -695,8 +685,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  #endif
>  
>  	chip->vendor.iobase = devm_ioremap_resource(dev, &tpm_info->res);
> -	if (!chip->vendor.iobase)
> -		return -EIO;
> +	if (IS_ERR(chip->vendor.iobase))
> +		return PTR_ERR(chip->vendor.iobase);

Isn't this a regression in the descendig patch in this series?

>  	/* Maximum timeouts */
>  	chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
> @@ -825,7 +815,6 @@ out_err:
>  	return rc;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
>  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  {
>  	u32 intmask;
> @@ -867,11 +856,9 @@ static int tpm_tis_resume(struct device *dev)
>  
>  	return 0;
>  }
> -#endif
>  
>  static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
>  
> -#ifdef CONFIG_PNP
>  static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  			    const struct pnp_device_id *pnp_id)
>  {
> @@ -889,14 +876,12 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  	else
>  		tpm_info.irq = -1;
>  
> -#ifdef CONFIG_ACPI
>  	if (pnp_acpi_device(pnp_dev)) {
>  		if (is_itpm(pnp_acpi_device(pnp_dev)))
>  			itpm = true;
>  
> -		acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
> +		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
>  	}
> -#endif
>  
>  	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
>  }
> @@ -937,7 +922,6 @@ static struct pnp_driver tis_pnp_driver = {
>  module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
>  		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
>  MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
> -#endif
>  
>  #ifdef CONFIG_ACPI
>  static int tpm_check_resource(struct acpi_resource *ares, void *data)
> @@ -1024,80 +1008,135 @@ static struct acpi_driver tis_acpi_driver = {
>  };
>  #endif
>  
> +static struct platform_device *force_pdev;
> +
> +static int tpm_tis_plat_probe(struct platform_device *pdev)
> +{
> +	struct tpm_info tpm_info = {};
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		return -ENODEV;
> +	}
> +	tpm_info.res = *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res) {
> +		tpm_info.irq = res->start;
> +	} else {
> +		if (pdev == force_pdev)
> +			tpm_info.irq = -1;
> +		else
> +			/* When forcing auto probe the IRQ */
> +			tpm_info.irq = 0;
> +	}
> +
> +	return tpm_tis_init(&pdev->dev, &tpm_info, NULL);
> +}
> +
> +static int tpm_tis_plat_remove(struct platform_device *pdev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
> +
> +	tpm_chip_unregister(chip);
> +	tpm_tis_remove(chip);
> +
> +	return 0;
> +}
> +
>  static struct platform_driver tis_drv = {
> +	.probe = tpm_tis_plat_probe,
> +	.remove = tpm_tis_plat_remove,
>  	.driver = {
>  		.name		= "tpm_tis",
>  		.pm		= &tpm_tis_pm,
>  	},
>  };
>  
> -static struct platform_device *pdev;
> -
>  static bool force;
> +#ifdef CONFIG_X86
>  module_param(force, bool, 0444);
>  MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
> +#endif
> +
> +static int tpm_tis_force_device(void)
> +{
> +	struct platform_device *pdev;
> +	static const struct resource x86_resources[] = {
> +		{
> +			.start = 0xFED40000,
> +			.end = 0xFED40000 + TIS_MEM_LEN - 1,
> +			.flags = IORESOURCE_MEM,
> +		},
> +	};
> +
> +	if (!force)
> +		return 0;
> +
> +	/* The driver core will match the name tpm_tis of the device to
> +	 * the tpm_tis platform driver and complete the setup via
> +	 * tpm_tis_plat_probe
> +	 */
> +	pdev = platform_device_register_simple("tpm_tis", -1, x86_resources,
> +					       ARRAY_SIZE(x86_resources));
> +	if (IS_ERR(pdev))
> +		return PTR_ERR(pdev);
> +	force_pdev = pdev;
> +
> +	return 0;
> +}
> +
>  static int __init init_tis(void)
>  {
>  	int rc;
> -#ifdef CONFIG_PNP
> -	if (!force) {
> -		rc = pnp_register_driver(&tis_pnp_driver);
> -		if (rc)
> -			return rc;
> -	}
> -#endif
> +
> +	rc = tpm_tis_force_device();
> +	if (rc)
> +		goto err_force;
> +
> +	rc = platform_driver_register(&tis_drv);
> +	if (rc)
> +		goto err_platform;
> +
>  #ifdef CONFIG_ACPI
> -	if (!force) {
> -		rc = acpi_bus_register_driver(&tis_acpi_driver);
> -		if (rc) {
> -#ifdef CONFIG_PNP
> -			pnp_unregister_driver(&tis_pnp_driver);
> -#endif
> -			return rc;
> -		}
> -	}
> +	rc = acpi_bus_register_driver(&tis_acpi_driver);
> +	if (rc)
> +		goto err_acpi;
>  #endif
> -	if (!force)
> -		return 0;
>  
> -	rc = platform_driver_register(&tis_drv);
> -	if (rc < 0)
> -		return rc;
> -	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
> -	if (IS_ERR(pdev)) {
> -		rc = PTR_ERR(pdev);
> -		goto err_dev;
> +	if (IS_ENABLED(CONFIG_PNP)) {
> +		rc = pnp_register_driver(&tis_pnp_driver);
> +		if (rc)
> +			goto err_pnp;
>  	}
> -	rc = tpm_tis_init(&pdev->dev, &tis_default_info, NULL);
> -	if (rc)
> -		goto err_init;
> +
>  	return 0;
> -err_init:
> -	platform_device_unregister(pdev);
> -err_dev:
> -	platform_driver_unregister(&tis_drv);
> +
> +err_pnp:
> +#ifdef CONFIG_ACPI
> +	acpi_bus_unregister_driver(&tis_acpi_driver);
> +err_acpi:
> +#endif
> +	platform_device_unregister(force_pdev);
> +err_platform:
> +	if (force_pdev)
> +		platform_device_unregister(force_pdev);
> +err_force:
>  	return rc;
>  }
>  
>  static void __exit cleanup_tis(void)
>  {
> -	struct tpm_chip *chip;
> -#if defined(CONFIG_PNP) || defined(CONFIG_ACPI)
> -	if (!force) {
> +	pnp_unregister_driver(&tis_pnp_driver);
>  #ifdef CONFIG_ACPI
> -		acpi_bus_unregister_driver(&tis_acpi_driver);
> -#endif
> -#ifdef CONFIG_PNP
> -		pnp_unregister_driver(&tis_pnp_driver);
> -#endif
> -		return;
> -	}
> +	acpi_bus_unregister_driver(&tis_acpi_driver);
>  #endif
> -	chip = dev_get_drvdata(&pdev->dev);
> -	tpm_chip_unregister(chip);
> -	tpm_tis_remove(chip);
> -	platform_device_unregister(pdev);
>  	platform_driver_unregister(&tis_drv);
> +
> +	if (force_pdev)
> +		platform_device_unregister(force_pdev);
>  }
>  
>  module_init(init_tis);
> -- 
> 2.1.4
> 

/Jarkko
