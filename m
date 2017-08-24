From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND 0/3] Export broken TPMs to user space
Date: Thu, 24 Aug 2017 10:37:11 +0200
Message-ID: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

TPMs may break sometimes, in which case the kernel currently refuses to
talk to them at all. As far as the kernel is concerned, this is okay,
since it cannot fix them anyway. But there might be user space
applications that can be used for further diagnosis or even to fix the
underlying problem. In order to allow this, a broken device should be
exported to user space, as long as we can at least talk to it, that is,
as long as it provides well-formed answers to commands, even though it
might return error codes that we do not expect.

Alexander Steffen (3):
  tpm-chip: Move idr_replace calls to appropriate places
  tpm-chip: Return TPM error codes from auto_startup functions
  tpm-chip: Export TPM device to user space even when startup failed

 drivers/char/tpm/tpm-chip.c      | 29 +++++++++++++++++------------
 drivers/char/tpm/tpm-interface.c |  6 ++----
 drivers/char/tpm/tpm2-cmd.c      |  5 ++---
 3 files changed, 21 insertions(+), 19 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
