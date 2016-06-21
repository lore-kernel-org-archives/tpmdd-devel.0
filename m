From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v7 0/5] tpm: Command duration logging and
	chip-specific override
Date: Mon, 20 Jun 2016 18:53:57 -0700
Message-ID: <1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
References: <1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465610107-87762-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

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

 drivers/char/tpm/tpm-interface.c | 212 ++++++++++++++++++++-------------------
 drivers/char/tpm/tpm_tis.c       |  49 ++++-----
 include/linux/tpm.h              |   3 +-
 3 files changed, 130 insertions(+), 134 deletions(-)

-- 
1.9.1


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
