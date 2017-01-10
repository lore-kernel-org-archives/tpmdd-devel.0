From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH 03/10] tpm: tpm2_pcr_read: check size of
 response before accessing data
Date: Tue, 10 Jan 2017 09:18:37 -0700
Message-ID: <20170110161837.GD15493@obsidianresearch.com>
References: <1484057900-17871-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1484057900-17871-3-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484057900-17871-3-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 10, 2017 at 09:18:13AM -0500, Stefan Berger wrote:
> Check the size of the response before accessing data in the
> response packet. This is to avoid accessing data beyond the
> end of the response.

IMHO you should chnage the signature for
tpm_transmit_cmd to be:

ssize_t tpm_transmit_cmd(struct tpm_chip *chip,
  void *iobuf, size_t tx_len,
  size_t min_rx_len,
  unsigned int flags,
  const char *desc);

And then fold this repeated:

>  	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
>  			      "attempting to read a pcr value");
> +	if (rc == 0 &&
> +	    be32_to_cpu(cmd.header.out.length) < TPM2_PCR_READ_OUT_SIZE)
> +		return -EFAULT;

test into tpm_transmit_cmd and now we require every single caller to
specify the minimum command length.

You can fold all of that into one patch, IMHO. Easier for stable.

Jason
