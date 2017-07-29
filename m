From: SZ Lin <sz.lin@moxa.com>
Subject: [PATCH 0/5] tpm: tpm_ibmvtpm: - style fix
Date: Sat, 29 Jul 2017 15:24:28 +0800
Message-ID: <20170729072433.13194-1-sz.lin@moxa.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, SZ Lin <sz.lin@moxa.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Fix styling WARNINGs and Errors of tpm_ibmvtpm.c driver by using checkpatch.pl

SZ Lin (5):
  Fix packed and aligned attribute warnings.
  Fix "ERROR: code indent should use tabs where possible"
  Fix 'void function return statements are not generally useful' warning
  Remove unneccessary 'out of memory' message
  Use __func__ instead of function name

 drivers/char/tpm/tpm_ibmvtpm.c | 23 +++++++++--------------
 drivers/char/tpm/tpm_ibmvtpm.h |  2 +-
 2 files changed, 10 insertions(+), 15 deletions(-)

--
2.13.3
