From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] tpm: Move remaining tpm_vendor_specific
	structure data to tpm_chip
Date: Fri, 25 Mar 2016 22:25:59 +0100
Message-ID: <1458941160-4437-6-git-send-email-christophe-h.ricard@st.com>
References: <1458941160-4437-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458941160-4437-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

As no more information in tpm_vendor_specific structure are
available in tpm_vendor_specific structure move them to tpm_chip structure.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 28 +++++------
 drivers/char/tpm/tpm-interface.c     | 48 +++++++++---------
 drivers/char/tpm/tpm-sysfs.c         | 20 ++++----
 drivers/char/tpm/tpm.h               | 12 ++---
 drivers/char/tpm/tpm2-cmd.c          |  2 +-
 drivers/char/tpm/tpm_i2c_atmel.c     |  8 +--
 drivers/char/tpm/tpm_i2c_infineon.c  | 44 ++++++++---------
 drivers/char/tpm/tpm_i2c_nuvoton.c   | 24 ++++-----
 drivers/char/tpm/tpm_tis.c           | 95 ++++++++++++++++++------------------
 drivers/char/tpm/xen-tpmfront.c      |  4 +-
 10 files changed, 141 insertions(+), 144 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 7a5de0e..2834c6f 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -131,7 +131,7 @@ static int check_locality(struct tpm_chip *chip)
 	if (status && (data &
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return chip->vendor.locality;
+		return chip->locality;
 
 	return -EACCES;
 } /* check_locality() */
@@ -148,20 +148,20 @@ static int request_locality(struct tpm_chip *chip)
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
 
-	if (check_locality(chip) == chip->vendor.locality)
-		return chip->vendor.locality;
+	if (check_locality(chip) == chip->locality)
+		return chip->locality;
 
 	data = TPM_ACCESS_REQUEST_USE;
 	ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
 	if (ret < 0)
 		return ret;
 
-	stop = jiffies + chip->vendor.timeout_a;
+	stop = jiffies + chip->timeout_a;
 
 	/* Request locality is usually effective after the request */
 	do {
 		if (check_locality(chip) >= 0)
-			return chip->vendor.locality;
+			return chip->locality;
 		msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
 
@@ -195,7 +195,7 @@ static int get_burstcount(struct tpm_chip *chip)
 	int burstcnt, status;
 	u8 temp;
 
-	stop = jiffies + chip->vendor.timeout_d;
+	stop = jiffies + chip->timeout_d;
 	do {
 		status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS + 1,
 					    &temp, 1);
@@ -323,7 +323,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	while (size < count &&
 	       wait_for_stat(chip,
 			     TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-			     chip->vendor.timeout_c,
+			     chip->timeout_c,
 			     &chip->vendor.read_queue, true) == 0) {
 		burstcnt = get_burstcount(chip);
 		if (burstcnt < 0)
@@ -388,7 +388,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 	if ((status & TPM_STS_COMMAND_READY) == 0) {
 		st33zp24_cancel(chip);
 		if (wait_for_stat
-		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
+		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b,
 		     &chip->vendor.read_queue, false) < 0) {
 			ret = -ETIME;
 			goto out_err;
@@ -543,12 +543,12 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 	tpm_dev->ops = ops;
 	dev_set_drvdata(&chip->dev, tpm_dev);
 
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+	chip->timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 
-	chip->vendor.locality = LOCALITY0;
+	chip->locality = LOCALITY0;
 
 	if (irq) {
 		/* INTERRUPT Setup */
@@ -651,7 +651,7 @@ int st33zp24_pm_resume(struct device *dev)
 	if (gpio_is_valid(tpm_dev->io_lpcpd)) {
 		gpio_set_value(tpm_dev->io_lpcpd, 1);
 		ret = wait_for_stat(chip,
-				TPM_STS_VALID, chip->vendor.timeout_b,
+				TPM_STS_VALID, chip->timeout_b,
 				&chip->vendor.read_queue, false);
 	} else {
 		ret = tpm_pm_resume(dev);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 0bdd25b..69cb082 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -319,7 +319,7 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 		duration_idx = tpm_ordinal_duration[ordinal];
 
 	if (duration_idx != TPM_UNDEFINED)
-		duration = chip->vendor.duration[duration_idx];
+		duration = chip->duration[duration_idx];
 	if (duration <= 0)
 		return 2 * 60 * HZ;
 	else
@@ -505,15 +505,15 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		/* Fixed timeouts for TPM2 */
-		chip->vendor.timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
-		chip->vendor.timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
-		chip->vendor.timeout_c = msecs_to_jiffies(TPM2_TIMEOUT_C);
-		chip->vendor.timeout_d = msecs_to_jiffies(TPM2_TIMEOUT_D);
-		chip->vendor.duration[TPM_SHORT] =
+		chip->timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
+		chip->timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
+		chip->timeout_c = msecs_to_jiffies(TPM2_TIMEOUT_C);
+		chip->timeout_d = msecs_to_jiffies(TPM2_TIMEOUT_D);
+		chip->duration[TPM_SHORT] =
 		    msecs_to_jiffies(TPM2_DURATION_SHORT);
-		chip->vendor.duration[TPM_MEDIUM] =
+		chip->duration[TPM_MEDIUM] =
 		    msecs_to_jiffies(TPM2_DURATION_MEDIUM);
-		chip->vendor.duration[TPM_LONG] =
+		chip->duration[TPM_LONG] =
 		    msecs_to_jiffies(TPM2_DURATION_LONG);
 		return 0;
 	}
@@ -561,10 +561,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	 * of misreporting.
 	 */
 	if (chip->ops->update_timeouts != NULL)
-		chip->vendor.timeout_adjusted =
+		chip->timeout_adjusted =
 			chip->ops->update_timeouts(chip, new_timeout);
 
-	if (!chip->vendor.timeout_adjusted) {
+	if (!chip->timeout_adjusted) {
 		/* Don't overwrite default if value is 0 */
 		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
 			int i;
@@ -572,12 +572,12 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 			/* timeouts in msec rather usec */
 			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
 				new_timeout[i] *= 1000;
-			chip->vendor.timeout_adjusted = true;
+			chip->timeout_adjusted = true;
 		}
 	}
 
 	/* Report adjusted timeouts */
-	if (chip->vendor.timeout_adjusted) {
+	if (chip->timeout_adjusted) {
 		dev_info(&chip->dev,
 			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
 			 old_timeout[0], new_timeout[0],
@@ -586,10 +586,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 			 old_timeout[3], new_timeout[3]);
 	}
 
-	chip->vendor.timeout_a = usecs_to_jiffies(new_timeout[0]);
-	chip->vendor.timeout_b = usecs_to_jiffies(new_timeout[1]);
-	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
-	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
+	chip->timeout_a = usecs_to_jiffies(new_timeout[0]);
+	chip->timeout_b = usecs_to_jiffies(new_timeout[1]);
+	chip->timeout_c = usecs_to_jiffies(new_timeout[2]);
+	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
 
 duration:
 	tpm_cmd.header.in = tpm_getcap_header;
@@ -608,11 +608,11 @@ duration:
 		return -EINVAL;
 
 	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
-	chip->vendor.duration[TPM_SHORT] =
+	chip->duration[TPM_SHORT] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
-	chip->vendor.duration[TPM_MEDIUM] =
+	chip->duration[TPM_MEDIUM] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
-	chip->vendor.duration[TPM_LONG] =
+	chip->duration[TPM_LONG] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
 
 	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
@@ -620,11 +620,11 @@ duration:
 	 * fix up the resulting too-small TPM_SHORT value to make things work.
 	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
 	 */
-	if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
-		chip->vendor.duration[TPM_SHORT] = HZ;
-		chip->vendor.duration[TPM_MEDIUM] *= 1000;
-		chip->vendor.duration[TPM_LONG] *= 1000;
-		chip->vendor.duration_adjusted = true;
+	if (chip->duration[TPM_SHORT] < (HZ / 100)) {
+		chip->duration[TPM_SHORT] = HZ;
+		chip->duration[TPM_MEDIUM] *= 1000;
+		chip->duration[TPM_LONG] *= 1000;
+		chip->duration_adjusted = true;
 		dev_info(&chip->dev, "Adjusting TPM timeout parameters.");
 	}
 	return 0;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 34e7fc7..a7c3473 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -236,14 +236,14 @@ static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip->vendor.duration[TPM_LONG] == 0)
+	if (chip->duration[TPM_LONG] == 0)
 		return 0;
 
 	return sprintf(buf, "%d %d %d [%s]\n",
-		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
-		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
-		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
-		       chip->vendor.duration_adjusted
+		       jiffies_to_usecs(chip->duration[TPM_SHORT]),
+		       jiffies_to_usecs(chip->duration[TPM_MEDIUM]),
+		       jiffies_to_usecs(chip->duration[TPM_LONG]),
+		       chip->duration_adjusted
 		       ? "adjusted" : "original");
 }
 static DEVICE_ATTR_RO(durations);
@@ -254,11 +254,11 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d %d %d %d [%s]\n",
-		       jiffies_to_usecs(chip->vendor.timeout_a),
-		       jiffies_to_usecs(chip->vendor.timeout_b),
-		       jiffies_to_usecs(chip->vendor.timeout_c),
-		       jiffies_to_usecs(chip->vendor.timeout_d),
-		       chip->vendor.timeout_adjusted
+		       jiffies_to_usecs(chip->timeout_a),
+		       jiffies_to_usecs(chip->timeout_b),
+		       jiffies_to_usecs(chip->timeout_c),
+		       jiffies_to_usecs(chip->timeout_d),
+		       chip->timeout_adjusted
 		       ? "adjusted" : "original");
 }
 static DEVICE_ATTR_RO(timeouts);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 26c8d62..cfd5420 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -131,12 +131,6 @@ enum tpm2_startup_types {
 struct tpm_chip;
 
 struct tpm_vendor_specific {
-	int locality;
-	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
-	bool timeout_adjusted;
-	unsigned long duration[3]; /* jiffies */
-	bool duration_adjusted;
-
 	wait_queue_head_t read_queue;
 };
 
@@ -170,7 +164,11 @@ struct tpm_chip {
 
 	struct mutex tpm_mutex;	/* tpm is processing */
 
-	struct tpm_vendor_specific vendor;
+	int locality;
+	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
+	bool timeout_adjusted;
+	unsigned long duration[3]; /* jiffies */
+	bool duration_adjusted;
 
 	struct dentry **bios_dir;
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 5fc0e7c..9ce8031 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -793,7 +793,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 		index = tpm2_ordinal_duration[ordinal - TPM2_CC_FIRST];
 
 	if (index != TPM_UNDEFINED)
-		duration = chip->vendor.duration[index];
+		duration = chip->duration[index];
 
 	if (duration <= 0)
 		duration = 2 * 60 * HZ;
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index fe06885..648c0b1 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -168,10 +168,10 @@ static int i2c_atmel_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
+	chip->timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
 
 	dev_set_drvdata(&chip->dev, priv);
 
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 093daf9..163d823 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -288,7 +288,7 @@ static int check_locality(struct tpm_chip *chip, int loc)
 
 	if ((buf & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
-		chip->vendor.locality = loc;
+		chip->locality = loc;
 		return loc;
 	}
 
@@ -320,7 +320,7 @@ static int request_locality(struct tpm_chip *chip, int loc)
 	iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
 
 	/* wait for burstcount */
-	stop = jiffies + chip->vendor.timeout_a;
+	stop = jiffies + chip->timeout_a;
 	do {
 		if (check_locality(chip, loc) >= 0)
 			return loc;
@@ -337,7 +337,7 @@ static u8 tpm_tis_i2c_status(struct tpm_chip *chip)
 	u8 i = 0;
 
 	do {
-		if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
+		if (iic_tpm_read(TPM_STS(chip->locality), &buf, 1) < 0)
 			return 0;
 
 		i++;
@@ -351,7 +351,7 @@ static void tpm_tis_i2c_ready(struct tpm_chip *chip)
 {
 	/* this causes the current command to be aborted */
 	u8 buf = TPM_STS_COMMAND_READY;
-	iic_tpm_write_long(TPM_STS(chip->vendor.locality), &buf, 1);
+	iic_tpm_write_long(TPM_STS(chip->locality), &buf, 1);
 }
 
 static ssize_t get_burstcount(struct tpm_chip *chip)
@@ -362,10 +362,10 @@ static ssize_t get_burstcount(struct tpm_chip *chip)
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
-	stop = jiffies + chip->vendor.timeout_d;
+	stop = jiffies + chip->timeout_d;
 	do {
 		/* Note: STS is little endian */
-		if (iic_tpm_read(TPM_STS(chip->vendor.locality)+1, buf, 3) < 0)
+		if (iic_tpm_read(TPM_STS(chip->locality)+1, buf, 3) < 0)
 			burstcnt = 0;
 		else
 			burstcnt = (buf[2] << 16) + (buf[1] << 8) + buf[0];
@@ -419,7 +419,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 		if (burstcnt > (count - size))
 			burstcnt = count - size;
 
-		rc = iic_tpm_read(TPM_DATA_FIFO(chip->vendor.locality),
+		rc = iic_tpm_read(TPM_DATA_FIFO(chip->locality),
 				  &(buf[size]), burstcnt);
 		if (rc == 0)
 			size += burstcnt;
@@ -464,7 +464,7 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
+	wait_for_stat(chip, TPM_STS_VALID, chip->timeout_c, &status);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
 		dev_err(&chip->dev, "Error left over data\n");
 		size = -EIO;
@@ -477,7 +477,7 @@ out:
 	 * so we sleep rather than keeping the bus busy
 	 */
 	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 	return size;
 }
 
@@ -500,7 +500,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		tpm_tis_i2c_ready(chip);
 		if (wait_for_stat
 		    (chip, TPM_STS_COMMAND_READY,
-		     chip->vendor.timeout_b, &status) < 0) {
+		     chip->timeout_b, &status) < 0) {
 			rc = -ETIME;
 			goto out_err;
 		}
@@ -516,7 +516,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		if (burstcnt > (len - 1 - count))
 			burstcnt = len - 1 - count;
 
-		rc = iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality),
+		rc = iic_tpm_write(TPM_DATA_FIFO(chip->locality),
 				   &(buf[count]), burstcnt);
 		if (rc == 0)
 			count += burstcnt;
@@ -530,7 +530,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		}
 
 		wait_for_stat(chip, TPM_STS_VALID,
-			      chip->vendor.timeout_c, &status);
+			      chip->timeout_c, &status);
 
 		if ((status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
@@ -539,15 +539,15 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	}
 
 	/* write last byte */
-	iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality), &(buf[count]), 1);
-	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
+	iic_tpm_write(TPM_DATA_FIFO(chip->locality), &(buf[count]), 1);
+	wait_for_stat(chip, TPM_STS_VALID, chip->timeout_c, &status);
 	if ((status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
 		goto out_err;
 	}
 
 	/* go and do it */
-	iic_tpm_write(TPM_STS(chip->vendor.locality), &sts, 1);
+	iic_tpm_write(TPM_STS(chip->locality), &sts, 1);
 
 	return len;
 out_err:
@@ -556,7 +556,7 @@ out_err:
 	 * so we sleep rather than keeping the bus busy
 	 */
 	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 	return rc;
 }
 
@@ -586,10 +586,10 @@ static int tpm_tis_i2c_init(struct device *dev)
 		return PTR_ERR(chip);
 
 	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+	chip->timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 
 	if (request_locality(chip, 0) != 0) {
 		dev_err(dev, "could not request locality\n");
@@ -623,7 +623,7 @@ static int tpm_tis_i2c_init(struct device *dev)
 
 	return tpm_chip_register(chip);
 out_release:
-	release_locality(chip, chip->vendor.locality, 1);
+	release_locality(chip, chip->locality, 1);
 	tpm_dev.client = NULL;
 out_err:
 	return rc;
@@ -695,7 +695,7 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
 	struct tpm_chip *chip = tpm_dev.chip;
 
 	tpm_chip_unregister(chip);
-	release_locality(chip, chip->vendor.locality, 1);
+	release_locality(chip, chip->locality, 1);
 	tpm_dev.client = NULL;
 
 	return 0;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index bf3ba18..97f0e1a 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -143,7 +143,7 @@ static void i2c_nuvoton_ready(struct tpm_chip *chip)
 static int i2c_nuvoton_get_burstcount(struct i2c_client *client,
 				      struct tpm_chip *chip)
 {
-	unsigned long stop = jiffies + chip->vendor.timeout_d;
+	unsigned long stop = jiffies + chip->timeout_d;
 	s32 status;
 	int burst_count = -1;
 	u8 data;
@@ -237,7 +237,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 
 	while (size < count &&
 	       i2c_nuvoton_wait_for_data_avail(chip,
-					       chip->vendor.timeout_c,
+					       chip->timeout_c,
 					       &chip->vendor.read_queue) == 0) {
 		burst_count = i2c_nuvoton_get_burstcount(client, chip);
 		if (burst_count < 0) {
@@ -286,7 +286,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		 * tag, paramsize, and result
 		 */
 		status = i2c_nuvoton_wait_for_data_avail(
-			chip, chip->vendor.timeout_c, &chip->vendor.read_queue);
+			chip, chip->timeout_c, &chip->vendor.read_queue);
 		if (status != 0) {
 			dev_err(dev, "%s() timeout on dataAvail\n", __func__);
 			size = -ETIMEDOUT;
@@ -326,7 +326,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		}
 		if (i2c_nuvoton_wait_for_stat(
 			    chip, TPM_STS_VALID | TPM_STS_DATA_AVAIL,
-			    TPM_STS_VALID, chip->vendor.timeout_c,
+			    TPM_STS_VALID, chip->timeout_c,
 			    NULL)) {
 			dev_err(dev, "%s() error left over data\n", __func__);
 			size = -ETIMEDOUT;
@@ -358,7 +358,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		i2c_nuvoton_ready(chip);
 		if (i2c_nuvoton_wait_for_stat(chip, TPM_STS_COMMAND_READY,
 					      TPM_STS_COMMAND_READY,
-					      chip->vendor.timeout_b, NULL)) {
+					      chip->timeout_b, NULL)) {
 			dev_err(dev, "%s() timeout on commandReady\n",
 				__func__);
 			rc = -EIO;
@@ -390,7 +390,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 						       TPM_STS_EXPECT,
 						       TPM_STS_VALID |
 						       TPM_STS_EXPECT,
-						       chip->vendor.timeout_c,
+						       chip->timeout_c,
 						       NULL);
 			if (rc < 0) {
 				dev_err(dev, "%s() timeout on Expect\n",
@@ -415,7 +415,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		rc = i2c_nuvoton_wait_for_stat(chip,
 					       TPM_STS_VALID | TPM_STS_EXPECT,
 					       TPM_STS_VALID,
-					       chip->vendor.timeout_c, NULL);
+					       chip->timeout_c, NULL);
 		if (rc) {
 			dev_err(dev, "%s() timeout on Expect to clear\n",
 				__func__);
@@ -543,10 +543,10 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	init_waitqueue_head(&chip->vendor.read_queue);
 
 	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
+	chip->timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+	chip->timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
 
 	dev_set_drvdata(&chip->dev, priv);
 
@@ -577,7 +577,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 			rc = i2c_nuvoton_wait_for_stat(chip,
 						       TPM_STS_COMMAND_READY,
 						       TPM_STS_COMMAND_READY,
-						       chip->vendor.timeout_b,
+						       chip->timeout_b,
 						       NULL);
 			if (rc == 0) {
 				/*
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 79edfc3..1ec4992 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -131,7 +131,7 @@ static inline int is_itpm(struct acpi_device *dev)
 static int wait_startup(struct tpm_chip *chip, int l)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
-	unsigned long stop = jiffies + chip->vendor.timeout_a;
+	unsigned long stop = jiffies + chip->timeout_a;
 
 	do {
 		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
@@ -149,7 +149,7 @@ static int check_locality(struct tpm_chip *chip, int l)
 	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
 	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return chip->vendor.locality = l;
+		return chip->locality = l;
 
 	return -1;
 }
@@ -177,7 +177,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 	iowrite8(TPM_ACCESS_REQUEST_USE,
 		 priv->iobase + TPM_ACCESS(l));
 
-	stop = jiffies + chip->vendor.timeout_a;
+	stop = jiffies + chip->timeout_a;
 
 	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 again:
@@ -211,7 +211,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
 
 	return ioread8(priv->iobase +
-		       TPM_STS(chip->vendor.locality));
+		       TPM_STS(chip->locality));
 }
 
 static void tpm_tis_ready(struct tpm_chip *chip)
@@ -220,7 +220,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
 
 	/* this causes the current command to be aborted */
 	iowrite8(TPM_STS_COMMAND_READY,
-		 priv->iobase + TPM_STS(chip->vendor.locality));
+		 priv->iobase + TPM_STS(chip->locality));
 }
 
 static int get_burstcount(struct tpm_chip *chip)
@@ -231,12 +231,12 @@ static int get_burstcount(struct tpm_chip *chip)
 
 	/* wait for burstcount */
 	/* which timeout value, spec has 2 answers (c & d) */
-	stop = jiffies + chip->vendor.timeout_d;
+	stop = jiffies + chip->timeout_d;
 	do {
 		burstcnt = ioread8(priv->iobase +
-				   TPM_STS(chip->vendor.locality) + 1);
+				   TPM_STS(chip->locality) + 1);
 		burstcnt += ioread8(priv->iobase +
-				    TPM_STS(chip->vendor.locality) +
+				    TPM_STS(chip->locality) +
 				    2) << 8;
 		if (burstcnt)
 			return burstcnt;
@@ -252,14 +252,13 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 	while (size < count &&
 	       wait_for_tpm_stat(chip,
 				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-				 chip->vendor.timeout_c,
+				 chip->timeout_c,
 				 &chip->vendor.read_queue, true)
 	       == 0) {
 		burstcnt = get_burstcount(chip);
 		for (; burstcnt > 0 && size < count; burstcnt--)
 			buf[size++] = ioread8(priv->iobase +
-					      TPM_DATA_FIFO(chip->vendor.
-							    locality));
+					      TPM_DATA_FIFO(chip->locality));
 	}
 	return size;
 }
@@ -296,7 +295,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
@@ -307,7 +306,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 out:
 	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 	return size;
 }
 
@@ -333,7 +332,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	if ((status & TPM_STS_COMMAND_READY) == 0) {
 		tpm_tis_ready(chip);
 		if (wait_for_tpm_stat
-		    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
+		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b,
 		     &priv->int_queue, false) < 0) {
 			rc = -ETIME;
 			goto out_err;
@@ -344,11 +343,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 		burstcnt = get_burstcount(chip);
 		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
 			iowrite8(buf[count], priv->iobase +
-				 TPM_DATA_FIFO(chip->vendor.locality));
+				 TPM_DATA_FIFO(chip->locality));
 			count++;
 		}
 
-		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 				  &priv->int_queue, false);
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
@@ -359,8 +358,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	/* write last byte */
 	iowrite8(buf[count],
-		 priv->iobase + TPM_DATA_FIFO(chip->vendor.locality));
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+		 priv->iobase + TPM_DATA_FIFO(chip->locality));
+	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
 	if ((status & TPM_STS_DATA_EXPECT) != 0) {
@@ -372,7 +371,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 out_err:
 	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 	return rc;
 }
 
@@ -383,10 +382,10 @@ static void disable_interrupts(struct tpm_chip *chip)
 
 	intmask =
 	    ioread32(priv->iobase +
-		     TPM_INT_ENABLE(chip->vendor.locality));
+		     TPM_INT_ENABLE(chip->locality));
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
+		  priv->iobase + TPM_INT_ENABLE(chip->locality));
 	devm_free_irq(&chip->dev, priv->irq, chip);
 	priv->irq = 0;
 	chip->flags &= ~TPM_CHIP_FLAG_USES_IRQ;
