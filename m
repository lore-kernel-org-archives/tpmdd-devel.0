From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Thu, 24 Aug 2017 15:26:30 +0300
Message-ID: <20170824122630.75sxjmkj5f7p7tv5@linux.intel.com>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
 <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 22, 2017 at 04:28:54PM -0500, Jiandi An wrote:
>  > >  {
> > > -	if ((priv->flags & CRB_FL_ACPI_START) ||
> > > -	    (priv->flags & CRB_FL_CRB_SMC_START))
> > > -		return 0;
> > > -
> > > -	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> > > -	/* we don't really care when this settles */
> > > +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0)
> > > +		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> > > +		/* we don't really care when this settles */
> > 
> > It's *exactly* the same condition expessed in different form.
> > 
> 
> I'm sorry perhaps I didn't fully understand the workaround specific to Intel
> PPT.  In previous patch thread, you mentioned the following where
> a platform could report to require start method 2 (ACPI start) which is
> sm = ACPI_TPM2_START_METHOD, and actually requires start method 8, which
> is sm = ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD.

What this has to do with the above code change? Those two versions
compile most likely to almost if not exactly same machine code.

Both the original code and your updated blacklist cases where either
of those flags is set.

> But you listed the following code logic which for either sm = 2 or
> sm = 8, CRB_FL_ACPI_START flag is set.
> 
> if (sm == ACPI_TPM2_START_METHOD ||
>     sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
> 	priv->flags |= CRB_FL_ACPI_START;
> 
> So I'm a little confused about the PPT workaround you mentioned
> 
> /* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
>  * report only ACPI start but in practice seems to require both
>  * ACPI start and CRB start.
>  */
> if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
>     !strcmp(acpi_device_hid(device), "MSFT0101"))
> 	priv->flags |= CRB_FL_CRB_START;
> 
> I took it as some platform sm = 2 or sm = 8 which CRB_FL_ACPI_START
> flag is set, additionally, if HID = MSFT0101, CRB_FL_CRB_START flag
> is set.

Yes.

I'm starting to think that the code might be easier to follow if we
removed 'flags' and store sm to the priv struct and put conditionals in
places where we need them based on sm.

I think the 'flags' field was not a good idea in the first place.

/Jarkko
