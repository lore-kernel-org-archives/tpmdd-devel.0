From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 0/2] Update PCR read code
Date: Fri, 23 Jun 2017 15:41:55 +0200
Message-ID: <20170623134157.30399-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set updates tpm2_pcr_read(), to build the PCR read command
buffer with tpm_buf functions, which offer protection against buffer
overflow.

It also removes duplicate code in tpm2_do_selftest(), and replaces it with
a call to tpm2_pcr_read().

The previous version of the patches can be found at the URLs:

https://sourceforge.net/p/tpmdd/mailman/message/35905413/
https://sourceforge.net/p/tpmdd/mailman/message/35905415/

The version number has not been incremented from 3 to 4, since this
is considered as a new patch set, not providing the same functionality
of the set the patches were originally part of.

Changelog

- PCR code changes are applied directly to tpm2_pcr_read()
- removed tpm2_pcr_read_in structure
- modified size of digest array in tpm2_pcr_read_out structure

Roberto Sassu (2):
  tpm: use tpm_buf functions in tpm2_pcr_read()
  tpm: use tpm2_pcr_read() in tpm2_do_selftest()

 drivers/char/tpm/tpm2-cmd.c | 89 +++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 59 deletions(-)

-- 
2.9.3

