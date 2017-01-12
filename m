From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v3 0/2] tpm: enhance TPM 2.0 extend function to support multiple PCR banks
Date: Thu, 12 Jan 2017 11:58:08 -0500
Message-ID: <1484240290-4306-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
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

This approach is taken to maintain backwards compatibility for IMA
in order to continue working with both TPM 1.2 and TPM 2.0 without
any changes and still comply with TCG TPM 2.0 Specification[1].

[1] TPM 2.0 Specification referred here is "TCG PC Client Specific
Platform Firmware Profile for TPM 2.0"

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
 drivers/char/tpm/tpm-interface.c |  16 ++++-
 drivers/char/tpm/tpm.h           |   7 ++-
 drivers/char/tpm/tpm2-cmd.c      | 127 ++++++++++++++++++++++++++++++---------
 drivers/char/tpm/tpm_eventlog.h  |  18 ++++++
 5 files changed, 138 insertions(+), 31 deletions(-)

-- 
2.5.0

