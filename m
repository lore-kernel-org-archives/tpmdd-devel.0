From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm_tis: fix build warning with tpm_tis_resume
Date: Mon, 22 Feb 2016 20:47:14 +0200
Message-ID: <1456166834-32100-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, jmorris@namei.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

drivers/char/tpm/tpm_tis.c:838: warning: =E2=80=98tpm_tis_resume=E2=80=99=
 defined but
not used

Reported-by: James Morris <jmorris@namei.org>
=46ixes: 00194826e6be ("tpm_tis: Clean up the force=3D1 module paramete=
r")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2b2eff9..a507006 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -814,6 +814,7 @@ out_err:
 	return rc;
 }
=20
+#ifdef CONFIG_PM_SLEEP
 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 {
 	u32 intmask;
@@ -855,6 +856,7 @@ static int tpm_tis_resume(struct device *dev)
=20
 	return 0;
 }
+#endif
=20
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
=20
--=20
2.7.0
