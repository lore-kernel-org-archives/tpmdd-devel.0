From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 01/10] tpm: Check received number of bytes against length
 indicator in header
Date: Thu, 12 Jan 2017 16:45:01 +0200
Message-ID: <20170112144501.nj37ecairdp5ev36@intel.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 10, 2017 at 09:18:11AM -0500, Stefan Berger wrote:
> Make sure that we have not received less bytes than what is indicated
> in the header of the TPM response.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

NAK for the whole patch set as it is missing the cover letter.

Also you should pick my validation patch to this patch set and do the
check inside the new function.

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index fecdd3f..9d6f894 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -446,6 +446,8 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
>  		return -EFAULT;
>  
>  	header = cmd;
> +	if (len < be32_to_cpu(header->length))
> +		return -EFAULT;
>  
>  	err = be32_to_cpu(header->return_code);
>  	if (err != 0 && desc)
> -- 
> 2.4.3
> 
