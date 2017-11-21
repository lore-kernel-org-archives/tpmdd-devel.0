From: Azhar Shaikh <azhar.shaikh@intel.com>
Subject: [PATCH v4 0/2] ] Fix corner cases with disabling CLKRUN in tpm_tis
Date: Tue, 21 Nov 2017 14:39:22 -0800
Message-ID: <1511303964-56294-1-git-send-email-azhar.shaikh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, azhar.shaikh@intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

Changes from v1:
- Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
  - Add NULL checks before calling clk_toggle callback
  - Use IS_ENABLED instead of ifdef in tpm_tis_clkrun_toggle()
  - Do not call tpm_platform_begin_xfer() and tpm_platform_end_xfer()
    from tpm_tis_clkrun_toggle(). Make them static again.

- Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
  - This is a new patch in this series as per suggestion from Jason.
  - Is the current implementation ok or I should move the code in tpm_tis_pnp_remove()
    and tpm_tis_plat_remove() inside tpm_tis_remove(). That way all the unmapping
    can be done in one place, instead of 3 different places now. Also the unmapping
    in tpm_tis_init() can be moved to tpm_tis_remove(), since in case of error
    tpm_tis_core_init() calls tpm_tis_remove(). Kindly suggest.

Changes from v2:
- Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
  - No changes

- Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
  - Updated is_bsw() function to have the #ifdef CONFIG_X86 check within the function
    itself. Also removed the #ifdef CONFIG_X86 from all other places around is_bsw()

Changes from v3:
- Patch 1: "tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()"
  - Change function name from clk_toggle to clk_enable
  - Update the commit message.

- Patch 2: "tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy"
  - No changes


Azhar Shaikh (2):
  tpm: Keep CLKRUN enabled throughout the duration of transmit_cmd()
  tpm_tis: Move ilb_base_addr to tpm_tis_tcg_phy

 drivers/char/tpm/tpm-interface.c |   6 +++
 drivers/char/tpm/tpm_tis.c       | 111 ++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm_tis_core.c  |  21 ++++++++
 drivers/char/tpm/tpm_tis_core.h  |   1 +
 include/linux/tpm.h              |   1 +
 5 files changed, 93 insertions(+), 47 deletions(-)

-- 
1.9.1
