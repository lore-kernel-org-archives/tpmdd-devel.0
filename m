From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND v2 0/3] tpm2-cmd: Improve self test execution
Date: Sat, 2 Sep 2017 13:16:44 +0300
Message-ID: <20170902101644.x254cv2jmlw3jruu@linux.intel.com>
References: <20170831171858.13252-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170831171858.13252-1-Alexander.Steffen@infineon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 31, 2017 at 07:18:55PM +0200, Alexander Steffen wrote:
> The self test logic for TPM 2.0 was probably based on the implementation
> for TPM 1.2, but did not correctly take into account some TPM 2.0 specifics.
> This patch series fixes those issues.
> 
> v2:
> - Moved implementation description from comment to commit message.
> 
> Alexander Steffen (3):
>   tpm2-cmd: Trigger only missing self tests
>   tpm2-cmd: Use dynamic delay to wait for self test result
>   tpm2-cmd: React correctly to RC_TESTING from self tests
> 
>  drivers/char/tpm/tpm2-cmd.c | 69 +++++++++++++--------------------------------
>  1 file changed, 20 insertions(+), 49 deletions(-)
> 
> -- 
> 2.7.4
> 

Great, just have to test these.

/Jarkko
