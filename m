From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
Date: Thu, 8 Jun 2017 15:38:32 +0300
Message-ID: <20170608123832.okodsewpocqj6uve@intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
 <1496870610-29462-1-git-send-email-azhar.shaikh@intel.com>
 <20170607224444.5043f545@lxorguk.ukuu.org.uk>
 <5FFFAD06ADE1CA4381B3F0F7C6AF5828910C7B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FFFAD06ADE1CA4381B3F0F7C6AF5828910C7B@ORSMSX109.amr.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 08, 2017 at 01:11:43AM +0000, Shaikh, Azhar wrote:
> 
> 
> > -----Original Message-----
> > From: Alan Cox [mailto:gnomes@lxorguk.ukuu.org.uk]
> > Sent: Wednesday, June 7, 2017 2:45 PM
> > To: Shaikh, Azhar <azhar.shaikh@intel.com>
> > Cc: jarkko.sakkinen@linux.intel.com; jgunthorpe@obsidianresearch.com;
> > tpmdd-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; linux-
> > security-module@vger.kernel.org
> > Subject: Re: [PATCH v3] tpm: Enable CLKRUN protocol for Braswell systems
> > 
> > > +++ b/drivers/char/tpm/tpm_tis.c
> > > @@ -89,13 +89,89 @@ static inline int is_itpm(struct acpi_device *dev)
> > > }  #endif
> > >
> > > +#ifdef CONFIG_X86
> > > +static inline bool is_bsw(void)
> > > +{
> > > +	return ((boot_cpu_data.x86_model ==
> > INTEL_FAM6_ATOM_AIRMONT) ? 1 :
> > > +0); } #else static inline bool is_bsw(void) {
> > > +	return false;
> > > +}
> > > +#endif
> > 
> > This isn't the only bit that is x86 specific
> > 
> > > +
> > > +#define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
> > > +#define ILB_REMAP_SIZE			0x100
> > > +#define LPC_CNTRL_REG_OFFSET            0x84
> > > +#define LPC_CLKRUN_EN                   (1 << 2)
> > > +
> > > +void __iomem *ilb_base_addr;
> > > +
> > > +/**
> > > + * disable_lpc_clk_run() - clear LPC CLKRUN_EN i.e. clocks will be
> > > +free running  */ static void disable_lpc_clk_run(void) {
> > > +	u32 clkrun_val;
> > > +
> > > +	if (!is_bsw())
> > > +		return;
> > > +
> > > +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/* Disable LPC CLKRUN# */
> > > +	clkrun_val &= ~LPC_CLKRUN_EN;
> > > +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/*
> > > +	 * Write any random value on port 0x80 which is on LPC, to make
> > > +	 * sure LPC clock is running before sending any TPM command.
> > > +	 */
> > > +	outb(0x80, 0xCC);
> > > +
> > > +	/* Make sure the above write is completed */
> > > +	wmb();
> > 
> > Why the wmb(). It doesn't do what the comment says! Also this code is x86
> > specific
> > 
> > 
> 
> Memory barrier to enforce the order so that the outb() is completed, which ensures that the LPC clocks are running before sending any TPM command.
> 
> > > +}
> > > +
> > > +/**
> > > + * enable_lpc_clk_run() - set LPC CLKRUN_EN i.e. clocks can be turned
> > > +off  */ static void enable_lpc_clk_run(void) {
> > > +	u32 clkrun_val;
> > > +
> > > +	if (!is_bsw())
> > > +		return;
> > > +
> > > +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/* Enable LPC CLKRUN# */
> > > +	clkrun_val |= LPC_CLKRUN_EN;
> > > +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/*
> > > +	 * Write any random value on port 0x80 which is on LPC, to make
> > > +	 * sure LPC clock is running before sending any TPM command.
> > > +	 */
> > > +	outb(0x80, 0xCC);
> > > +
> > > +	/* Make sure the above write is completed */
> > > +	wmb();
> > > +}
> > 
> > Same
> > 
> > > +
> > >  static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16
> > len,
> > >  			      u8 *result)
> > >  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	disable_lpc_clk_run();
> > > +
> > >  	while (len--)
> > >  		*result++ = ioread8(phy->iobase + addr);
> > > +
> > > +	enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > 
> > So what you actually want to do is fold all the errata crap into an x86 specific
> > chunk and just define disable/enable_lpc_clk_run() as null functions on
> > everything else.
> > 
> 
> Ok, will do.
> 
> > I'd pick better names too - if other platforms need a hook here it won't I
> > imagine be about LPC. Possibly you want names like
> > 
> > 	platform_begin_tpm_xfer(data);
> > 	platform_end_tpm_xfer(data);
> > 
> 
> How about these? Since most of the functions in this driver begin with 'tpm_'
> disable_lpc_clk_run()	- >	tpm_start_xfer()
> enable_lpc_clk_run()	->	tpm_end_xfer()

tpm_platform_begin_xfer() would be the best alternative as it highlights
platform quirk better.

/Jarkko
