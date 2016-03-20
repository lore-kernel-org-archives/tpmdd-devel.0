From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/12] tpm: Add check_data handle to
	tpm_class_ops in order to check data integrity
Date: Sun, 20 Mar 2016 20:34:42 +0100
Message-ID: <1458502483-16887-12-git-send-email-christophe-h.ricard@st.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458502483-16887-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

For example, in order to compute crc over the data sent in lower layer
(i2c for instance), provide a specific handle.

The current principles:
- When sending command:
1) Host writes TPM_STS.commandReady
2) Host writes command
3) Host checks TPM received data correctly
4) if not go to step 1

- When receiving data:
1) Host check TPM_STS.dataAvail is set
2) Host get data
3) Host check received data are correct.
4) if not Host write TPM_STS.responseRetry and go to step 1.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.c | 81 ++++++++++++++++++++++++++---------------
 include/linux/tpm.h             |  1 +
 2 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index baa9ab1..9efb3ac 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -126,6 +126,14 @@ again:
 	return -1;
 }
 
+static bool tpm_tis_check_data(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	if (chip->ops->check_data)
+		return chip->ops->check_data(chip, buf, len);
+
+	return true;
+}
+
 u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	return tpm_read_byte(chip, TPM_STS(chip->vendor.locality));
@@ -197,7 +205,8 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	int size = 0;
-	int expected, status;
+	int expected, status, i;
+	bool check_data = false;
 
 	if (count < TPM_HEADER_SIZE) {
 		size = -EIO;
@@ -206,34 +215,41 @@ int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	tpm_tis_clear_int(chip);
 
-	/* read first 10 bytes, including tag, paramsize, and result */
-	size = recv_data(chip, buf, TPM_HEADER_SIZE);
-	if (size < TPM_HEADER_SIZE) {
-		dev_err(&chip->dev, "Unable to read header\n");
-		goto out;
-	}
+	for (i = 0; i < TPM_RETRY && !check_data; i++) {
+		/* read first 10 bytes, including tag, paramsize, and result */
+		size = recv_data(chip, buf, TPM_HEADER_SIZE);
+		if (size < TPM_HEADER_SIZE) {
+			dev_err(&chip->dev, "Unable to read header\n");
+			goto out;
+		}
 
-	expected = be32_to_cpu(*(__be32 *) (buf + 2));
-	if (expected > count) {
-		size = -EIO;
-		goto out;
-	}
+		expected = be32_to_cpu(*(__be32 *) (buf + 2));
+		if (expected > count) {
+			size = -EIO;
+			goto out;
+		}
 
-	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
-			  expected - TPM_HEADER_SIZE);
-	if (size < expected) {
-		dev_err(&chip->dev, "Unable to read remainder of result\n");
-		size = -ETIME;
-		goto out;
-	}
+		size += recv_data(chip, &buf[TPM_HEADER_SIZE],
+				  expected - TPM_HEADER_SIZE);
+		if (size < expected) {
+			dev_err(&chip->dev, "Unable to read remainder of result\n");
+			size = -ETIME;
+			goto out;
+		}
 
-	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
-			  &chip->vendor.int_queue, false);
-	status = tpm_tis_status(chip);
-	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(&chip->dev, "Error left over data\n");
-		size = -EIO;
-		goto out;
+		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
+				  &chip->vendor.int_queue, false);
+		status = tpm_tis_status(chip);
+		if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
+			dev_err(&chip->dev, "Error left over data\n");
+			size = -EIO;
+			goto out;
+		}
+
+		check_data = tpm_tis_check_data(chip, buf, size);
+		if (!check_data)
+			tpm_write_byte(chip, TPM_STS(chip->vendor.locality),
+				       TPM_STS_RESPONSE_RETRY);
 	}
 
 out:
@@ -323,15 +339,20 @@ static void disable_interrupts(struct tpm_chip *chip)
  */
 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	int rc;
+	int rc, i;
 	u32 ordinal;
 	unsigned long dur;
+	bool data_valid = false;
 
 	tpm_tis_clear_int(chip);
 
-	rc = tpm_tis_send_data(chip, buf, len);
-	if (rc < 0)
-		return rc;
+	for (i = 0; i < TPM_RETRY && !data_valid; i++) {
+		rc = tpm_tis_send_data(chip, buf, len);
+		if (rc < 0)
+			return rc;
+
+		data_valid = tpm_tis_check_data(chip, buf, len);
+	}
 
 	/* go and do it */
 	tpm_write_byte(chip, TPM_STS(chip->vendor.locality), TPM_STS_GO);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index f78e4fc..8e871dc 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -43,6 +43,7 @@ struct tpm_class_ops {
 	u8 (*status) (struct tpm_chip *chip);
 	bool (*update_timeouts)(struct tpm_chip *chip,
 				unsigned long *timeout_cap);
+	bool (*check_data)(struct tpm_chip *chip, u8 *buf, size_t len);
 
 	int (*read_bytes)(struct tpm_chip *chip, u32 addr, size_t len,
 			  u8 size, u8 *dst);
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
