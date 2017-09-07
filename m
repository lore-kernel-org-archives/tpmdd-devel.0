From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 0/4] additional TPM performance improvements
Date: Thu, 7 Sep 2017 19:18:58 +0300
Message-ID: <20170907161858.t3ndlrn2kcask6jc@linux.intel.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 06, 2017 at 08:56:35AM -0400, Nayna Jain wrote:
> After further discussions with the Device Driver working group (ddwg),
> the following changes were made: 
> 
> * Check for burstcount at least once to confirm the TPM is ready to accept
> the data. Similarly, query for the TPM Expect status as sanity check at
> the end.
> 
> * Make the sleep for status check during send() in the loop less than
> 5msec.
> 
> * Make the sleep in the loop while querying for burstcount less than
> 5msec.
> 
> Below is the list of patches along with the performance improvements
> seen with a TPM 1.2 with an 8 byte burstcount for 1000 extends: 
> 
> Patch                                        |Improvement(time in sec)
> 
> tpm: ignore burstcount to improve tpm_tis    | ~41 - ~14
> send() performance.
> 
> tpm: define __wait_for_tpm_stat to specify   | ~14 - ~10
> variable polling sleep time
> 
> tpm: reduce tpm_msleep() time in             | ~10 - ~9
> get_burstcount()
> 
> tpm: modify tpm_msleep() function to have    | ~9 - ~8
> max range
> 
> Changelog v2:
> 
> * Add module parameter to handle ignoring of burst count during
> tpm tis send() operation.
> * Add improvements over sleep time to reduce delays.
> 
> Nayna Jain (4):
>   tpm: ignore burstcount to improve tpm_tis send() performance.
>   tpm: define __wait_for_tpm_stat to specify variable polling sleep time
>   tpm: reduce tpm_msleep() time in get_burstcount()
>   tpm: use tpm_msleep() value as max delay
> 
>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++
>  drivers/char/tpm/tpm-interface.c                | 15 ++++++++--
>  drivers/char/tpm/tpm.h                          |  7 +++--
>  drivers/char/tpm/tpm_tis_core.c                 | 37 +++++++++++++++++++------
>  4 files changed, 53 insertions(+), 14 deletions(-)
> 
> -- 
> 2.13.3
> 

I'll look into this after next week.

/Jarkko