@@ -410,7 +409,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	/* go and do it */
 	iowrite8(TPM_STS_GO,
-		 priv->iobase + TPM_STS(chip->vendor.locality));
+		 priv->iobase + TPM_STS(chip->locality));
 
 	if (chip->flags & TPM_CHIP_FLAG_USES_IRQ) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
@@ -430,7 +429,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 	return len;
 out_err:
 	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 	return rc;
 }
 
@@ -516,7 +515,7 @@ static int probe_itpm(struct tpm_chip *chip)
 		goto out;
 
 	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 
 	itpm = true;
 
@@ -530,7 +529,7 @@ static int probe_itpm(struct tpm_chip *chip)
 out:
 	itpm = rem_itpm;
 	tpm_tis_ready(chip);
-	release_locality(chip, chip->vendor.locality, 0);
+	release_locality(chip, chip->locality, 0);
 
 	return rc;
 }
@@ -569,7 +568,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	int i;
 
 	interrupt = ioread32(priv->iobase +
-			     TPM_INT_STATUS(chip->vendor.locality));
+			     TPM_INT_STATUS(chip->locality));
 
 	if (interrupt == 0)
 		return IRQ_NONE;
@@ -589,8 +588,8 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	/* Clear interrupts handled with TPM_EOI */
 	iowrite32(interrupt,
 		  priv->iobase +
-		  TPM_INT_STATUS(chip->vendor.locality));
-	ioread32(priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
+		  TPM_INT_STATUS(chip->locality));
+	ioread32(priv->iobase + TPM_INT_STATUS(chip->locality));
 	return IRQ_HANDLED;
 }
 
