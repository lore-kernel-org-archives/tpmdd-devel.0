From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v3 0/2] tpm: add optional max xfer size check
Date: Wed, 27 Jul 2016 20:49:55 -0700
Message-ID: <1469677797-74304-1-git-send-email-apronin@chromium.org>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468546745-14646-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset introduces an optional maximum transfer size that can
be specified by a tpm driver. Setting the max_xfer_size helps to catch
the cases when burstcnt is incorrectly reported by the device (e.g. >64
for spi - happened in practice) and gracefully handle such situations.

v2: removed unnecessary accessors in tpm_tis_core.h, fixed style

v3: simplified logic: simply cap the burstcnt at max_xfer_size, don't
attempt to re-request from tpm.

Andrey Pronin (2):
  tpm_tis_core: add optional max xfer size check
  tpm_tis_spi: add max xfer size

 drivers/char/tpm/tpm_tis_core.c | 9 ++++++++-
 drivers/char/tpm/tpm_tis_core.h | 1 +
 drivers/char/tpm/tpm_tis_spi.c  | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.6.6


------------------------------------------------------------------------------
