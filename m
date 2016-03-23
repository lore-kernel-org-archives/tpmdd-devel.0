From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] Cleanup struct tpm_vendor_specific
Date: Wed, 23 Mar 2016 21:17:15 +0100
Message-ID: <1458764240-24185-1-git-send-email-christophe-h.ricard@st.com>
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

Hi Jarkko, Jason,

Please find in this serie a complete removal of tpm_vendor_specific structure.
It applies on top Jarkko current master branch:
tpm: drop the field 'time_expired' from struct tpm_chip beff92fd1051c234a374ee4a268b1338da7c1d3a

Overall, irq dedicated fields are seen as a dedicated set of chip properties managed by all the
drivers.

priv is a dedicated tpm driver specific data field allowing to store specific driver informations.
dev->driver_data is already set with a chip description.

Finaly, i have renamed tpm_vendor_specific to tpm_protocol_infos as the remaining data are common
to both crb and tis protocols.

Best Regards
Christophe

Christophe Ricard (5):
  tpm: drop 'iobase' from struct tpm_vendor_specific
  tpm: drop list from struct tpm_vendor_specific
  tpm: Move priv field from tpm_vendor_specific to tpm_chip
  tpm: Move irqs field from tpm_vendor_specific to tpm_chip structure
  tpm: Rename tpm_vendor_specific structure to tpm_protocol_infos

 drivers/char/tpm/st33zp24/st33zp24.c |  54 ++++-----
 drivers/char/tpm/tpm-interface.c     |  52 ++++----
 drivers/char/tpm/tpm-sysfs.c         |  20 ++--
 drivers/char/tpm/tpm.h               |  18 ++-
 drivers/char/tpm/tpm2-cmd.c          |   2 +-
 drivers/char/tpm/tpm_atmel.c         |  33 ++++--
 drivers/char/tpm/tpm_atmel.h         |   2 +-
 drivers/char/tpm/tpm_crb.c           |  12 +-
 drivers/char/tpm/tpm_i2c_atmel.c     |  22 ++--
 drivers/char/tpm/tpm_i2c_infineon.c  |  47 ++++----
 drivers/char/tpm/tpm_i2c_nuvoton.c   |  58 ++++-----
 drivers/char/tpm/tpm_nsc.c           |   4 +-
 drivers/char/tpm/tpm_tis.c           | 222 +++++++++++++++++++----------------
 drivers/char/tpm/xen-tpmfront.c      |  10 +-
 14 files changed, 287 insertions(+), 269 deletions(-)

-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
