From: Fabio Urquiza <flus-/PpS1Qp42A70xEqrn79Vhg@public.gmane.org>
Subject: [PATCH] tpm_i2c_atmel: fix i2c_atmel_recv() when
	response is greater than 35 bytes
Date: Tue, 22 Nov 2016 09:40:07 -0300
Message-ID: <20161122124007.16487-1-flus@cesar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If the variable expected_len is greater than 35 bytes, i2c_atmel_recv()
ignores the amount of data already read in i2c_atmel_read_status() and
request more data than what the device is ready to supply. As result the
TPM data sent to the upper layers will miss the first 35 bytes of the
response and will be filled with garbage in the end.

TCSP_GetRandom_Internal before fix:

tpm_i2c_atmel 0-0020: i2c_atmel_send(buf=00 c1 00 00 00 0e 00 00 00 46 00 00 00 20 len=e) -> sts=14
tpm_i2c_atmel 0-0020: i2c_atmel_read_status: sts=-6
tpm_i2c_atmel 0-0020: i2c_atmel_read_status: sts=35
tpm_i2c_atmel 0-0020: i2c_atmel_recv reread(buf=3b ec a5 17 37 27 2a fb a0 cc ce ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff count=1000) -> ret=46

TCSP_GetRandom_Internal after fix:

tpm_i2c_atmel 0-0020: i2c_atmel_send(buf=00 c1 00 00 00 0e 00 00 00 46 00 00 00 20 len=e) -> sts=14
tpm_i2c_atmel 0-0020: i2c_atmel_read_status: sts=-6
tpm_i2c_atmel 0-0020: i2c_atmel_read_status: sts=35
tpm_i2c_atmel 0-0020: i2c_atmel_recv reread(buf=00 c4 00 00 00 2e 00 00 00 00 00 00 00 20 63 dc 83 a1 55 e6 b4 5d 5a 10 70 63 28 5c 5b a8 87 ca 57 fd 45 c3 a0 62 1b c2 1d b3 d2 0d 8f 19 count=1000) -> ret=46

Signed-off-by: Fabio Urquiza <flus-/PpS1Qp42A70xEqrn79Vhg@public.gmane.org>
---
 drivers/char/tpm/tpm_i2c_atmel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 95ce2e9..a02f5a7 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -75,9 +75,9 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	struct tpm_output_header *hdr =
 		(struct tpm_output_header *)priv->buffer;
 	u32 expected_len;
-	int rc;
+	int rc = priv->len;
 
-	if (priv->len == 0)
+	if (rc == 0)
 		return -EIO;
 
 	/* Get the message size from the message header, if we didn't get the
@@ -87,7 +87,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	if (expected_len > count)
 		return -ENOMEM;
 
-	if (priv->len >= expected_len) {
+	if (rc >= expected_len) {
 		dev_dbg(&chip->dev,
 			"%s early(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 			(int)min_t(size_t, 64, expected_len), buf, count,
@@ -96,7 +96,8 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return expected_len;
 	}
 
-	rc = i2c_master_recv(client, buf, expected_len);
+	memcpy(buf, priv->buffer, rc);
+	rc += i2c_master_recv(client, buf + rc, expected_len - rc);
 	dev_dbg(&chip->dev,
 		"%s reread(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 		(int)min_t(size_t, 64, expected_len), buf, count,
-- 
2.1.4

------------------------------------------------------------------------------