@@ -613,18 +612,18 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	priv->irq = irq;
 
 	original_int_vec = ioread8(priv->iobase +
-				   TPM_INT_VECTOR(chip->vendor.locality));
+				   TPM_INT_VECTOR(chip->locality));
 	iowrite8(irq,
-		 priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
+		 priv->iobase + TPM_INT_VECTOR(chip->locality));
 
 	/* Clear all existing */
 	iowrite32(ioread32(priv->iobase +
-			   TPM_INT_STATUS(chip->vendor.locality)),
-		  priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
+			   TPM_INT_STATUS(chip->locality)),
+		  priv->iobase + TPM_INT_STATUS(chip->locality));
 
 	/* Turn on */
 	iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
-		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
+		  priv->iobase + TPM_INT_ENABLE(chip->locality));
 
 	priv->irq_tested = false;
 
@@ -641,7 +640,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_USES_IRQ)) {
 		iowrite8(original_int_vec,
-			 priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
+			 priv->iobase + TPM_INT_VECTOR(chip->locality));
 		return 1;
 	}
 
@@ -659,7 +658,7 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 	int i;
 
 	original_int_vec = ioread8(priv->iobase +
-				   TPM_INT_VECTOR(chip->vendor.locality));
+				   TPM_INT_VECTOR(chip->locality));
 
 	if (!original_int_vec) {
 		if (IS_ENABLED(CONFIG_X86))
@@ -685,10 +684,10 @@ static void tpm_tis_remove(struct tpm_chip *chip)
 
 	iowrite32(~TPM_GLOBAL_INT_ENABLE &
 		  ioread32(priv->iobase +
-			   TPM_INT_ENABLE(chip->vendor.
+			   TPM_INT_ENABLE(chip->
 					  locality)),
-			   priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
-	release_locality(chip, chip->vendor.locality, 1);
+			   priv->iobase + TPM_INT_ENABLE(chip->locality));
+	release_locality(chip, chip->locality, 1);
 }
 
 static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
@@ -716,10 +715,10 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		return PTR_ERR(priv->iobase);
 
 	/* Maximum timeouts */
-	chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
-	chip->vendor.timeout_b = TIS_TIMEOUT_B_MAX;
-	chip->vendor.timeout_c = TIS_TIMEOUT_C_MAX;
-	chip->vendor.timeout_d = TIS_TIMEOUT_D_MAX;
+	chip->timeout_a = TIS_TIMEOUT_A_MAX;
+	chip->timeout_b = TIS_TIMEOUT_B_MAX;
+	chip->timeout_c = TIS_TIMEOUT_C_MAX;
+	chip->timeout_d = TIS_TIMEOUT_D_MAX;
 
 	dev_set_drvdata(&chip->dev, priv);
 
@@ -730,12 +729,12 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 
 	/* Take control of the TPM's interrupt hardware and shut it off */
 	intmask = ioread32(priv->iobase +
-			   TPM_INT_ENABLE(chip->vendor.locality));
+			   TPM_INT_ENABLE(chip->locality));
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
+		  priv->iobase + TPM_INT_ENABLE(chip->locality));
 
 	if (request_locality(chip, 0) != 0) {
 		rc = -ENODEV;
@@ -769,7 +768,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	/* Figure out the capabilities */
 	intfcaps =
 	    ioread32(priv->iobase +
-		     TPM_INTF_CAPS(chip->vendor.locality));
+		     TPM_INTF_CAPS(chip->locality));
 	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
 		intfcaps);
 	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
