From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v4 0/4] tpm/tpm_crb: implement power management.
Date: Sat,  8 Oct 2016 14:59:35 +0300
Message-ID: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Te overall platform ability to enter a low power state is also
conditioned on the ability of a tpm device to go to idle state.
This series should provide this feature.

Unfortunately, there is a HW bug on Intel PTT devices on Skylake,
Kabylake, and Broxton devices, where certain registers lost retention
during TPM idle state. Hence this implementation takes this into
consideration and implement the feature based only on access to
registers that retain their state. This still conforms to the spec
and should be correct also on non Intle devices.

V2: Utilize runtime_pm for driving tpm crb idle states.
V3. fix lower case corruption in the first patch
V4. Fix unbalanced runtime pm get and put

Tomas Winkler (4):
  tpm/tpm_crb: implement tpm crb idle state
  tmp/tpm_crb: fix Intel PTT hw bug during idle state
  tpm/tpm_crb: open code the crb_init into acpi_add
  tmp/tpm_crb: implement runtime pm for tpm_crb

 drivers/char/tpm/tpm-interface.c |   5 ++
 drivers/char/tpm/tpm_crb.c       | 166 +++++++++++++++++++++++++++++++++------
 2 files changed, 147 insertions(+), 24 deletions(-)

-- 
2.7.4
