From: SZ Lin <sz.lin@moxa.com>
Subject: [PATCH 3/5] Fix 'void function return statements are not generally useful' warning
Date: Sat, 29 Jul 2017 15:24:31 +0800
Message-ID: <20170729072433.13194-4-sz.lin@moxa.com>
References: <20170729072433.13194-1-sz.lin@moxa.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-1-sz.lin@moxa.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, SZ Lin <sz.lin@moxa.com>
List-Id: tpmdd-devel@lists.sourceforge.net

WARNING: void function return statements are not generally useful
+       return;
+}

Signed-off-by: SZ Lin <sz.lin@moxa.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 23913fc86158..e53b9fb517d9 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -531,7 +531,6 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 			return;
 		}
 	}
-	return;
 }
 
 /**
-- 
2.13.3
