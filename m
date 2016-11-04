From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 0/2] Generalize tpm2_get_tpm_pt to tpm2_get_cap
Date: Fri, 4 Nov 2016 01:28:28 -0600
Message-ID: <20161104072828.5mcmfs3nu73mxee4@intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Nayna,

I've already sent these earlier this month as we had this discussion. 
Please look up your emails. I can apply these if they look good for
you. Please review them.

/Jarkko

On Sun, Oct 09, 2016 at 01:14:14PM +0300, Jarkko Sakkinen wrote:
> We need to generalize tpm2_get_tpm_pt to tpm2_get_cap in order to it be
> suitable for grabbing handles, PCR banks and so forth.
> 
> Jarkko Sakkinen (2):
>   tpm: move TPM 2.0 command and response constants to tpm2-cmd.c
>   tpm: refactor tpm2_get_tpm_pt to tpm2_getcap_cmd
> 
>  drivers/char/tpm/tpm.h          |  48 ++----------------
>  drivers/char/tpm/tpm2-cmd.c     | 106 +++++++++++++++++++++++++++-------------
>  drivers/char/tpm/tpm_tis_core.c |   3 +-
>  3 files changed, 80 insertions(+), 77 deletions(-)
> 
> -- 
> 2.7.4
> 
