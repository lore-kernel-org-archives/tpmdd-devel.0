From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 0/4] tpm: Command duration logging and
	chip-specific override
Date: Mon,  6 Jun 2016 20:37:25 -0700
Message-ID: <1465270649-22498-1-git-send-email-eswierk@skyportsystems.com>
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

This series
- improves TPM command error reporting
- adds optional logging of TPM command durations
- allows chip-specific override of command durations, analogous
  to existing override of protocol timeouts
- overrides ST19NP18 TPM command duration to avoid lockups

Ed Swierk (4):
  tpm_tis: Improve reporting of IO errors
  tpm: Add optional logging of TPM command durations
  tpm: Allow TPM chip drivers to override reported command durations
  tpm_tis: Increase ST19NP18 TPM command duration to avoid chip lockup

 drivers/char/tpm/tpm-interface.c | 60 ++++++++++++++++++++++++++--------------
 drivers/char/tpm/tpm_tis.c       | 52 +++++++++++++++++++++++++++++++++-
 include/linux/tpm.h              |  2 ++
 3 files changed, 92 insertions(+), 22 deletions(-)

-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
