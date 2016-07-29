From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v4 0/2] tpm: add driver for cr50 on SPI
Date: Thu, 28 Jul 2016 18:55:12 -0700
Message-ID: <1469757314-116169-1-git-send-email-apronin@chromium.org>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset adds support for H1 Secure Microcontroller running
Cr50 firmware. It implements several functions, including TPM-like
functionality, and communicates over SPI using the FIFO protocol
described in the PTP Spec, section 6.
H1 is a proprietary chip that the Chrome OS team is investigating
for inclusion in future Chromebooks.

Depends on the following patchset:
 - tpm_tis_core: add optional max xfer size check

v2: Removed driver-specific sysfs attributes.
    Compatible id changed to cr50 from cr50_spi.
    Updated descriptions of the supported device/interface.

v3: Fixed potential race-condition with last_access_jiffies.
    Started using tx_buf/rx_buf in cr50_spi_phy to avoid
    potential problems with DMA.
    Removed DT properties for fw timing parameters.
    Fixed style.

v4: Fixed cacheline alignment for xfer buffers.

Andrey Pronin (2):
  tpm: devicetree: document properties for cr50
  tpm: add driver for cr50 on SPI

 .../devicetree/bindings/security/tpm/cr50_spi.txt  |  21 ++
 drivers/char/tpm/Kconfig                           |   9 +
 drivers/char/tpm/Makefile                          |   1 +
 drivers/char/tpm/cr50_spi.c                        | 350 +++++++++++++++++++++
 4 files changed, 381 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
 create mode 100644 drivers/char/tpm/cr50_spi.c

-- 
2.6.6


------------------------------------------------------------------------------
