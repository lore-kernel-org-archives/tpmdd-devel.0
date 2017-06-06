From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Enable CLKRUN protocol for Braswell systems
Date: Tue, 6 Jun 2017 20:13:48 +0300
Message-ID: <20170606171348.5e3j6prhanpqstoz@intel.com>
References: <1496344432-76640-1-git-send-email-azhar.shaikh@intel.com>
 <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
 <20170605133214.ah77n5pmapoddoxy@intel.com>
 <5FFFAD06ADE1CA4381B3F0F7C6AF582890FB3A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FFFAD06ADE1CA4381B3F0F7C6AF582890FB3A@ORSMSX109.amr.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Cc: "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 05, 2017 at 06:42:55PM +0000, Shaikh, Azhar wrote:
> 
> 
> > -----Original Message-----
> > From: Jarkko Sakkinen [mailto:jarkko.sakkinen@linux.intel.com]
> > Sent: Monday, June 5, 2017 6:32 AM
> > To: Shaikh, Azhar <azhar.shaikh@intel.com>
> > Cc: jgunthorpe@obsidianresearch.com; tpmdd-devel@lists.sourceforge.net;
> > linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org
> > Subject: Re: [PATCH v2] tpm: Enable CLKRUN protocol for Braswell systems
> > 
> > On Thu, Jun 01, 2017 at 07:04:04PM -0700, Azhar Shaikh wrote:
> > > To overcome a hardware limitation on Intel Braswell systems, disable
> > > CLKRUN protocol during TPM transactions and re-enable once the
> > > transaction is completed.
> > >
> > > Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
> > > ---
> > > Changes from v1:
> > > - Add CONFIG_X86 around disable_lpc_clk_run () and
> > > enable_lpc_clk_run() to avoid
> > > - build breakage on architectures which do not implement
> > > kmap_atomic_pfn()
> > >
> > >  drivers/char/tpm/tpm.h     | 20 ++++++++++
> > >  drivers/char/tpm/tpm_tis.c | 94
> > > ++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 114 insertions(+)
> > >
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h index
> > > 4b4c8dee3096..98032a22317e 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -36,6 +36,10 @@
> > >  #include <linux/highmem.h>
> > >  #include <crypto/hash_info.h>
> > >
> > > +#ifdef CONFIG_X86
> > > +#include <asm/intel-family.h>
> > > +#endif
> > 
> > #ifdef's are not necessary here.
> 
> If the #ifdef's are not present, on non-Intel architectures, intel-family.h file is not found during compile time.

Oops, my bad. You are absolutely right!

