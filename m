From: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] add irq validity check in tpm_i2c_nuvoton
	driver
Date: Wed, 29 Jun 2016 12:58:47 +0300
Message-ID: <1467194329-5543-1-git-send-email-andrew.zamansky@nuvoton.com>
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
Cc: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

*** BLURB HERE ***

Christophe Ricard (1):
  tpm: drop 'irq' from struct tpm_vendor_specific

andrew zamansky (1):
  add irq validity check in tpm_i2c_nuvoton driver

 drivers/char/tpm/st33zp24/st33zp24.c | 23 ++++++++---------------
 drivers/char/tpm/st33zp24/st33zp24.h | 10 ++++++++++
 drivers/char/tpm/tpm-interface.c     |  4 ++--
 drivers/char/tpm/tpm.h               |  3 +--
 drivers/char/tpm/tpm_i2c_atmel.c     |  1 -
 drivers/char/tpm/tpm_i2c_infineon.c  |  3 ---
 drivers/char/tpm/tpm_i2c_nuvoton.c   | 30 ++++++++++++++++++------------
 drivers/char/tpm/tpm_tis.c           | 30 +++++++++++++++++-------------
 drivers/char/tpm/xen-tpmfront.c      |  7 ++++---
 9 files changed, 60 insertions(+), 51 deletions(-)

-- 
1.9.1


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
