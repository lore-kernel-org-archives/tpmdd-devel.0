From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [GIT PULL] tpmdd fixes for Linux 4.11
Date: Mon, 20 Feb 2017 13:44:31 +0200
Message-ID: <20170220114431.hjhhpbbcooywf3f5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

Some small scoped but needed fixes for the release.

/Jarkko

The following changes since commit 52176603795c2ab7e9faf6bb94820da1b726aabd:

  KEYS: Use memzero_explicit() for secret data (2017-02-10 12:43:51 +1100)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170220

for you to fetch changes up to 61841be6358c03e864ad4c386c9a102edbba9cb8:

  tpm: declare tpm2_get_pcr_allocation() as static (2017-02-20 13:23:18 +0200)

----------------------------------------------------------------
tpmdd fixes for Linux 4.11

----------------------------------------------------------------
Dmitry Torokhov (1):
      tpm: fix misspelled "facilitate" in module parameter description

Jarkko Sakkinen (1):
      tpm: declare tpm2_get_pcr_allocation() as static

Julia Lawall (1):
      tpm xen: drop unneeded chip variable

Stefan Berger (1):
      tpm: Fix expected number of response bytes of TPM1.2 PCR Extend

Wei Yongjun (1):
      tpm_tis: fix the error handling of init_tis()

 drivers/char/tpm/tpm-interface.c |  4 +-
 drivers/char/tpm/tpm.h           |  1 -
 drivers/char/tpm/tpm2-cmd.c      | 94 +++++++++++++++++++---------------------
 drivers/char/tpm/tpm_tis.c       |  2 +-
 drivers/char/tpm/xen-tpmfront.c  |  2 -
 5 files changed, 48 insertions(+), 55 deletions(-)

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
