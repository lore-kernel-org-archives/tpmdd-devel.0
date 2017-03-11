From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 0/7] in-kernel resource manager
Date: Sat, 11 Mar 2017 10:55:10 +0200
Message-ID: <20170311085510.ntfdr4v3nirmymjk@intel.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, James.Bottomley@HansenPartnership.com, dhowells@redhat.com, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, philip.b.tricca@intel.com, kai.svahn@intel.com, Kenneth Goldman <kgoldman@us.ibm.com>, monty.wiseman@ge.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 03, 2017 at 05:19:01PM +0200, Jarkko Sakkinen wrote:
> This patch set adds support for TPM spaces that provide an isolated
> execution context for transient objects and HMAC and policy sessions. A
> space is swapped into TPM volatile memory only when it is used and
> swapped out after the use.
> 
> There's a test script for trying out TPM spaces in
> 
>   git://git.infradead.org/users/jjs/tpm2-scripts.git
> 
> A simple smoke test suite can be run by
> 
>   sudo python -m unittest -v tpm2_smoke.SpaceTest   
> 
> v3:
> * Reverted back to /dev/tpmrm0 that was actually James' original
>   proposal. It's the most pragmatic choice as it cannot be mixed
>   with other TPM 2.0 and kernel idioms easily.
> 
> v2:
> * Substitute virtual handle in ContextSave.
> * Substitute virtual handles in GetCapability.
> * Validate that the real response length and the one reported in the
>   header match in tpm_transmit().
> 
> 
> James Bottomley (3):
>   tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
>   tpm: expose spaces via a device link /dev/tpmrm<n>
>   tpm2: add session handle context saving and restoring to the space
>     code
> 
> Jarkko Sakkinen (4):
>   tpm: move length validation to tpm_transmit()
>   tpm: validate TPM 2.0 commands
>   tpm: export tpm2_flush_context_cmd
>   tpm: infrastructure for TPM spaces
> 
>  drivers/char/tpm/Makefile         |   3 +-
>  drivers/char/tpm/tpm-chip.c       |  71 ++++-
>  drivers/char/tpm/tpm-dev-common.c | 148 +++++++++++
>  drivers/char/tpm/tpm-dev.c        | 143 +---------
>  drivers/char/tpm/tpm-dev.h        |  27 ++
>  drivers/char/tpm/tpm-interface.c  | 131 +++++++---
>  drivers/char/tpm/tpm-sysfs.c      |   2 +-
>  drivers/char/tpm/tpm.h            |  49 +++-
>  drivers/char/tpm/tpm2-cmd.c       | 173 +++++++++----
>  drivers/char/tpm/tpm2-space.c     | 532 ++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpmrm-dev.c      |  65 +++++
>  11 files changed, 1123 insertions(+), 221 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-dev-common.c
>  create mode 100644 drivers/char/tpm/tpm-dev.h
>  create mode 100644 drivers/char/tpm/tpm2-space.c
>  create mode 100644 drivers/char/tpm/tpmrm-dev.c
> 
> -- 
> 2.9.3
> 

These commits are now in my master and next branches. Tested-by's are
still most welcome!

/Jarkko
