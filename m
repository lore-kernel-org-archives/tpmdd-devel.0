From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/2] tpm: enhance TPM 2.0 extend function to
	support multiple PCR banks
Date: Sat,  8 Oct 2016 22:15:55 -0400
Message-ID: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
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
List-Id: tpmdd-devel@lists.sourceforge.net

The existing in-kernel interface for extending a TPM PCR extends
the SHA1 PCR bank. For TPM 1.2, that is the one and only PCR bank
defined. TPM 2.0 adds support for multiple PCR banks, to support
different hash algorithms. The TPM 2.0 Specification[1]
recommends extending all active PCR banks. This patch set enhances
the existing TPM 2.0 extend function and corresponding in-kernel
interface to support extending all active PCR banks.

The first patch implements the TPM 2.0 capability to retrieve
the list of active PCR banks.

The second patch modifies the TPM 2.0 device driver extend function
to support extending multiple PCR banks. The existing in-kernel
interface expects only a SHA1 digest. Hence, to extend all active
PCR banks with differing digest sizes for TPM 2.0, the SHA1 digest
is padded with 0's as needed.

This approach is taken to maintain backwards compatibility for the
existing users (i.e. IMA) in order to continue working with both
TPM 1.2 and TPM 2.0 without any changes and still comply with the
TPM 2.0 Specification[1] requirement of extending all active PCR
banks.

This patch series has a prerequisite(header file tpm2.h) of TPM 2.0
event log patch series.

[1] TPM2.0 Specification referred here is "TCG PC Client Specific
Platform Firmware Profile for TPM 2.0"

Nayna Jain (2):
  tpm: implement TPM 2.0 capability to get active PCR banks
  tpm: enhance TPM 2.0 PCR extend to support multiple banks

 drivers/char/tpm/tpm-chip.c      |   4 ++
 drivers/char/tpm/tpm-interface.c |  17 ++++-
 drivers/char/tpm/tpm.h           |   8 ++-
 drivers/char/tpm/tpm2-cmd.c      | 151 ++++++++++++++++++++++++++++++++-------
 drivers/char/tpm/tpm2.h          |  53 ++++++++++++++
 5 files changed, 205 insertions(+), 28 deletions(-)

-- 
2.5.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
