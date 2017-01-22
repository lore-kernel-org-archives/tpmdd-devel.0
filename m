From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC v4 0/5] RFC: in-kernel resource manager
Date: Mon, 23 Jan 2017 01:50:29 +0200
Message-ID: <20170122235029.sewyaggzhxh2kl4h@intel.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 01:44:28AM +0200, Jarkko Sakkinen wrote:
> This patch set adds support for TPM spaces that provide a context
> for isolating and swapping transient objects. The content does
> not yet include support for policy and HMAC sessions.
> 
> There's a test script for trying out TPM spaces in
> 
>   git://git.infradead.org/users/jjs/tpm2-scripts.git
> 
> A simple smoke test can be run by
> 
>   sudo python -m unittest -v tpm2_smoke.SpaceTest   
> 
> v2:
> Changed to James' proposal of API. I did not make any other changes
> except split core TPM space code its own patch because I want to find
> consensus on the API before polishing the corners. Thus, this version
> also carries the RFC tag. I have not yet locked in my standpoint whether
> ioctl or a device file is a better deal.
> 
> v3:
> - Check TPM return code in tpm_map_response.
> - Reference tracking for /dev/tpms0.
> - clear_bit(is_open) was removed from tpm-dev.c. Added it back.
> - Use response length as the buffer size limit in tpm2_commit_space.
> - This version now passes again my smoke tests.
> 
> v4:
> - Lots of small bug fixes and clean ups.
> - Quirk for TPM2_CC_FlushHandle

Thought that this would be a good checkpoint as there was this nasty
issue with flushing and there's been a bunch of improvements to these
commits.

Now there should be more reusable code for sessions.

/Jarkko

> James Bottomley (2):
>   tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
>   tpm2: expose spaces via a device link /dev/tpms<n>
> 
> Jarkko Sakkinen (3):
>   tpm: validate TPM 2.0 commands
>   tpm: export tpm2_flush_context_cmd
>   tpm: infrastructure for TPM spaces
> 
>  drivers/char/tpm/Makefile         |   2 +-
>  drivers/char/tpm/tpm-chip.c       |  78 ++++++++-
>  drivers/char/tpm/tpm-dev-common.c | 145 ++++++++++++++++
>  drivers/char/tpm/tpm-dev.c        | 140 ++--------------
>  drivers/char/tpm/tpm-dev.h        |  27 +++
>  drivers/char/tpm/tpm-interface.c  | 113 +++++++++----
>  drivers/char/tpm/tpm-sysfs.c      |   2 +-
>  drivers/char/tpm/tpm.h            |  57 ++++++-
>  drivers/char/tpm/tpm2-cmd.c       | 150 ++++++++++++-----
>  drivers/char/tpm/tpm2-space.c     | 336 ++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpms-dev.c       |  65 ++++++++
>  11 files changed, 903 insertions(+), 212 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-dev-common.c
>  create mode 100644 drivers/char/tpm/tpm-dev.h
>  create mode 100644 drivers/char/tpm/tpm2-space.c
>  create mode 100644 drivers/char/tpm/tpms-dev.c
> 
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
