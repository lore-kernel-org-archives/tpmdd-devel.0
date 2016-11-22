From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v6 3/9] tpm: replace dynamically allocated
 bios_dir with a static array
Date: Tue, 22 Nov 2016 09:58:56 -0700
Message-ID: <20161122165856.GD3956@obsidianresearch.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479117656-12403-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161122112333.7ootyrbssd6pkrjb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161122112333.7ootyrbssd6pkrjb-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 22, 2016 at 01:23:33PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 14, 2016 at 05:00:50AM -0500, Nayna Jain wrote:
> > This commit is based on a commit by Nayna Jain. Replaced dynamically
> > allocated bios_dir with a static array as the size is always constant.
> > 
> > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> This commit remains unreviewed and tested. I'm in the author role here
> so I cannot help with this. If that does not happen soon I cannot put
> this into the pull request.

Nayna must have tested it, looks OK to me..

> > +err:
> > +	chip->bios_dir[cnt] = NULL;
> > +	tpm_bios_log_teardown(chip);
> > +	return -EIO;

Except that return should ideally be PTR_ERR(chip->bios_dir[cnt])

.. and we still set ERR_PTR into bios_dir in the ENODEV case, so the
overall series is still broken if securityfs is compiled out.

Lets fix this all like this - which is a good enough reason to leave the
ENODEV detect alone - just squash this into your patch:

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 2a15b866ac257a..11bb1138a8282e 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -356,15 +356,6 @@ static const struct file_operations tpm_bios_measurements_ops = {
 	.release = tpm_bios_measurements_release,
 };
 
-static int is_bad(void *p)
-{
-	if (!p)
-		return 1;
-	if (IS_ERR(p) && (PTR_ERR(p) != -ENODEV))
-		return 1;
-	return 0;
-}
-
 static int tpm_read_log(struct tpm_chip *chip)
 {
 	int rc;
@@ -390,7 +381,8 @@ static int tpm_read_log(struct tpm_chip *chip)
  * If an event log is found then the securityfs files are setup to
  * export it to userspace, otherwise nothing is done.
  *
- * Returns -ENODEV if the firmware has no event log.
+ * Returns -ENODEV if the firmware has no event log or securityfs is not
+ * supported.
  */
 int tpm_bios_log_setup(struct tpm_chip *chip)
 {
@@ -407,7 +399,10 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 
 	cnt = 0;
 	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
-	if (is_bad(chip->bios_dir[cnt]))
+	/* NOTE: securityfs_create_dir can return ENODEV if securityfs is
+	 * compiled out. The caller should ignore the ENODEV return code.
+	 */
+	if (IS_ERR(chip->bios_dir[cnt]))
 		goto err;
 	cnt++;
 
@@ -419,7 +414,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 				   0440, chip->bios_dir[0],
 				   (void *)&chip->bin_log_seqops,
 				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[cnt]))
+	if (IS_ERR(chip->bios_dir[cnt]))
 		goto err;
 	cnt++;
 
@@ -431,16 +426,17 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 				   0440, chip->bios_dir[0],
 				   (void *)&chip->ascii_log_seqops,
 				   &tpm_bios_measurements_ops);
-	if (is_bad(chip->bios_dir[cnt]))
+	if (IS_ERR(chip->bios_dir[cnt]))
 		goto err;
 	cnt++;
 
 	return 0;
 
 err:
+	rc = PTR_ERR(chip->bios_dir[cnt]);
 	chip->bios_dir[cnt] = NULL;
 	tpm_bios_log_teardown(chip);
-	return -EIO;
+	return rc;
 }
 
 void tpm_bios_log_teardown(struct tpm_chip *chip)

------------------------------------------------------------------------------
