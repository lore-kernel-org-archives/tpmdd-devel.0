From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Wed, 7 Jun 2017 22:44:44 +0100
Message-ID: <20170607224444.5043f545@lxorguk.ukuu.org.uk>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
        <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Azhar Shaikh <azhar.shaikh@intel.com>
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -89,13 +89,89 @@ static inline int is_itpm(struct acpi_device *dev)
>  }
>  #endif
>  
> +#ifdef CONFIG_X86
> +static inline bool is_bsw(void)
> +{
> +	return ((boot_cpu_data.x86_model == INTEL_FAM6_ATOM_AIRMONT) ? 1 : 0);
> +}
> +#else
> +static inline bool is_bsw(void)
> +{
> +	return false;
> +}
> +#endif

This isn't the only bit that is x86 specific

> +
> +#define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
> +#define ILB_REMAP_SIZE			0x100
> +#define LPC_CNTRL_REG_OFFSET            0x84
> +#define LPC_CLKRUN_EN                   (1 << 2)
> +
> +void __iomem *ilb_base_addr;
> +
> +/**
> + * disable_lpc_clk_run() - clear LPC CLKRUN_EN i.e. clocks will be free running
> + */
> +static void disable_lpc_clk_run(void)
> +{
> +	u32 clkrun_val;
> +
> +	if (!is_bsw())
> +		return;
> +
> +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> +
> +	/* Disable LPC CLKRUN# */
> +	clkrun_val &= ~LPC_CLKRUN_EN;
> +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> +
> +	/*
> +	 * Write any random value on port 0x80 which is on LPC, to make
> +	 * sure LPC clock is running before sending any TPM command.
> +	 */
> +	outb(0x80, 0xCC);
> +
> +	/* Make sure the above write is completed */
> +	wmb();

Why the wmb(). It doesn't do what the comment says! Also this code is x86
specific


> +}
> +
> +/**
> + * enable_lpc_clk_run() - set LPC CLKRUN_EN i.e. clocks can be turned off
> + */
> +static void enable_lpc_clk_run(void)
> +{
> +	u32 clkrun_val;
> +
> +	if (!is_bsw())
> +		return;
> +
> +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> +
> +	/* Enable LPC CLKRUN# */
> +	clkrun_val |= LPC_CLKRUN_EN;
> +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> +
> +	/*
> +	 * Write any random value on port 0x80 which is on LPC, to make
> +	 * sure LPC clock is running before sending any TPM command.
> +	 */
> +	outb(0x80, 0xCC);
> +
> +	/* Make sure the above write is completed */
> +	wmb();
> +}

Same

> +
>  static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
>  			      u8 *result)
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> +	disable_lpc_clk_run();
> +
>  	while (len--)
>  		*result++ = ioread8(phy->iobase + addr);
> +
> +	enable_lpc_clk_run();
> +
>  	return 0;
>  }

So what you actually want to do is fold all the errata crap into an x86
specific chunk and just define disable/enable_lpc_clk_run() as null
functions on everything else.

I'd pick better names too - if other platforms need a hook here it won't
I imagine be about LPC. Possibly you want names like 

	platform_begin_tpm_xfer(data);
	platform_end_tpm_xfer(data);

>  
> @@ -104,8 +180,13 @@ static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> +	disable_lpc_clk_run();
> +
>  	while (len--)
>  		iowrite8(*value++, phy->iobase + addr);
> +
> +	enable_lpc_clk_run();
> +
>  	return 0;
>  }
>  
> @@ -113,7 +194,12 @@ static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> +	disable_lpc_clk_run();
> +
>  	*result = ioread16(phy->iobase + addr);
> +
> +	enable_lpc_clk_run();
> +
>  	return 0;
>  }
>  
> @@ -121,7 +207,12 @@ static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> +	disable_lpc_clk_run();
> +
>  	*result = ioread32(phy->iobase + addr);
> +
> +	enable_lpc_clk_run();
> +
>  	return 0;
>  }
>  
> @@ -129,7 +220,12 @@ static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
>  {
>  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
>  
> +	disable_lpc_clk_run();
> +
>  	iowrite32(value, phy->iobase + addr);
> +
> +	enable_lpc_clk_run();
> +
>  	return 0;
>  }
>  
> @@ -191,6 +287,10 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  		acpi_dev_handle = ACPI_HANDLE(&pnp_dev->dev);
>  	}
>  
> +	if (is_bsw())
> +		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
> +					ILB_REMAP_SIZE);
> +

This suggests to me that the bsw stuff wants to wrap the standard methods
because it's weird and ugly having random magic hardware globals in what
should be standard code.

>  	return tpm_tis_init(&pnp_dev->dev, &tpm_info, acpi_dev_handle);
>  }
>  
> @@ -214,6 +314,9 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
>  
>  	tpm_chip_unregister(chip);
>  	tpm_tis_remove(chip);
> +
> +	if (is_bsw())
> +		iounmap(ilb_base_addr);
>  }
>  
>  static struct pnp_driver tis_pnp_driver = {
