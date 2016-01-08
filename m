From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 7/7] tpm_crb: Use devm_ioremap_resource
Date: Fri, 8 Jan 2016 10:04:40 +0800
Message-ID: <201601081058.vDvDPN9c%fengguang.wu@intel.com>
References: <1452213386-21460-8-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452213386-21460-8-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: kbuild-all@01.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

[auto build test WARNING on next-20160107]
[cannot apply to char-misc/char-misc-testing v4.4-rc8 v4.4-rc7 v4.4-rc6 v4.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Jason-Gunthorpe/tpm_tis-Clean-up-force-module-parameter/20160108-084227


coccinelle warnings: (new ones prefixed by >>)

>> drivers/char/tpm/tpm_crb.c:297:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
