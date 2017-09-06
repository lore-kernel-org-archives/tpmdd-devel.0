From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm-dev-common: Reject too short writes
Date: Wed, 6 Sep 2017 15:42:33 +0300
Message-ID: <20170906124233.qquzut5lyuri2buu@linux.intel.com>
References: <20170904173642.5988-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170904173642.5988-1-Alexander.Steffen@infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 04, 2017 at 07:36:42PM +0200, Alexander Steffen wrote:
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
> 
>  drivers/char/tpm/tpm-dev-common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index 610638a..ac25574 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -99,7 +99,8 @@ ssize_t tpm_common_write(struct file *file, const char __user *buf,
>  	if (atomic_read(&priv->data_pending) != 0)
>  		return -EBUSY;
>  
> -	if (in_size > TPM_BUFSIZE)
> +	if (in_size > sizeof(priv->data_buffer) || in_size < 6 ||
> +	    in_size < be32_to_cpu(*((__be32 *) (buf + 2))))
>  		return -E2BIG;
>  
>  	mutex_lock(&priv->buffer_mutex);
> -- 
> 2.7.4
> 

How did you test this change after you implemented it?

Just thinking what to add to https://github.com/jsakkine-intel/tpm2-scripts

/Jarkko
