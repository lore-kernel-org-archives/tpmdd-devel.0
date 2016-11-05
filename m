From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/3] tpm, tpm_vtpm_proxy: add kdoc comments for
 VTPM_PROXY_IOC_NEW_DEV
Date: Fri, 4 Nov 2016 21:00:34 -0600
Message-ID: <20161105030034.6xpd2u7rp5d6d76i@intel.com>
References: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
 <20161103235752.19256-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161103235752.19256-2-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 03, 2016 at 05:57:50PM -0600, Jarkko Sakkinen wrote:
> Added kdoc comments for VTPM_PROXY_IOC_NEW_DEV so that these can be
> imported to the kernel documentation written with rst markup and
> generated with Sphinx.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Stefan, is this OK? Are you willing to give Reviewed-by?

/Jarkko

> ---
>  drivers/char/tpm/tpm_vtpm_proxy.c | 72 +++++++++++++++++++++++++--------------
>  include/uapi/linux/vtpm_proxy.h   | 23 ++++++++++---
>  2 files changed, 65 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> index 9a94033..3d6f6ca 100644
> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2015, 2016 IBM Corporation
> + * Copyright (C) 2016 Intel Corporation
>   *
>   * Author: Stefan Berger <stefanb@us.ibm.com>
>   *
> @@ -524,6 +525,50 @@ static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
>   * Code related to the control device /dev/vtpmx
>   */
>  
> +/**
> + * vtpmx_ioc_new_dev - handler for the %VTPM_PROXY_IOC_NEW_DEV ioctl
> + * @file:	/dev/vtpmx
> + * @ioctl:	the ioctl number
> + * @arg:	pointer to the struct vtpmx_proxy_new_dev
> + *
> + * Creates an anonymous file that is used by the process acting as a TPM to
> + * communicate with the client processes. The function will also add a new TPM
> + * device through which data is proxied to this TPM acting process. The caller
> + * will be provided with a file descriptor to communicate with the clients and
> + * major and minor numbers for the TPM device.
> + */
> +static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
> +			      unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	struct vtpm_proxy_new_dev __user *vtpm_new_dev_p;
> +	struct vtpm_proxy_new_dev vtpm_new_dev;
> +	struct file *vtpm_file;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	vtpm_new_dev_p = argp;
> +
> +	if (copy_from_user(&vtpm_new_dev, vtpm_new_dev_p,
> +			   sizeof(vtpm_new_dev)))
> +		return -EFAULT;
> +
> +	vtpm_file = vtpm_proxy_create_device(&vtpm_new_dev);
> +	if (IS_ERR(vtpm_file))
> +		return PTR_ERR(vtpm_file);
> +
> +	if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
> +			 sizeof(vtpm_new_dev))) {
> +		put_unused_fd(vtpm_new_dev.fd);
> +		fput(vtpm_file);
> +		return -EFAULT;
> +	}
> +
> +	fd_install(vtpm_new_dev.fd, vtpm_file);
> +	return 0;
> +}
> +
>  /*
>   * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
>   *
> @@ -531,34 +576,11 @@ static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
>   *      Returns 0 on success, a negative error code otherwise.
>   */
>  static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
> -				   unsigned long arg)
> +			     unsigned long arg)
>  {
> -	void __user *argp = (void __user *)arg;
> -	struct vtpm_proxy_new_dev __user *vtpm_new_dev_p;
> -	struct vtpm_proxy_new_dev vtpm_new_dev;
> -	struct file *file;
> -
>  	switch (ioctl) {
>  	case VTPM_PROXY_IOC_NEW_DEV:
> -		if (!capable(CAP_SYS_ADMIN))
> -			return -EPERM;
> -		vtpm_new_dev_p = argp;
> -		if (copy_from_user(&vtpm_new_dev, vtpm_new_dev_p,
> -				   sizeof(vtpm_new_dev)))
> -			return -EFAULT;
> -		file = vtpm_proxy_create_device(&vtpm_new_dev);
> -		if (IS_ERR(file))
> -			return PTR_ERR(file);
> -		if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
> -				 sizeof(vtpm_new_dev))) {
> -			put_unused_fd(vtpm_new_dev.fd);
> -			fput(file);
> -			return -EFAULT;
> -		}
> -
> -		fd_install(vtpm_new_dev.fd, file);
> -		return 0;
> -
> +		return vtpmx_ioc_new_dev(f, ioctl, arg);
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
> index 41e8e22..a69e991 100644
> --- a/include/uapi/linux/vtpm_proxy.h
> +++ b/include/uapi/linux/vtpm_proxy.h
> @@ -1,6 +1,7 @@
>  /*
>   * Definitions for the VTPM proxy driver
>   * Copyright (c) 2015, 2016, IBM Corporation
> + * Copyright (C) 2016 Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -18,8 +19,23 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  
> -/* ioctls */
> +/**
> + * enum vtpm_proxy_flags - flags for the proxy TPM
> + * @VTPM_PROXY_FLAG_TPM2:	the proxy TPM uses TPM 2.0 protocol
> + */
> +enum vtpm_proxy_flags {
> +	VTPM_PROXY_FLAG_TPM2	= 1,
> +};
>  
> +/**
> + * struct vtpm_proxy_new_dev - parameter structure for the
> + *                             %VTPM_PROXY_IOC_NEW_DEV ioctl
> + * @flags:	flags for the proxy TPM
> + * @tpm_num:	index of the TPM device
> + * @fd:		the file descriptor used by the proxy TPM
> + * @major:	the major number of the TPM device
> + * @minor:	the minor number of the TPM device
> + */
>  struct vtpm_proxy_new_dev {
>  	__u32 flags;         /* input */
>  	__u32 tpm_num;       /* output */
> @@ -28,9 +44,6 @@ struct vtpm_proxy_new_dev {
>  	__u32 minor;         /* output */
>  };
>  
> -/* above flags */
> -#define VTPM_PROXY_FLAG_TPM2  1  /* emulator is TPM 2 */
> -
> -#define VTPM_PROXY_IOC_NEW_DEV   _IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
> +#define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
>  
>  #endif /* _UAPI_LINUX_VTPM_PROXY_H */
> -- 
> 2.9.3
> 
