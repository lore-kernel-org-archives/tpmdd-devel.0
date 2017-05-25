From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] tpm: vtpm_proxy: Do not run tpm2_shutdown
Date: Thu, 25 May 2017 09:12:36 -0400
Message-ID: <1495717956-14252-1-git-send-email-stefanb@linux.vnet.ibm.com>
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
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The tpm2_shutdown does not work with the VTPM proxy driver since the
function only gets called when the backend file descriptor is already
closed and at this point no data can be sent anymore. A proper shutdown
would have to be initated by a user space application, such as a container
management stack, that sends the command via the character device before
terminating the TPM emulator.

To avoid the tpm2_shutdown we introduce a TPM_CHIP_FLAG_NO_SHUTDOWN flag
that only the VTPM proxy driver sets. This also avoids misleading kernel
log messages.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm.h            | 1 +
 drivers/char/tpm/tpm2-cmd.c       | 3 +++
 drivers/char/tpm/tpm_vtpm_proxy.c | 3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 25d9858..23b656f 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -170,6 +170,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
 	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
+	TPM_CHIP_FLAG_NO_SHUTDOWN	= BIT(5),
 };
 
 struct tpm_bios_log {
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 3ee6883..495d316 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -831,6 +831,9 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
 	struct tpm2_cmd cmd;
 	int rc;
 
+	if (chip->flags & TPM_CHIP_FLAG_NO_SHUTDOWN)
+		return;
+
 	cmd.header.in = tpm2_shutdown_header;
 	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
 
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 1d877cc..d439ce7 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -573,7 +573,8 @@ static struct file *vtpm_proxy_create_device(
 	vtpm_proxy_fops_open(file);
 
 	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
-		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
+		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2 |
+					  TPM_CHIP_FLAG_NO_SHUTDOWN;
 
 	vtpm_proxy_work_start(proxy_dev);
 
-- 
2.4.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
