From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_crb: fix mapping of the buffers
Date: Tue, 19 Apr 2016 21:47:58 +0300
Message-ID: <20160419184758.GA13115@intel.com>
References: <1461059658-8884-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160419170953.GB20844@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160419170953.GB20844@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 11:09:53AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 19, 2016 at 12:54:18PM +0300, Jarkko Sakkinen wrote:
> > Cc: stable@vger.kernel.org
> > Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >  drivers/char/tpm/tpm_crb.c | 39 ++++++++++++++++++++++++++++-----------
> >  1 file changed, 28 insertions(+), 11 deletions(-)
> 
> This looks OK
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks!

> > +	if (cmd_pa != rsp_pa) {
> > +		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
> > +		return PTR_ERR_OR_ZERO(priv->rsp);
> > +	}
> 
> I would use an else here, 'exit on success' is considered an
> anti-pattern.

> Eg:
> 
> if (cmd_pa == rsp_pa) {
> 	/* According to the PTP specification, overlapping command and response
> 	 * buffer sizes must be identical.
> 	 */
> 	if (cmd_size != rsp_size) {
> 		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
> 		return -EINVAL;
> 	}
> 	priv->rsp = priv->cmd;
> }
> else {
> 	priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
>         if (IS_ERR(priv->rsp))
> 	   	return PTR_ERR(priv->rsp);
> }
> 
> return 0;

I have to (in order to do right things right):

1. Update the patch.
2. Smoke test with the machines that I have.
3. Send a new version for review (because of the revamped control flow).

It's not that I wouldn't be willing to do this. I just don't think
this matters enough to be worth of the trouble.

> Jason

/Jarkko
