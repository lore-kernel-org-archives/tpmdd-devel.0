From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 3/3] tpm: vtpm_proxy: Add ioctl to request locality
 prepended to command
Date: Thu, 4 May 2017 01:37:47 +0300
Message-ID: <20170503223747.zefh76m4youqlgje@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1493384538-27883-4-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493384538-27883-4-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Apr 28, 2017 at 09:02:18AM -0400, Stefan Berger wrote:
> Add an ioctl to request that the locality be prepended to every TPM
> command.

Don't really understand this change. Why locality is prenpended?
Where is the ioctl declaration in this commit?

> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_vtpm_proxy.c | 18 +++++++++++++-----
>  include/uapi/linux/vtpm_proxy.h   |  4 +++-
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> index 48b9818..6c90e02 100644
> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> @@ -52,7 +52,8 @@ struct proxy_dev {
>  };
>  
>  /* all supported flags */
> -#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
> +#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2 | \
> +			       VTPM_PROXY_FLAG_PREPEND_LOCALITY)
>  
>  static struct workqueue_struct *workqueue;
>  
> @@ -77,8 +78,9 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>  				    size_t count, loff_t *off)
>  {
>  	struct proxy_dev *proxy_dev = filp->private_data;
> -	size_t len;
> -	int sig, rc;
> +	size_t len, offset = 0;
> +	int sig, rc = 0;

One line per declaration:

size_t len;
size_t offset = 0;
int sig;
int rc = 0;

> +	uint8_t locality;
>  
>  	sig = wait_event_interruptible(proxy_dev->wq,
>  		proxy_dev->req_len != 0 ||
> @@ -102,7 +104,13 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>  		return -EIO;
>  	}
>  
> -	rc = copy_to_user(buf, proxy_dev->buffer, len);
> +	if (proxy_dev->flags & VTPM_PROXY_FLAG_PREPEND_LOCALITY) {
> +		locality = proxy_dev->chip->locality;
> +		offset = sizeof(locality);
> +		rc = copy_to_user(buf, &locality, offset);
> +	}
> +	if (!rc)
> +		rc = copy_to_user(&buf[offset], proxy_dev->buffer, len);
>  	memset(proxy_dev->buffer, 0, len);
>  	proxy_dev->req_len = 0;
>  
> @@ -114,7 +122,7 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>  	if (rc)
>  		return -EFAULT;
>  
> -	return len;
> +	return offset + len;
>  }
>  
>  /**
> diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
> index 83e64e7..512a29e 100644
> --- a/include/uapi/linux/vtpm_proxy.h
> +++ b/include/uapi/linux/vtpm_proxy.h
> @@ -22,9 +22,11 @@
>  /**
>   * enum vtpm_proxy_flags - flags for the proxy TPM
>   * @VTPM_PROXY_FLAG_TPM2:	the proxy TPM uses TPM 2.0 protocol
> + * @VTPM_PROXY_PREPEND_LOCALITY:locality byte prepended on each command
>   */
>  enum vtpm_proxy_flags {
> -	VTPM_PROXY_FLAG_TPM2	= 1,
> +	VTPM_PROXY_FLAG_TPM2			= 1,
> +	VTPM_PROXY_FLAG_PREPEND_LOCALITY	= 2,
>  };
>  
>  /**
> -- 
> 2.4.3
> 

/Jarkko
