From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/3] Migrate TPM documentation to rst/Sphinx
	scheme
Date: Thu,  3 Nov 2016 17:57:49 -0600
Message-ID: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
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

Moved TPM documentation under rst/Sphinx scheme except xen-tpmfront.txt
because it contains ASCII diagrams that I do not know how to handle.

Jarkko Sakkinen (3):
  tpm, tpm_vtpm_proxy: add kdoc comments for VTPM_PROXY_IOC_NEW_DEV
  tpm: transition tpm_vtpm_proxy documentation to the Sphinx
  tpm: move documentation under Documentation/security

 Documentation/index.rst                            |  1 +
 Documentation/security/index.rst                   |  7 +++
 Documentation/security/tpm/index.rst               |  7 +++
 .../tpm/tpm_vtpm_proxy.rst}                        | 55 +++++------------
 Documentation/{ => security}/tpm/xen-tpmfront.txt  |  0
 drivers/char/tpm/tpm_vtpm_proxy.c                  | 72 ++++++++++++++--------
 include/uapi/linux/vtpm_proxy.h                    | 23 +++++--
 7 files changed, 97 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/security/index.rst
 create mode 100644 Documentation/security/tpm/index.rst
 rename Documentation/{tpm/tpm_vtpm_proxy.txt => security/tpm/tpm_vtpm_proxy.rst} (53%)
 rename Documentation/{ => security}/tpm/xen-tpmfront.txt (100%)

-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
