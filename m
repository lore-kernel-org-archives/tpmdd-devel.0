From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 0/3] Various struct device cleanups
Date: Fri, 12 Feb 2016 17:04:28 -0700
Message-ID: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
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
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

These little clean ups were missed during the struct device conversion of
tpm_chip. There were noticed when looking at Stefan's vtpm patch sets.

Nothing very significant
 - Add some missing krefs
 - Replace chip->devname with dev_name
 - Replace chip->pdev with chip->dev.parent

Jason Gunthorpe (3):
  tpm: Hold the kref during tpm_chip_find_get
  tpm: Get rid of chip->pdev
  tpm: Get rid of devname

 drivers/char/tpm/tpm-chip.c         | 34 +++++++++++++++++++---------------
 drivers/char/tpm/tpm-dev.c          |  4 +---
 drivers/char/tpm/tpm-interface.c    | 30 ++++++++++++++++--------------
 drivers/char/tpm/tpm-sysfs.c        |  6 +++---
 drivers/char/tpm/tpm.h              |  5 ++---
 drivers/char/tpm/tpm2-cmd.c         |  8 ++++----
 drivers/char/tpm/tpm_atmel.c        | 14 +++++++-------
 drivers/char/tpm/tpm_eventlog.c     |  2 +-
 drivers/char/tpm/tpm_eventlog.h     |  2 +-
 drivers/char/tpm/tpm_i2c_atmel.c    | 16 ++++++++--------
 drivers/char/tpm/tpm_i2c_infineon.c |  6 +++---
 drivers/char/tpm/tpm_i2c_nuvoton.c  | 28 ++++++++++++++--------------
 drivers/char/tpm/tpm_infineon.c     | 22 +++++++++++-----------
 drivers/char/tpm/tpm_nsc.c          | 20 ++++++++++----------
 drivers/char/tpm/tpm_tis.c          | 18 +++++++++---------
 15 files changed, 109 insertions(+), 106 deletions(-)

-- 
2.1.4


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
