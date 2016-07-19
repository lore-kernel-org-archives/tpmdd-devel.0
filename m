From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 0/5] Use tpm_transmit_cmd() consistently
	across kernel call sites
Date: Tue, 19 Jul 2016 16:32:44 +0300
Message-ID: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

These commits update the subsystem consistently to use
tpm_transmit_cmd() throughout the subsystem the exception being
tpm_write() where it makes sense to use the raw interface because higher
level command handling is delegated to user space. The point is to make
semantics and error handling across the kernel call sites.

v3: Removed patch that renames tpm_pcr_read_dev() to tpm1_pcr_read()
because it is not mandatory for this patch set.

v2: Added commit that drops externs from all function declarations in
tpm.h as suggested by Jason Gunthorpe.

Jarkko Sakkinen (5):
  tpm: remove unnecessary externs from tpm.h
  tpm: unify tpm_gen_interrupt()
  tpm: return error code from tpm_gen_interrupt()
  tpm: use tpm_transmit_cmd() in tpm2_probe()
  tpm: use tpm_pcr_read_dev() in tpm_do_selftest()

 drivers/char/tpm/tpm-interface.c | 32 +++++++++++++++++---------------
 drivers/char/tpm/tpm.h           | 35 +++++++++++++++++------------------
 drivers/char/tpm/tpm2-cmd.c      | 21 +--------------------
 drivers/char/tpm/tpm_tis_core.c  |  7 +++----
 4 files changed, 38 insertions(+), 57 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
