From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically
 allocated bios_dir with a static array
Date: Tue, 11 Oct 2016 14:23:15 +0300
Message-ID: <20161011112315.GB21688@intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
	<57FBE39B.2030301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57FBE39B.2030301-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 11, 2016 at 12:23:15AM +0530, Nayna wrote:
> 
> 
> On 10/02/2016 12:55 AM, Jarkko Sakkinen wrote:
> >This commit is based on a commit by Nayna Jain. Replaced dynamically
> >allocated bios_dir with a static array as the size is always constant.
> >
> >Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >---
> >  drivers/char/tpm/tpm-chip.c     |  9 +++---
> >  drivers/char/tpm/tpm.h          |  3 +-
> >  drivers/char/tpm/tpm_eventlog.c | 62 +++++++++++++++++++----------------------
> >  drivers/char/tpm/tpm_eventlog.h | 10 +++----
> >  4 files changed, 41 insertions(+), 43 deletions(-)
> >
> >diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> >index e595013..a56b609 100644
> >--- a/drivers/char/tpm/tpm-chip.c
> >+++ b/drivers/char/tpm/tpm-chip.c
> >@@ -278,14 +278,16 @@ static void tpm_del_char_device(struct tpm_chip *chip)
> >
> >  static int tpm1_chip_register(struct tpm_chip *chip)
> >  {
> >+	int rc;
> >+
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >  		return 0;
> >
> >  	tpm_sysfs_add_device(chip);
> >
> >-	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
> >+	rc = tpm_bios_log_setup(chip);
> >
> >-	return 0;
> >+	return rc;
> >  }
> >
> >  static void tpm1_chip_unregister(struct tpm_chip *chip)
> >@@ -293,8 +295,7 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >  		return;
> >
> >-	if (chip->bios_dir)
> >-		tpm_bios_log_teardown(chip->bios_dir);
> >+	tpm_bios_log_teardown(chip);
> >  }
> >
> >  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
> >diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> >index 4d183c9..4c118a4 100644
> >--- a/drivers/char/tpm/tpm.h
> >+++ b/drivers/char/tpm/tpm.h
> >@@ -40,6 +40,7 @@ enum tpm_const {
> >  	TPM_BUFSIZE = 4096,
> >  	TPM_NUM_DEVICES = 65536,
> >  	TPM_RETRY = 50,		/* 5 seconds */
> >+	TPM_NUM_EVENT_LOG_FILES = 3,
> >  };
> >
> >  enum tpm_timeout {
> >@@ -171,7 +172,7 @@ struct tpm_chip {
> >  	unsigned long duration[3]; /* jiffies */
> >  	bool duration_adjusted;
> >
> >-	struct dentry **bios_dir;
> >+	struct dentry *bios_dir[TPM_NUM_EVENT_LOG_FILES];
> >
> >  	const struct attribute_group *groups[3];
> >  	unsigned int groups_cnt;
> >diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> >index 75e6644..f5e1d06 100644
> >--- a/drivers/char/tpm/tpm_eventlog.c
> >+++ b/drivers/char/tpm/tpm_eventlog.c
> >@@ -368,54 +368,50 @@ static int is_bad(void *p)
> >  	return 0;
> >  }
> >
> >-struct dentry **tpm_bios_log_setup(const char *name)
> >+int tpm_bios_log_setup(struct tpm_chip *chip)
> >  {
> >-	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
> >+	const char *name = dev_name(&chip->dev);
> >+	unsigned int cnt;
> >
> >-	tpm_dir = securityfs_create_dir(name, NULL);
> >-	if (is_bad(tpm_dir))
> >-		goto out;
> >+	cnt = 0;
> >+	chip->bios_dir[cnt] =
> >+		securityfs_create_dir(name, NULL);
> >+	if (is_bad(chip->bios_dir[cnt]))
> >+		goto err;
> >+	cnt++;
> >
> >-	bin_file =
> >+	chip->bios_dir[cnt] =
> >  	    securityfs_create_file("binary_bios_measurements",
> >-				   S_IRUSR | S_IRGRP, tpm_dir,
> >+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> >  				   (void *)&tpm_binary_b_measurments_seqops,
> >  				   &tpm_bios_measurements_ops);
> >-	if (is_bad(bin_file))
> >-		goto out_tpm;
> >+	if (is_bad(chip->bios_dir[cnt]))
> >+		goto err;
> >+	cnt++;
> >
> >-	ascii_file =
> >+	chip->bios_dir[cnt] =
> >  	    securityfs_create_file("ascii_bios_measurements",
> >-				   S_IRUSR | S_IRGRP, tpm_dir,
> >+				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> >  				   (void *)&tpm_ascii_b_measurments_seqops,
> >  				   &tpm_bios_measurements_ops);
> >-	if (is_bad(ascii_file))
> >-		goto out_bin;
> >+	if (is_bad(chip->bios_dir[cnt]))
> >+		goto err;
> >+	cnt++;
> >
> >-	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
> >-	if (!ret)
> >-		goto out_ascii;
> >-
> >-	ret[0] = ascii_file;
> >-	ret[1] = bin_file;
> >-	ret[2] = tpm_dir;
> >-
> >-	return ret;
> >+	return 0;
> >
> >-out_ascii:
> >-	securityfs_remove(ascii_file);
> >-out_bin:
> >-	securityfs_remove(bin_file);
> >-out_tpm:
> >-	securityfs_remove(tpm_dir);
> >-out:
> >-	return NULL;
> >+err:
> >+	chip->bios_dir[cnt] = NULL;
> 
> The updated patch looks fine.
> Just, I am not sure if NULL assignment is needed.

It's not needed.

> >+	tpm_bios_log_teardown(chip);
> >+	return -EIO;
> >  }
> >
> >-void tpm_bios_log_teardown(struct dentry **lst)
> >+void tpm_bios_log_teardown(struct tpm_chip *chip)
> >  {
> >  	int i;
> >
> >-	for (i = 0; i < 3; i++)
> >-		securityfs_remove(lst[i]);
> >+	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> >+		if (chip->bios_dir[i])
> 
> Probably, this check is not required because securityfs_remove() takes care
> of checking both NULL and err dentry.

Thanks. I did the adjustments to the eventlog branch. Please use these
three patches as "head" for your series. I'll apply the rest of patches
to this branch when you post the next version of the series.

Please also include these three patches to the next version when you
post even if they are applied there. The topic branch is there to make
the testing easier.

> Thanks & Regards,
>    - Nayna

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
