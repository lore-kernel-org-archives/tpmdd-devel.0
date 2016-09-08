From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/4] Small fixes and cleanups for tpm_crb
Date: Thu, 8 Sep 2016 13:27:59 +0300
Message-ID: <20160908102759.GA4712@intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, tomas.winkler@intel.com
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 10:34:16PM +0300, Jarkko Sakkinen wrote:
> A set of small fixes and clean ups for tpm_crb.

I will apply these fixes tomorrow because they are no brainers
basically. Tomas, I guess you can gives these tested-by since
you've tested runtime PM code on top of these?

> Jarkko Sakkinen (4):
>   tpm_crb: fix crb_req_canceled behavior
>   tpm_crb: remove wmb()'s
>   tpm_crb: refine the naming of constants
>   tpm_crb: fix incorrect values of cmdReady and goIdle bits
> 
>  drivers/char/tpm/tpm_crb.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> -- 
> 2.7.4

/Jarkko
