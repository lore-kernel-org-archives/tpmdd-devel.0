From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 0/2] Fix corner cases with disabling CLKRUN in tpm_tis
Date: Thu, 7 Dec 2017 03:30:20 +0200
Message-ID: <20171207013020.lu5x4mm4dpc6rhtt@linux.intel.com>
References: <1511980791-125269-1-git-send-email-azhar.shaikh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511980791-125269-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Azhar Shaikh <azhar.shaikh@intel.com>
Cc: jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 29, 2017 at 10:39:49AM -0800, Azhar Shaikh wrote:
> Changes from v1:
> - Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
>   - Add NULL checks before calling clk_toggle callback
>   - Use IS_ENABLED instead of ifdef in tpm_tis_clkrun_toggle()
>   - Do not call tpm_platform_begin_xfer() and tpm_platform_end_xfer()
>     from tpm_tis_clkrun_toggle(). Make them static again.
> 
> - Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
>   - This is a new patch in this series as per suggestion from Jason.
>   - Is the current implementation ok or I should move the code in tpm_tis_pnp_remove()
>     and tpm_tis_plat_remove() inside tpm_tis_remove(). That way all the unmapping
>     can be done in one place, instead of 3 different places now. Also the unmapping
>     in tpm_tis_init() can be moved to tpm_tis_remove(), since in case of error
>     tpm_tis_core_init() calls tpm_tis_remove(). Kindly suggest.
> 
> Changes from v2:
> - Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
>   - No changes
> 
> - Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
>   - Updated is_bsw() function to have the #ifdef CONFIG_X86 check within the function
>     itself. Also removed the #ifdef CONFIG_X86 from all other places around is_bsw()
> 
> Changes from v3:
> - Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
>   - Change function name from clk_toggle to clk_enable
>   - Update the commit message.
> 
> - Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
>   - No changes
> 
> Changes from v4:
> - The numbering of patches is now interchanged.
> 
> - Patch 1: "tpm_tis: Move ilb_base_addr to tpm_tis_data"
>   - Had to move ilb_base_addr to tpm_tis_data, from tpm_tis_tcg_phy.
>     Since the ioremapping of ilb_base_addr had to be done before any TPM access,
>     hence moved the variable to tpm_tis_data.
>   - Also move the ioremapping of ilb_base_addr from tpm_tis_init() to
>     tpm_tis_core_init() i.e. before any TPM access is done.
>   - Rename marco LPC_CNTRL_REG_OFFSET to LPC_CNTRL_OFFSET
>   - Update the commit message.
> 
> - Patch 2: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
>   - Remove the functions tpm_platform_begin_xfer() and tpm_platform_end_xfer()
>   - Move the code from these functions to tpm_tis_clkrun_enable().
> 
> Changes from v5:
> - Patch 1: "tpm_tis: Move ilb_base_addr to tpm_tis_data"
>   - No changes
> 
> - Patch 2: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
>   - Update the commit message.
> 
> Azhar Shaikh (2):
>   tpm_tis: Move ilb_base_addr to tpm_tis_data
>   tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()
> 
>  drivers/char/tpm/tpm-interface.c |   6 ++
>  drivers/char/tpm/tpm_tis.c       | 121 ++++++---------------------------------
>  drivers/char/tpm/tpm_tis_core.c  | 111 +++++++++++++++++++++++++++++++++--
>  drivers/char/tpm/tpm_tis_core.h  |  17 ++++++
>  include/linux/tpm.h              |   1 +
>  5 files changed, 147 insertions(+), 109 deletions(-)
> 
> -- 
> 1.9.1
> 

Please, resend this to linux-integrity. You have wrong ML in your CC.

/Jarkko
