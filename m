From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v5 0/2] enhance TPM 2.0 extend function to support multiple PCR banks
Date: Thu, 19 Jan 2017 04:16:13 -0500
Message-ID: <1484817375-22864-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

IMA extends its hash measurements in the TPM PCRs, based on policy.
The existing in-kernel TPM extend function extends only the SHA1
PCR bank. TPM 2.0 defines multiple PCR banks, to support different
hash algorithms. The TCG TPM 2.0 Specification[1] recommends
extending all active PCR banks to prevent malicious users from
setting unused PCR banks with fake measurements and quoting them.
This patch set adds support for extending all active PCR banks,
as recommended.

The first patch implements the TPM 2.0 capability to retrieve
the list of active PCR banks.

The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
interface to support extending multiple PCR banks. The existing
tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
extend all active PCR banks with differing digest sizes for TPM 2.0,
the SHA1 digest is padded with 0's as needed.

[1] TPM 2.0 Specification referred here is "TCG PC Client Specific
Platform Firmware Profile for TPM 2.0"

Changelog v5:
- Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
 - Included Jarkko's feedbacks
   - Moved variable declaration to start of function in
   tpm_pcr_extend()


Changelog v4:
- Updated cover letter as per Mimi's feedback.
- Rebased to Jarkko's latest master branch (4064b6b tpm_tis: use
  default timeout value if chip reports it as zero)
- Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
 - Included Jarkko's feedbacks
   - Moved call to tpm2_get_pcr_allocation to Patch 2
   - Renamed struct tpm2_tpms_pcr_selection to struct tpm2_pcr_selection 
   and moved the struct to before tpm2_get_pcr_allocation()
   - Fixed code formatting
- Patch "tpm: enchance TPM 2.0 PCR extend to support multiple banks"
 - Included Jarkkos' feedbacks
   - Updated commit msg to mention dependency on CRYPTO_HASH_INFO
   - Renamed struct tpmt_hash to struct tpm2_digest 
   - Removed struct tpml_digest_values, tpm2_pcr_extend() now accepts
   count and digests list as two separate arguments. Added check for
   count of hashes passed.
 - Cleaned up struct tpm2_pcr_extend_in as not required anymore with
 use of tpm_buf
 - Moved struct tpm2_null_auth_area just before tpm2_pcr_extend() as
 it is the only function using it for now.
 - Fixed code formatting

Changelog v3:
- Rebased to the Jarkko's latest master branch (8e25809 tpm:
  Do not print an error message when doing TPM auto startup)
- Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
  - Included Jarkko's feedbacks
     - Removed getcap_in, getcap_out and used tpm_buf for getting
     capability.
     - Used ARRAY_SIZE in place of TPM_MAX_PCR_BANKS and included
     other feedbacks.
- Patch "tpm: enhance TPM 2.0 PCR extend to support multiple banks"
     - Fixed kbuild errors
       - Fixed buf.data uninitialized warning.
       - Added TCG_TPM dependency on CONFIG_CRYPTO_HASH_INFO in Kconfig.

Changelog v2:

- Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
  - defined structs definition in tpm2-cmd.c.
  - no_of_active_banks field is removed. Instead, constant
  TPM2_MAX_PCR_BANKS is defined.
  - renamed tpm2_get_active_pcr_banks() to tpm2_get_pcr_allocation()
  - removed generic function tpm2_get_capability().

- Patch "tpm: enchance TPM 2.0 PCR extend to support multiple banks"
 - Removed tpm2.h, and defined structs common for extend and event log
  in tpm_eventlog.h
 - uses tpm_buf in tpm2_pcr_extend().

Nayna Jain (2):
  tpm: implement TPM 2.0 capability to get active PCR banks
  tpm: enhance TPM 2.0 PCR extend to support multiple banks

 drivers/char/tpm/Kconfig         |   1 +
 drivers/char/tpm/tpm-interface.c |  15 +++-
 drivers/char/tpm/tpm.h           |   7 +-
 drivers/char/tpm/tpm2-cmd.c      | 148 ++++++++++++++++++++++++++++-----------
 drivers/char/tpm/tpm_eventlog.h  |   7 ++
 5 files changed, 134 insertions(+), 44 deletions(-)

-- 
2.5.0