@@ -853,17 +852,17 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 	/* reenable interrupts that device may have lost or
 	   BIOS/firmware may have disabled */
 	iowrite8(priv->irq, priv->iobase +
-		 TPM_INT_VECTOR(chip->vendor.locality));
+		 TPM_INT_VECTOR(chip->locality));
 
 	intmask =
-	    ioread32(priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
+	    ioread32(priv->iobase + TPM_INT_ENABLE(chip->locality));
 
 	intmask |= TPM_INTF_CMD_READY_INT
 	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
 	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
 
 	iowrite32(intmask,
-		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
+		  priv->iobase + TPM_INT_ENABLE(chip->locality));
 }
 
 static int tpm_tis_resume(struct device *dev)
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index a903f86..0bdebe9 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -88,7 +88,7 @@ static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 		return -EINVAL;
 
 	/* Wait for completion of any existing command or cancellation */
-	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, chip->vendor.timeout_c,
+	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, chip->timeout_c,
 			&chip->vendor.read_queue, true) < 0) {
 		vtpm_cancel(chip);
 		return -ETIME;
@@ -125,7 +125,7 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return -ECANCELED;
 
 	/* In theory the wait at the end of _send makes this one unnecessary */
-	if (wait_for_tpm_stat(chip, VTPM_STATUS_RESULT, chip->vendor.timeout_c,
+	if (wait_for_tpm_stat(chip, VTPM_STATUS_RESULT, chip->timeout_c,
 			&chip->vendor.read_queue, true) < 0) {
 		vtpm_cancel(chip);
 		return -ETIME;
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
