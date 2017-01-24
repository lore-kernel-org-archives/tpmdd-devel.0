From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/2] Add session handling to tpm spaces
Date: Mon, 23 Jan 2017 21:35:13 -0800
Message-ID: <1485236113.2534.69.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

These two patches are easily separated.  The first does session
handling.  This incarnation uses TPM_RC_REFERENCE_H0 errors from
context save or load to signal when a session has been flushed (so it
no longer does tracking or flush emulation).  The second patch does
management for session exhaustion and is essentially unchanged from the
prior RFC.

James

---


James Bottomley (2):
  tpm2: add session handle context saving and restoring to the space code
  tpm2-space: add handling for global session exhaustion

 drivers/char/tpm/tpm-chip.c   |   7 +
 drivers/char/tpm/tpm.h        |  42 +++++-
 drivers/char/tpm/tpm2-cmd.c   |  15 +++
 drivers/char/tpm/tpm2-space.c | 294 ++++++++++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpms-dev.c   |  25 +++-
 5 files changed, 369 insertions(+), 14 deletions(-)

-- 
2.6.6
