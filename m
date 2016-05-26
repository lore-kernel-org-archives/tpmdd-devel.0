From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 0/7] Rework of tpm_tis to share common logic across
 phy's (lpc/spi/-i2c-)
Date: Thu, 26 May 2016 15:26:35 +0300
Message-ID: <20160526122635.GA31557@intel.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Christophe Ricard <christophe.ricard@gmail.com>
Cc: jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, jean-luc.blanc@st.com, benoit.houyere@st.com, Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Stefan, Peter,

Would it be possible for you to smoke test this patch set?

I'm very happy with the current version and have tested it myself but
since this is a large infra change inside the subsystem I cannot include
it to a kernel release before it is tested by multiple parties.

/Jarkko

On Thu, May 19, 2016 at 12:35:46AM +0200, Christophe Ricard wrote:
> Hi Jarkko,
> 
> This serie is including common work from Infineon (Peter Huewe & Alexander Steffen) and ST.
> We propose a common low level API used by a core TIS interface allowing to share
> some protocols behavior between physical layers (lpc, spi, i2c...) or drivers.
> 
> To easy the group review, i only send 10 patches showing how we rework the tpm_tis driver
> keeping existing proprietary logic (itpm workaround, irq for tpm_tis ("lpc")).
> Finally we are adding spi support based on TCG PTP specification. This additional driver
> support the SPI bit protocol including optional flow control.
> 
> Reworked tpm_tis got validated on a HP 8200 machine with an Infineon TPM
> tpm_tis_spi got validated using Minnowboard Max as well as Raspberry Pi.
> 
> v2:
> - Add Rob Herring acks on devicetree specific patch
> - Renamed priv_data tpm_tis_data
> - Moved data_expect_val & data_expect_mask in tpm_tis_data
> - Moved "hal" (e.g: tpm_write_xxx/tpm_read_xxx) in tpm_tis_core.h
> - Reduced list of the exported functions from tpm_tis_core
> - Make tpm_tis ops internal to tpm_tis_core
> 
> v3:
> - Merge tpm_class_lowlevel and tpm_tis_phy_ops
> - Changed the way phy specific structure looked like in order to use container_of
> - Cleanup patches with rebase mistakes and build verify them...
> - Moved "Add include guards in tpm.h" at first position
> 
> v4:
> - Move patch "Use read/write_bytes for drivers without more specialized methods"
> before spi phy patch and rework so that functions are no more inlined and available
> from tpm_tis_core.
> 
> v5:
> - Squashed several patch together. (2, 3, 4).
> - Renammed tpm_tis_lpc_data --> tpm_tis_tcg_data.
> - Change tpm_tis_read_xxx/tpm_tis_write_xx parameters to take a struct tpm_tis_data* instead of a struct tpm_chip*.
> - Manage itpm workaround internally to the tpm_tis_core and add a TIS flag (TPM_TIS_ITPM_POSSIBLE).
> - Several fixes in the spi phy.
> - Use chip->ops->cancel(chip) instead of tpm_tis_ready out of tpm_tis_core.
> - Reworked Makefile
> 
> v6:
> - Fix rebase mistaked in patch 2 and 3.
> - Remove post_probe handler from tpm_tis_phy_ops in "Split tpm_tis driver into a core and TCG TIS compliant phy"
> 
> v7:
> - Merge patch 7 in patch 8 as requested by Jarkko.
> 
> v8:
> - Change tpm_readxx/tpm_writexx with tpm_tis_readxx/tpm_tis_writexx
> 
> You can check this work on:
> https://github.com/cricard13/linux-tpmdd tpm_tis_core_v8
> 
> Best Regards
> Christophe
> 
> Christophe Ricard (7):
>   tpm: Add include guards in tpm.h
>   tpm: tpm_tis: Share common data between phys
>   tpm_tis: Introduce intermediate layer for TPM access
>   devicetree: Add infineon to vendor-prefix.txt
>   devicetree: Add Trusted Computing Group to vendor-prefix.txt
>   tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant
>     phy
>   tpm/tpm_tis_spi: Add support for spi phy
> 
>  .../bindings/security/tpm/tpm_tis_spi.txt          |  24 +
>  .../devicetree/bindings/vendor-prefixes.txt        |   2 +
>  drivers/char/tpm/Kconfig                           |  19 +
>  drivers/char/tpm/Makefile                          |   2 +
>  drivers/char/tpm/tpm.h                             |   5 +
>  drivers/char/tpm/tpm_tis.c                         | 851 ++------------------
>  drivers/char/tpm/tpm_tis_core.c                    | 862 +++++++++++++++++++++
>  drivers/char/tpm/tpm_tis_core.h                    | 156 ++++
>  drivers/char/tpm/tpm_tis_spi.c                     | 272 +++++++
>  9 files changed, 1405 insertions(+), 788 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
>  create mode 100644 drivers/char/tpm/tpm_tis_core.c
>  create mode 100644 drivers/char/tpm/tpm_tis_core.h
>  create mode 100644 drivers/char/tpm/tpm_tis_spi.c
> 
> -- 
> 2.1.4
> 
