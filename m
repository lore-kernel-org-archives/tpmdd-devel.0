From: Ed Swierk <eswierk@skyportsystems.com>
Subject: [PATCH v9 0/5] tpm: Command duration logging and chip-specific override
Date: Wed, 13 Jul 2016 09:19:31 -0700
Message-ID: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com, eswierk@skyportsystems.com
List-Id: tpmdd-devel@lists.sourceforge.net

v9: Include command duration in existing error messages rather than
logging an extra debug message. Rebase onto Jarkko's tree.

v8: Fix v7 goof-up in tpm_getcap().

v7: Use tpm_getcap() instead of a redundant new function.

v6: Split tpm_get_cap_prop() out of tpm_get_timeouts(); always return
error on TPM command failure.

v5: Use msecs_to_jiffies() instead of * HZ / 1000.

v4: Rework tpm_get_timeouts() to allow overriding both timeouts and
durations via a single callback.

This series
- improves TPM command error reporting
- adds optional logging of TPM command durations
- allows chip-specific override of command durations as well as protocol
  timeouts
- overrides ST19NP18 TPM command duration to avoid lockups

Ed Swierk (5):
  tpm_tis: Improve reporting of IO errors
  tpm: Add optional logging of TPM command durations
  tpm: Clean up reading of timeout and duration capabilities
  tpm: Allow TPM chip drivers to override reported command durations
  tpm_tis: Increase ST19NP18 TPM command duration to avoid chip lockup

 drivers/char/tpm/tpm-interface.c | 219 ++++++++++++++++++++-------------------
 drivers/char/tpm/tpm_tis_core.c  |  46 ++++----
 include/linux/tpm.h              |   3 +-
 3 files changed, 136 insertions(+), 132 deletions(-)

-- 
1.9.1
