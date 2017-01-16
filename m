From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager via a device
 link /dev/tpms<n>
Date: Mon, 16 Jan 2017 09:14:13 -0700
Message-ID: <20170116161413.GA19979@obsidianresearch.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
 <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 03:12:11PM +0200, Jarkko Sakkinen wrote:

> @@ -199,7 +227,9 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	return chip;
>  
>  out:
> +	put_device(&chip->devrm);
>  	put_device(&chip->dev);
> +	put_device(&chip->devrm);
>  	return ERR_PTR(rc);
>  }

Something has gone wrong here..

Jason
