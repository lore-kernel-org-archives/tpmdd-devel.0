From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [GIT PULL] tpmdd fixes for 4.12
Date: Tue, 25 Apr 2017 00:39:28 +0300
Message-ID: <20170424213928.ndlcro6w4xhuxcey@intel.com>
References: <20170424213710.qrc5za4tigjdqspi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170424213710.qrc5za4tigjdqspi@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 25, 2017 at 12:37:10AM +0300, Jarkko Sakkinen wrote:
> Hi
> 
> Here are fixes for the 4.12 release. In addition there is an update to
> the tpm_tis driver to use common callbacks for requesting and
> relinquishing locality as they were with locality support for tpm_crb.
> Now the logic flow for both driver is driven in tpm_transmit().

Whoops, language check.

What I meant to say was that that common calllbacks were introduced with
the locality support for tpm_crb and the flow for both drivers is
implemented into tpm_transmit().

/Jarkko

> 
> /Jarkko
> 
> The following changes since commit f65cc104c498ad820efb13e3a24fe36af872f17a:
> 
>   Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next (2017-04-19 22:00:15 +1000)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170425
> 
> for you to fetch changes up to 8979b02aaf1d6de8d52cc143aa4da961ed32e5a2:
> 
>   tpm: Fix reference count to main device (2017-04-25 00:27:18 +0300)
> 
> ----------------------------------------------------------------
> tpmdd fixes for Linux 4.12
> 
> ----------------------------------------------------------------
> Jarkko Sakkinen (1):
>       tpm_crb: remove a cruft constant
> 
> Jerry Snitselaar (1):
>       tpm_tis: convert to using locality callbacks
> 
> Petr Vandrovec (1):
>       tpm: fix handling of the TPM 2.0 event logs
> 
> Stefan Berger (1):
>       tpm: Fix reference count to main device
> 
>  drivers/char/tpm/tpm-chip.c      |  5 +++--
>  drivers/char/tpm/tpm2_eventlog.c | 14 ++++++++++----
>  drivers/char/tpm/tpm_crb.c       |  3 +--
>  drivers/char/tpm/tpm_tis_core.c  | 34 ++++++++--------------------------
>  include/acpi/actbl2.h            |  2 --
>  5 files changed, 22 insertions(+), 36 deletions(-)
