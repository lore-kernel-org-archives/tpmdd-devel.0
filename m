From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH] tpm: Begin the process to deprecate user_read_timer
Date: Mon, 23 Jan 2017 17:06:08 -0700
Message-ID: <20170124000608.GA29708@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

For a long time the cdev read/write interface had this strange
idea that userspace had to read the result within 60 seconds otherwise
it is discarded. Perhaps this made sense under some older locking regime,
but in the modern kernel it is not required and is just dangerous.

Since something may be relying on this, double the timeout and print a
warning. We can remove the code in a few years, but this should be
enough to prevent new users.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm-dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 826d4eaf84fcd6..06d7c8a6e7063c 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -38,6 +38,9 @@ static void user_reader_timeout(unsigned long ptr)
 {
 	struct file_priv *priv = (struct file_priv *)ptr;
 
+	pr_warn("TPM user space timeout is deprecated (pid=%d)\n",
+		task_tgid_nr(current));
+
 	schedule_work(&priv->work);
 }
 
@@ -159,7 +162,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 	mutex_unlock(&priv->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&priv->user_read_timer, jiffies + (60 * HZ));
+	mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 
 	return in_size;
 }
-- 
2.7.4