> 
> > 
> > > +
> > >  enum tpm_const {
> > >  	TPM_MINOR = 224,	/* officially assigned */
> > >  	TPM_BUFSIZE = 4096,
> > > @@ -436,6 +440,22 @@ struct tpm_buf {
> > >  	u8 *data;
> > >  };
> > >
> > > +#define INTEL_LEGACY_BLK_BASE_ADDR	0xFED08000
> > > +#define LPC_CNTRL_REG_OFFSET		0x84
> > > +#define LPC_CLKRUN_EN			(1 << 2)
> > > +
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
> > Move these to tpm_tis.c right before disable_lpc_clk_run().
> 
> Ok, will do.
> 
> > 
> > > +
> > >  static inline int tpm_buf_init(struct tpm_buf *buf, u16 tag, u32
> > > ordinal)  {
> > >  	struct tpm_input_header *head;
> > > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > > index c7e1384f1b08..0c1496340a18 100644
> > > --- a/drivers/char/tpm/tpm_tis.c
> > > +++ b/drivers/char/tpm/tpm_tis.c
> > > @@ -89,13 +89,79 @@ static inline int is_itpm(struct acpi_device *dev)
> > > }  #endif
> > >
> > > +#ifdef CONFIG_X86
> > > +/**
> > > + * disable_lpc_clk_run() - clear LPC CLKRUN_EN i.e. clocks will be
> > > +free running  */ static void disable_lpc_clk_run(void) {
> > > +	u32 clkrun_val;
> > > +	void __iomem *ilb_base_addr = NULL;
> > > +
> > > +	ilb_base_addr = (void __iomem *)
> > > +		kmap_atomic_pfn(INTEL_LEGACY_BLK_BASE_ADDR >>
> > PAGE_SHIFT);
> > > +
> > > +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/* Disable LPC CLKRUN# */
> > > +	clkrun_val &= ~LPC_CLKRUN_EN;
> > > +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	kunmap_atomic(ilb_base_addr);
> > > +	/*
> > > +	 * Write any random value on port 0x80 which is on LPC, to make
> > > +	 * sure LPC clock is running before sending any TPM command.
> > > +	 */
> > > +	outb(0x80, 0xCC);
> > > +}
> > 
> > You said that this code does not work compared to a version that does only
> > static ioremap.
> > 
> > I compared this to the other version. One of the major differences is that
> > outb() is done before releasing the mapping. Don't know or understand what
> > difference that would make but it is a semantic difference.
> > 
> I tried unmapping after outb() and wmb(), still code does not work.

Send ioremap() version (or any version that actually works).

> > Another observation is that should you have wmb() before outb() to make
> > sure that all the write operations are complete?
> > 
> I think you meant to say add wmb() 'after' outb() and not before.

Yes, that is correct.

> 
> > > +
> > > +/**
> > > + * enable_lpc_clk_run() - set LPC CLKRUN_EN i.e. clocks can be turned
> > > +off  */ static void enable_lpc_clk_run(void) {
> > > +	u32 clkrun_val;
> > > +	void __iomem *ilb_base_addr = NULL;
> > > +
> > > +	ilb_base_addr = (void __iomem *)
> > > +		kmap_atomic_pfn(INTEL_LEGACY_BLK_BASE_ADDR >>
> > PAGE_SHIFT);
> > > +
> > > +	clkrun_val = ioread32(ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	/* Enable LPC CLKRUN# */
> > > +	clkrun_val |= LPC_CLKRUN_EN;
> > > +	iowrite32(clkrun_val, ilb_base_addr + LPC_CNTRL_REG_OFFSET);
> > > +
> > > +	kunmap_atomic(ilb_base_addr);
> > > +	/*
> > > +	 * Write any random value on port 0x80 which is on LPC, to make
> > > +	 * sure LPC clock is running before sending any TPM command.
> > > +	 */
> > > +	outb(0x80, 0xCC);
> > > +}
> > > +#else
> > > +static void disable_lpc_clk_run(void) { } static void
> > > +enable_lpc_clk_run(void) { } #endif
> > > +
> > >  static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16
> > len,
> > >  			      u8 *result)
> > >  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	if (is_bsw())
> > > +		disable_lpc_clk_run();
> > 
> > Do is_bsw() instead inside so that this can be unconditionally called.
> > 
> 
> Ok, will do.
> 
> > > +
> > >  	while (len--)
> > >  		*result++ = ioread8(phy->iobase + addr);
> > > +
> > > +	if (is_bsw())
> > > +		enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -104,8 +170,15 @@ static int tpm_tcg_write_bytes(struct
> > > tpm_tis_data *data, u32 addr, u16 len,  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	if (is_bsw())
> > > +		disable_lpc_clk_run();
> > > +
> > >  	while (len--)
> > >  		iowrite8(*value++, phy->iobase + addr);
> > > +
> > > +	if (is_bsw())
> > > +		enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -113,7 +186,14 @@ static int tpm_tcg_read16(struct tpm_tis_data
> > > *data, u32 addr, u16 *result)  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	if (is_bsw())
> > > +		disable_lpc_clk_run();
> > > +
> > >  	*result = ioread16(phy->iobase + addr);
> > > +
> > > +	if (is_bsw())
> > > +		enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -121,7 +201,14 @@ static int tpm_tcg_read32(struct tpm_tis_data
> > > *data, u32 addr, u32 *result)  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	if (is_bsw())
> > > +		disable_lpc_clk_run();
> > > +
> > >  	*result = ioread32(phy->iobase + addr);
> > > +
> > > +	if (is_bsw())
> > > +		enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -129,7 +216,14 @@ static int tpm_tcg_write32(struct tpm_tis_data
> > > *data, u32 addr, u32 value)  {
> > >  	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> > >
> > > +	if (is_bsw())
> > > +		disable_lpc_clk_run();
> > > +
> > >  	iowrite32(value, phy->iobase + addr);
> > > +
> > > +	if (is_bsw())
> > > +		enable_lpc_clk_run();
> > > +
> > >  	return 0;
> > >  }
> > >
> > > --
> > > 1.9.1
> > >
> > 
> > /Jarkko

/Jarkko
