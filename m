From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 1/2] tpm-dev-common: Reject too short writes
Date: Fri, 25 Aug 2017 19:54:51 +0300
Message-ID: <20170825165451.b7lv7t5w3nhbz7da@linux.intel.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
 <20170824083545.13280-2-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824083545.13280-2-Alexander.Steffen@infineon.com>
Sender: stable-owner@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:35:44AM +0200, Alexander Steffen wrote:
> tpm_common_write() in tpm-dev-common.c discards the information how much
> data has actually been written to the buffer. Instead, all other code has
> to rely on the commandSize field in the TPM command header to figure out
> how many valid bytes are supposed to be in the buffer.
> 
> But there is nothing that enforces the value in the header to match the
> actual buffer contents. So by claiming a larger size in the header than
> has been written, stale buffer contents are sent to the TPM. With this
> commit, this problem is detected and rejected accordingly.
> 
> This should have been fixed with CVE-2011-1161 long ago, but apparently
> a correct version of that patch never made it into the kernel.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> ---
>  drivers/char/tpm/tpm-dev-common.c | 2 +-
>  drivers/char/tpm/tpm-interface.c  | 9 ++++++---
>  drivers/char/tpm/tpm.h            | 3 ++-
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index 610638a..c39b581 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -119,7 +119,7 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
>  		return -EPIPE;
>  	}
>  	out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
> -				sizeof(priv->data_buffer), 0);
> +				sizeof(priv->data_buffer), in_size, 0);

Why you couldn't just

unsigned int bufsiz;

/* ... */

bufsiz = sizeof(priv->data_buffer);
if (in_size < bufsiz)
	bufsiz = in_size;

out_size = tpm_transmit(priv->chip, space, priv->data_buffer, bufsiz, 0);

/Jarkko
