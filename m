From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm-dev-common: Reject too short writes
Date: Sat, 9 Sep 2017 00:37:39 +0300
Message-ID: <20170908213739.k7ifm2isz4dciaaa@linux.intel.com>
References: <20170908152132.8728-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170908152132.8728-1-Alexander.Steffen@infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 08, 2017 at 05:21:32PM +0200, Alexander Steffen wrote:
> tpm_transmit() does not offer an explicit interface to indicate the number
> of valid bytes in the communication buffer. Instead, it relies on the
> commandSize field in the TPM header that is encoded within the buffer.
> Therefore, ensure that a) enough data has been written to the buffer, so
> that the commandSize field is present and b) the commandSize field does not
> announce more data than has been written to the buffer.
> 
> This should have been fixed with CVE-2011-1161 long ago, but apparently
> a correct version of that patch never made it into the kernel.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> ---
> v2:
> - Moved all changes to tpm_common_write in a single patch.
> v3:
> - Access data copied from user space (priv->data_buffer) instead of user
>   space data directly (buf).
> - Changed return code to EINVAL.
> 
>  drivers/char/tpm/tpm-dev-common.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index 610638a..461bf0b 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -110,6 +110,12 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
>  		return -EFAULT;
>  	}
>  
> +	if (in_size < 6 ||
> +	    in_size < be32_to_cpu(*((__be32 *) (priv->data_buffer + 2)))) {
> +		mutex_unlock(&priv->buffer_mutex);
> +		return -EINVAL;
> +	}
> +
>  	/* atomic tpm command send and result receive. We only hold the ops
>  	 * lock during this period so that the tpm can be unregistered even if
>  	 * the char dev is held open.
> -- 
> 2.7.4
> 

I'm not gonna fight about that "in_size < 6" check. I think it is not
needed, I understand your point but still disagree but it is something
where I can live with having it.

I kind of disagree also with allowing messages longer than the command
size but it does not have to be in the scope of this commit and actually
should be a separate discussion if we ever going to do something about
it.

Thanks for the patience!

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
