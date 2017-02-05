From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] tpm xen: drop unneeded chip variable
Date: Sun,  5 Feb 2017 22:39:37 +0100
Message-ID: <1486330777-11341-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

The call that used chip was dropped in 1f0f30e404b3.  Drop the
leftover declaration and initialization.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/char/tpm/xen-tpmfront.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 5aaa268..656e8af 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -289,7 +289,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
 		const struct xenbus_device_id *id)
 {
 	struct tpm_private *priv;
-	struct tpm_chip *chip;
 	int rv;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -306,7 +305,6 @@ static int tpmfront_probe(struct xenbus_device *dev,
 
 	rv = setup_ring(dev, priv);
 	if (rv) {
-		chip = dev_get_drvdata(&dev->dev);
 		ring_free(priv);
 		return rv;
 	}
