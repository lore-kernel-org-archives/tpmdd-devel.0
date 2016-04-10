From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/10] Rework of tpm_tis to share common logic
	accross phy's (lpc/spi/-i2c-).
Date: Sun, 10 Apr 2016 23:22:56 +0200
Message-ID: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
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

Best Regards
Christophe  

Christophe Ricard (10):
  tpm_tis: Introduce intermediate layer for TPM access
  tpm_tis: Extend low-level interface to support proper return codes
  tpm: Use read/write_bytes for drivers without more specialized methods
  tpm: Manage itpm workaround with tis specific data_expect bit
  tpm: tpm_tis: Add post_probe phy handler
  tpm: Add include guards in tpm.h
  devicetree: Add infineon to vendor-prefix.txt
  devicetree: Add Trusted Computing Group to vendor-prefix.txt
  tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant
    phy
  tpm/tpm_tis_spi: Add support for spi phy

 .../bindings/security/tpm/tpm_tis_spi.txt          |  28 +
 .../devicetree/bindings/vendor-prefixes.txt        |   2 +
 drivers/char/tpm/Kconfig                           |  19 +
 drivers/char/tpm/Makefile                          |   3 +-
 drivers/char/tpm/tpm.h                             |  66 ++
 drivers/char/tpm/tpm_tis.c                         | 831 +++------------------
 drivers/char/tpm/tpm_tis_core.c                    | 782 +++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h                    | 122 +++
 drivers/char/tpm/tpm_tis_spi.c                     | 259 +++++++
 include/linux/tpm.h                                |  11 +
 10 files changed, 1405 insertions(+), 718 deletions(-)
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
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
