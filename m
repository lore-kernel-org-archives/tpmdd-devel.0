From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] Autodetect TCG event log version
Date: Wed, 29 Mar 2017 00:43:28 -0700
Message-ID: <20170329074328.y5rmk5wh3rj5kgcg@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Code expects that TPM1 devices use TPM1 version of the log,
and TPM2 devices use TPM2 version of the log.  While that
is strongly recommended by the spec, and now required by
Microsoft certification, there are systems that use TPM2
chip with SHA-1 only log.

So let's do detection based on first event in the log -
if it is Spec ID Event03, log is crypto-agile log. otherwise
it is SHA-1 log, or malformed bunch of bytes.

I'm not entirely sure how this works on PPC64: tpm1_eventlog.c
uses do_endian_conversion() on all accesses, while tpm2_eventlog.c
never does conversion.  I'm assuming that it is an ommission
from tpm2_eventlog.c code.  If PPC64 logs are really big-endian
for TPM1 while native-endian for TPM2, let me know, and I'll
modify detection code to handle both native and big endian formats.

Signed-off-by: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm1_eventlog.c | 53 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm1_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
index 9a8605e500b5..aafcecf19c48 100644
--- a/drivers/char/tpm/tpm1_eventlog.c
+++ b/drivers/char/tpm/tpm1_eventlog.c
@@ -375,6 +375,51 @@ static int tpm_read_log(struct tpm_chip *chip)
 }
 
 /*
+ * tpm_check_log_version - Check version of the event log.
+ *
+ * Returns 0 if it is TPM1 (SHA1-only) log, 1 if it is TPM2
+ * log.  -EIO if log appears to be malformed.
+ */
+static int tpm_check_log_version(const struct tpm_chip *chip)
+{
+	const struct tcpa_event *event = chip->log.bios_event_log;
+	size_t log_len = chip->log.bios_event_log_end - chip->log.bios_event_log;
+	u32 event_len;
+	const struct tcg_efi_specid_event *specid;
+	u32 num_algs;
+
+	if (log_len < sizeof *event)
+		return -EIO;	/* Too short for anything. */
+	if (do_endian_conversion(event->pcr_index) != 0 ||
+            do_endian_conversion(event->event_type) != NO_ACTION)
+		return 0;	/* Not SpecID.  Must be TPM1 log. */
+	event_len = do_endian_conversion(event->event_size);
+	if (log_len - sizeof *event < event_len)
+		return -EIO;	/* Too short for TPM1 or header event. */
+
+	/*
+	 * Only Spec ID Event03 format is supported for TPM2.
+	 * There was Spec ID Event02 format that did not include
+	 * number of algorithms or digest sizes.  To my knowledge
+	 * there are no systems using that format.
+	 */
+	if (event_len < offsetof(struct tcg_efi_specid_event, digest_sizes))
+		return 0;	/* Too short for SpecID.  Must be TPM1 log. */
+	event_len -= offsetof(struct tcg_efi_specid_event, digest_sizes);
+	specid = (const struct tcg_efi_specid_event *)event->event_data;
+	if (memcmp(specid->signature, "Spec ID Event03", 16))
+		return 0;	/* Not Spec ID Event03, not TPM2. */
+
+	num_algs = do_endian_conversion(specid->num_algs);
+	/* Use division to avoid overflow if num_algs is huge number. */
+	if (event_len / sizeof(struct tcg_efi_specid_event_algs) < num_algs)
+		return -EIO;	/* Too short for digest sizes. */
+
+	/* Looks like TPM2 log. */
+	return 1;
+}
+
+/*
  * tpm_bios_log_setup() - Read the event log from the firmware
  * @chip: TPM chip to use.
  *
@@ -394,6 +439,10 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
+	rc = tpm_check_log_version(chip);
+	if (rc < 0)
+		return rc;
+
 	cnt = 0;
 	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
 	/* NOTE: securityfs_create_dir can return ENODEV if securityfs is
@@ -404,7 +453,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	cnt++;
 
 	chip->bin_log_seqops.chip = chip;
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (rc != 0)
 		chip->bin_log_seqops.seqops =
 			&tpm2_binary_b_measurements_seqops;
 	else
@@ -421,7 +470,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 		goto err;
 	cnt++;
 
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+	if (rc == 0) {
 
 		chip->ascii_log_seqops.chip = chip;
 		chip->ascii_log_seqops.seqops =
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
