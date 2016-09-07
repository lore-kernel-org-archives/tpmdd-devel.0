From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/3] tpm/tpm_crb: implement power management.
Date: Wed,  7 Sep 2016 13:25:47 +0300
Message-ID: <1473243950-23579-1-git-send-email-tomas.winkler@intel.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The overall platform ability to enter a low power state is also
conditioned on the ability of a tpm device to go to idle state.
This series should provide this feature. 

Unfortunately, there is a HW bug on Intel PTT devices on Skylake,
Kabylake, and Broxton devices, where certain registers lost retention
during TPM idle state. Hence this implementation takes this into
consideration and implement the feature based only on access to
registers that retain their state. This still conforms to the spec
and should be correct also on non Intle devices.

This path series should be applied on top of the series:
'Small fixes and cleanups for tpm_crb'

Tomas Winkler (3):
  tpm/tpm_crb: implement tpm crb idle state
  tmp/tpm_crb: fix Intel PTT hw bug during idle state
  tpm/tpm_crb: cache cmd_size register value.

 drivers/char/tpm/tpm-interface.c |  21 +++++++
 drivers/char/tpm/tpm_crb.c       | 124 ++++++++++++++++++++++++++++++++++-----
 include/linux/tpm.h              |   3 +-
 3 files changed, 132 insertions(+), 16 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
