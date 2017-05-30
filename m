From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm, tpmrm: Mark tpmrm_write as static
Date: Tue, 30 May 2017 07:46:20 +0300
Message-ID: <20170530044501.pckpqfkzp3h54bqm@intel.com>
References: <20170525054305.15721-1-peterhuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170525054305.15721-1-peterhuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 07:43:05AM +0200, Peter Huewe wrote:
> sparse complains that tpmrm_write can be made static, and since it is
> right we make it static.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpmrm-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
> index c636e7f..1a0e97a 100644
> --- a/drivers/char/tpm/tpmrm-dev.c
> +++ b/drivers/char/tpm/tpmrm-dev.c
> @@ -45,7 +45,7 @@ static int tpmrm_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -ssize_t tpmrm_write(struct file *file, const char __user *buf,
> +static ssize_t tpmrm_write(struct file *file, const char __user *buf,
>  		   size_t size, loff_t *off)
>  {
>  	struct file_priv *fpriv = file->private_data;
> -- 
> 2.10.2
> 
