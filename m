From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 00/12] Rework of tpm_tis to share common
	logic accross phy's (lpc/spi/-i2c-)
Date: Tue, 19 Apr 2016 00:17:32 +0200
Message-ID: <1461017864-3903-1-git-send-email-christophe-h.ricard@st.com>
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
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

This serie is including common work from Infineon (Peter Huewe & Alexander Steffen) and ST.
We propose a common low level API used by a core TIS interface allowing to share
some protocols behavior between physical layers (lpc, spi, i2c...) or drivers.

To easy the group review, i only send 10 patches showing how we rework the tpm_tis driver
keeping existing proprietary logic (itpm workaround, irq for tpm_tis ("lpc")).
Finally we are adding spi support based on TCG PTP specification. This additional driver
support the SPI bit protocol including optional flow control.

Reworked tpm_tis got validated on a HP 8200 machine with an Infineon TPM
tpm_tis_spi got validated using Minnowboard Max as well as Raspberry Pi.

v2:
- Add Rob Herring acks on devicetree specific patch
- Renamed priv_data tpm_tis_data
- Moved data_expect_val & data_expect_mask in tpm_tis_data
- Moved "hal" (e.g: tpm_write_xxx/tpm_read_xxx) in tpm_tis_core.h
- Reduced list of the exported functions from tpm_tis_core
- Make tpm_tis ops internal to tpm_tis_core

v3:
- Merge tpm_class_lowlevel and tpm_tis_phy_ops
- Changed the way phy specific structure looked like in order to use container_of
- Cleanup patches with rebase mistakes and build verify them...
- Moved "Add include guards in tpm.h" at first position

v4:
- Move patch "Use read/write_bytes for drivers without more specialized methods"
before spi phy patch and rework so that functions are no more inlined and available
from tpm_tis_core.

Best Regards
Christophe

Christophe Ricard (12):
  tpm: Add include guards in tpm.h
  tpm: tpm_tis: Share common data between phys
  tpm: tpm_tis: Rename priv_data structure tpm_tis_data
  tpm_tis: Introduce intermediate layer for TPM access
  tpm_tis: Extend low-level interface to support proper return codes
  tpm: Manage itpm workaround with tis specific data_expect bit
  tpm: tpm_tis: Add post_probe phy handler
  devicetree: Add infineon to vendor-prefix.txt
  devicetree: Add Trusted Computing Group to vendor-prefix.txt
  tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant
    phy
  tpm: Use read/write_bytes for drivers without more specialized methods
  tpm/tpm_tis_spi: Add support for spi phy

 .../bindings/security/tpm/tpm_tis_spi.txt          |  24 +
 .../devicetree/bindings/vendor-prefixes.txt        |   2 +
 drivers/char/tpm/Kconfig                           |  19 +
 drivers/char/tpm/Makefile                          |   2 +
 drivers/char/tpm/tpm.h                             |   5 +
 drivers/char/tpm/tpm_tis.c                         | 835 +++-----------------
 drivers/char/tpm/tpm_tis_core.c                    | 843 +++++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h                    | 172 +++++
 drivers/char/tpm/tpm_tis_spi.c                     | 251 ++++++
 9 files changed, 1411 insertions(+), 742 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
 create mode 100644 drivers/char/tpm/tpm_tis_core.c
 create mode 100644 drivers/char/tpm/tpm_tis_core.h
 create mode 100644 drivers/char/tpm/tpm_tis_spi.c

-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
