From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH 0/2] Add session isolation and context saving
 to the space manager
Date: Wed, 18 Jan 2017 10:08:17 -0500
Message-ID: <1484752097.2717.14.camel@HansenPartnership.com>
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
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

As requested, the first patch adds isolation and the second does
context switching.  I've also removed the flush emulation which changed
transient object accounting from lazy to strict.  Note that session
tracking has to be strict because the TPM needs to manage these closely
to avoid running out of global session numbers.

James

---

James Bottomley (2):
  tpm2: add session handle isolation to tpm spaces
  tpm2: context save and restore space managed sessions

 drivers/char/tpm/tpm-chip.c   |   6 +
 drivers/char/tpm/tpm.h        |   3 +
 drivers/char/tpm/tpm2-space.c | 377 ++++++++++++++++++++++++++++++++++--------
 drivers/char/tpm/tpms-dev.c   |   8 +
 4 files changed, 325 insertions(+), 69 deletions(-)

-- 
2.6.6


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
