From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 0/2] tpm: add driver for cr50 on SPI
Date: Thu, 14 Jul 2016 19:28:55 -0700
Message-ID: <9A3CFCAE-F2FD-438D-A32B-AD59E0362E71@gmx.de>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 14. Juli 2016 19:20:16 GMT-07:00, schrieb Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>:
>This patchset adds a TCG TPM2.0 PTP FIFO compliant interface for
>Cr50 chip on SPI.
>
>Depends on the following patches by Andrey Pronin
><apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>that add new members to phy_ops in tpm_tis_core:
> - tpm: support driver-specific sysfs attrs in tpm_tis_core
> - tpm_tis_core: add optional max xfer size check
>
>Andrey Pronin (2):
>  tpm: devicetree: document properties for cr50
>  tpm: add driver for cr50 on SPI
>
> .../devicetree/bindings/security/tpm/cr50_spi.txt  |  30 ++
> drivers/char/tpm/Kconfig                           |   9 +
> drivers/char/tpm/Makefile                          |   1 +
>drivers/char/tpm/cr50_spi.c                        | 409
>+++++++++++++++++++++
> 4 files changed, 449 insertions(+)
>create mode 100644
>Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> create mode 100644 drivers/char/tpm/cr50_spi.c


Hi, 
can you explain a bit more about this device? And why it needs a special driver and cannot be handled by tpm_tis_spi if its tcg compliant?

Peter
-- 
Sent from my mobile

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
