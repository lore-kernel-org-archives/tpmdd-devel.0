From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for only CRB_START method
Date: Tue, 8 Aug 2017 16:36:43 -0600
Message-ID: <20170808223643.GD29372@obsidianresearch.com>
References: <1502074455-4867-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502074455-4867-1-git-send-email-anjiandi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Aug 06, 2017 at 09:54:15PM -0500, Jiandi An wrote:

>  static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
>  {
> -	if ((priv->flags & CRB_FL_ACPI_START) ||
> -	    (priv->flags & CRB_FL_CRB_SMC_START))
> +	if (!(priv->flags & CRB_FL_CRB_START))

I think it would be better to have these list the cases where go_idle
is known to be required. Less brittle that way..

  if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_START)) == 0)
       return 0

> -	if (!(priv->flags & CRB_FL_ACPI_START)) {
> +	if (priv->flags & CRB_FL_CRB_START) {

Eg like this now makes more sense, assumming CRB_START is the right
test :)

Jason
