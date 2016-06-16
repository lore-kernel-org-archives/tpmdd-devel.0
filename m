From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 4/5] tpm: Allow TPM chip drivers to override reported
 command durations
Date: Thu, 16 Jun 2016 22:26:41 +0200
Message-ID: <20160616202641.GC1414@intel.com>
References: <1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
 <1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
 <1465610107-87762-5-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465610107-87762-5-git-send-email-eswierk@skyportsystems.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ed Swierk <eswierk@skyportsystems.com>
Cc: tpmdd-devel@lists.sourceforge.net, stefanb@us.ibm.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 10, 2016 at 06:55:06PM -0700, Ed Swierk wrote:
> Some TPM chips report bogus command durations in their capabilities,
> just as others report incorrect timeouts. Rework tpm_get_timeouts() to
> allow chip drivers to override either via a single callback. Also
> clean up handling of TPMs that report milliseconds instead of
> microseconds.
> 
> Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>

Again, LGTM but have to test :)

> ---
>  drivers/char/tpm/tpm-interface.c | 139 +++++++++++++++++++++------------------
>  drivers/char/tpm/tpm_tis.c       |  35 +++-------
>  include/linux/tpm.h              |   3 +-
>  3 files changed, 85 insertions(+), 92 deletions(-)

/Jarkko
