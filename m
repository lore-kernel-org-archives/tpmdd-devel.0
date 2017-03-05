From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] tpm/tpm_crb: enter the low power state upon device suspend
Date: Mon,  6 Mar 2017 01:53:35 +0200
Message-ID: <1488758015-12681-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This fix enables a platform to enter the idle state (suspend-to-idle)

The driver needs to request explicitly go_idle upon completion
from the pm suspend handler.
The runtime pm is disabled on suspend during prepare state by calling
pm_runtime_get_noresume, hence we cannot relay on runtime pm to leave
the device in low power state. Symmetrically cmdReady is called
upon resume.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/tpm/tpm_crb.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 86f355b6df1d..d8dfff0fdfce 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -479,10 +479,33 @@ static int crb_pm_runtime_resume(struct device *dev)
 
 	return crb_cmd_ready(dev, priv);
 }
+
+static int crb_pm_suspend(struct device *dev)
+{
+	int ret;
+
+	ret = tpm_pm_suspend(dev);
+	if (ret)
+		return ret;
+
+	return crb_pm_runtime_suspend(dev);
+}
+
+static int crb_pm_resume(struct device *dev)
+{
+	int ret;
+
+	ret = crb_pm_runtime_resume(dev);
+	if (ret)
+		return ret;
+
+	return tpm_pm_resume(dev);
+}
+
 #endif /* CONFIG_PM */
 
 static const struct dev_pm_ops crb_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(tpm_pm_suspend, tpm_pm_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(crb_pm_suspend, crb_pm_resume)
 	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
 };
 
-- 
2.7.4

