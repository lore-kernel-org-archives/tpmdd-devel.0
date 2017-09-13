From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: remove some recent additions to the authors lists
Date: Wed, 13 Sep 2017 05:27:57 -0700
Message-ID: <20170913122758.19575-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Removed those additions to the authors lists within last few years
that are not the original authors.

In some ways authors list does not make sense at all because git log is
really the ultimate authors list but it is fine to give yourself a bit
of credit in rare cases if you create a new driver in the subsystem or
something similar.

This commit might seem a bit cosmetic but it is made to make the policy
more sound and speeds up the code review process a tiny bit in the
future.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_acpi.c | 1 -
 drivers/char/tpm/tpm_of.c   | 1 -
 drivers/char/tpm/tpm_ppi.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 169edf3ce86d..31b146bdac4b 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -6,7 +6,6 @@
  *	Stefan Berger <stefanb@us.ibm.com>
  *	Reiner Sailer <sailer@watson.ibm.com>
  *	Kylene Hall <kjhall@us.ibm.com>
- *	Nayna Jain <nayna@linux.vnet.ibm.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index aadb7f464076..635ee27809cc 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -2,7 +2,6 @@
  * Copyright 2012 IBM Corporation
  *
  * Author: Ashley Lai <ashleydlai@gmail.com>
- *         Nayna Jain <nayna@linux.vnet.ibm.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 86dd8521feef..d2e37e1977be 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -4,7 +4,6 @@
  * Authors:
  * Xiaoyan Zhang <xiaoyan.zhang@intel.com>
  * Jiang Liu <jiang.liu@linux.intel.com>
- * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
-- 
2.14.1
