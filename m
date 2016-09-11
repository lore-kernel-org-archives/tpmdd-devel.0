From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix buffer overflow in /dev/tpm0
Date: Sun, 11 Sep 2016 15:51:42 +0300
Message-ID: <20160911125142.GA20191@intel.com>
References: <1473596340-11376-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473596340-11376-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Sep 11, 2016 at 03:19:00PM +0300, Jarkko Sakkinen wrote:
> tpm_write() does not check whether the buffer has at least enough space
> for the header before passing it to tpm_transmit() so an overflow can
> happen.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This is usable neither as read nor write primitive for an exploit. Still
it makes sense to validate the input here.

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index fd863ff..6a67f7f 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -337,6 +337,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  	u32 count, ordinal;
>  	unsigned long stop;
>  
> +	if (bufsiz < TPM_HEADER_SIZE)
> +		return -EINVAL;
> +
>  	if (bufsiz > TPM_BUFSIZE)
>  		bufsiz = TPM_BUFSIZE;
>  
> -- 
> 2.7.4
> 
