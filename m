From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: TPM 2.0 device driver blocking open
Date: Fri, 30 Dec 2016 10:46:49 -0800
Message-ID: <1483123609.2712.1.camel@linux.vnet.ibm.com>
References: <o45vtc$ur$1@blaine.gmane.org>
	<1483114928.2442.28.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483114928.2442.28.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2016-12-30 at 08:22 -0800, James Bottomley wrote:
> On Fri, 2016-12-30 at 10:53 -0500, Ken Goldman wrote:
> > Is there any way to change it.  I didn't set O_NOBLOCK.  Is there 
> > perhaps an ioctl()?
> > Is this something that should be added?
> 
> I think for the 2.0 model of every application getting direct access,
> we should make it so that every open gets a separate read/write 
> stream to the tpm which we send in via the locked version of 
> tpm_transmit() and just let the chip->tpm_mutex sort out the
> accesses.
> 
> I can code up a patch if no-one's already done it.

Just FYI this is the temporary hack I'm using to fix my multiple access
problem while Jarkko is working on the RM as the final solution.  All
it does is block a second and subsequent open until the first one
completes.

James

---

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 912ad30..cce67d5 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -51,23 +51,44 @@ static void timeout_work(struct work_struct *work)
 	mutex_unlock(&priv->buffer_mutex);
 }
 
+static int tpm_open_lock(struct tpm_chip *chip, int lock)
+{
+	static DECLARE_COMPLETION(wait);
+
+	if (lock) {
+		while (test_and_set_bit(0, &chip->is_open)) {
+			int ret;
+
+			dev_dbg(&chip->dev, "Another process owns this TPM\n");
+			ret = wait_for_completion_interruptible(&wait);
+			if (ret)
+				return ret;
+		}
+	} else {
+		clear_bit(0, &chip->is_open);
+		complete(&wait);
+	}
+
+	return 0;
+}
+
 static int tpm_open(struct inode *inode, struct file *file)
 {
 	struct tpm_chip *chip =
 		container_of(inode->i_cdev, struct tpm_chip, cdev);
 	struct file_priv *priv;
+	int ret;
 
 	/* It's assured that the chip will be opened just once,
 	 * by the check of is_open variable, which is protected
 	 * by driver_lock. */
-	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(&chip->dev, "Another process owns this TPM\n");
-		return -EBUSY;
-	}
+	ret = tpm_open_lock(chip, 1);
+	if (ret)
+		return ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL) {
-		clear_bit(0, &chip->is_open);
+		tpm_open_lock(chip, 0);
 		return -ENOMEM;
 	}
 
@@ -173,7 +194,7 @@ static int tpm_release(struct inode *inode, struct file *file)
 	flush_work(&priv->work);
 	file->private_data = NULL;
 	atomic_set(&priv->data_pending, 0);
-	clear_bit(0, &priv->chip->is_open);
+	tpm_open_lock(priv->chip, 0);
 	kfree(priv);
 	return 0;
 }


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
