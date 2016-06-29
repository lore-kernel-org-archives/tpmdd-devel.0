From: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2 v3] add TPM 2.0 support for i2c driver
Date: Wed, 29 Jun 2016 07:28:11 +0300
Message-ID: <1467174493-4190-1-git-send-email-andrew.zamansky@nuvoton.com>
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


Jason Gunthorpe (2):
  tpm: Factor out common startup code
  tpm: Add TPM 2.0 support to the Nuvoton i2c driver (NPCT6xx family)
Andrew Zamansky (1)
  tpm: Add TPM 2.0 support to the Nuvoton i2c driver (NPCT6xx family)

 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
 drivers/char/tpm/st33zp24/st33zp24.c               |  4 +-
 drivers/char/tpm/tpm-chip.c                        |  9 +++++
 drivers/char/tpm/tpm-interface.c                   | 27 +++++++++++++
 drivers/char/tpm/tpm.h                             |  4 +-
 drivers/char/tpm/tpm2-cmd.c                        | 46 ++++++++++++++++++++--
 drivers/char/tpm/tpm_crb.c                         | 10 +----
 drivers/char/tpm/tpm_i2c_atmel.c                   |  6 +--
 drivers/char/tpm/tpm_i2c_infineon.c                |  4 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c                 | 35 ++++++++++------
 drivers/char/tpm/tpm_tis_core.c                    | 24 +----------
 drivers/char/tpm/tpm_vtpm_proxy.c                  |  9 +----
 include/linux/tpm.h                                |  5 +++
 13 files changed, 115 insertions(+), 69 deletions(-)

-- 
1.9.1


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
