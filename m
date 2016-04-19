From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm_crb: fix mapping of the buffers
Date: Tue, 19 Apr 2016 11:09:53 -0600
Message-ID: <20160419170953.GB20844@obsidianresearch.com>
References: <1461059658-8884-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461059658-8884-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 12:54:18PM +0300, Jarkko Sakkinen wrote:
> Cc: stable@vger.kernel.org
> Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>  drivers/char/tpm/tpm_crb.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)

This looks OK

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

> +	if (cmd_pa != rsp_pa) {
> +		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
> +		return PTR_ERR_OR_ZERO(priv->rsp);
> +	}

I would use an else here, 'exit on success' is considered an
anti-pattern.

Eg:

if (cmd_pa == rsp_pa) {
	/* According to the PTP specification, overlapping command and response
	 * buffer sizes must be identical.
	 */
	if (cmd_size != rsp_size) {
		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
		return -EINVAL;
	}
	priv->rsp = priv->cmd;
}
else {
	priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
        if (IS_ERR(priv->rsp))
	   	return PTR_ERR(priv->rsp);
}

return 0;


Jason
