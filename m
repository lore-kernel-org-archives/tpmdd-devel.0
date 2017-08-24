From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND 2/2] tpm-interface: Fix checks of
 buffer size
Date: Thu, 24 Aug 2017 10:35:45 +0200
Message-ID: <20170824083545.13280-3-Alexander.Steffen@infineon.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170824083545.13280-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

bufsiz contains the length of the buffer, whereas bufvalid contains the
number of valid bytes within the buffer. Therefore, bufvalid should be used
as a limit when reading from the buffer and bufsize when writing to it.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 78fb41d..f481cd1 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -393,19 +393,16 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	unsigned long stop;
 	bool need_locality;
 
-	if (!tpm_validate_command(chip, space, buf, bufsiz))
+	if (!tpm_validate_command(chip, space, buf, bufvalid))
 		return -EINVAL;
 
-	if (bufsiz > TPM_BUFSIZE)
-		bufsiz = TPM_BUFSIZE;
-
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
 		return -ENODATA;
-	if (count > bufsiz || count > bufvalid) {
+	if (count > bufvalid) {
 		dev_err(&chip->dev,
-			"invalid count value %x %zx\n", count, bufsiz);
+			"invalid count value %x %zx\n", count, bufvalid);
 		return -E2BIG;
 	}
 
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
