From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH v5] tpm: Check size of response before
 accessing data
Date: Mon, 16 Jan 2017 09:06:21 -0700
Message-ID: <20170116160621.GA18596@obsidianresearch.com>
References: <1484361394-13581-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484361394-13581-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 09:36:34PM -0500, Stefan Berger wrote:

>  	header = cmd;
> +	if (len < be32_to_cpu(header->length) ||
> +	    be32_to_cpu(header->length) < min_rx_length)
> +		return -EFAULT;

>  	err = be32_to_cpu(header->return_code);
>  	if (err != 0 && desc)

Your earlier message points out the problem with this order, it seems
like we want a valid TPM error code to take precedence over a short
message. Isn't this better than hacking up things that check for
POSTINIT?

  if (len < be32_to_cpu(header->length))
        return -EFAULT;

   err = be32_to_cpu(header->return_code);
   if (err != 0)
     [..]

   if (be32_to_cpu(header->length) < min_rx_length)
        return -EFAULT;

?

Jason
