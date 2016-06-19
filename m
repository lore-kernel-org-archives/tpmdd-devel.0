From: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] Add TPM 2.0 support to the Nuvoton i2c
	driver
Date: Sun, 19 Jun 2016 11:19:59 +0300
Message-ID: <1466324401-5054-1-git-send-email-andrew.zamansky@nuvoton.com>
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
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Jason Gunthorpe (1):
  tpm: Factor out common startup code
Andrew Zamansky (1)
  tpm: Add TPM 2.0 support to the Nuvoton i2c driver (NPCT6xx family)

 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
 drivers/char/tpm/st33zp24/st33zp24.c               |  4 +--
 drivers/char/tpm/tpm-chip.c                        | 15 ++++++++
 drivers/char/tpm/tpm-interface.c                   | 27 +++++++++++++++
 drivers/char/tpm/tpm.h                             |  2 ++
 drivers/char/tpm/tpm2-cmd.c                        | 40 ++++++++++++++++++++++
 drivers/char/tpm/tpm_crb.c                         | 10 +-----
 drivers/char/tpm/tpm_i2c_atmel.c                   |  6 +---
 drivers/char/tpm/tpm_i2c_infineon.c                |  4 +--
 drivers/char/tpm/tpm_i2c_nuvoton.c                 | 12 +++----
 drivers/char/tpm/tpm_tis.c                         | 24 +------------
 include/linux/tpm.h                                |  6 ++++
 12 files changed, 100 insertions(+), 51 deletions(-)

-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
