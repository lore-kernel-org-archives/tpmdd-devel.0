From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Fri, 25 Aug 2017 19:21:39 +0300
Message-ID: <20170825162139.s5oasztecntzg223@linux.intel.com>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
 <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
 <20170824122630.75sxjmkj5f7p7tv5@linux.intel.com>
 <7478e964-6553-9d1e-3d8f-83b044a9a562@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7478e964-6553-9d1e-3d8f-83b044a9a562@codeaurora.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 12:20:35PM -0500, Jiandi An wrote:
> I know they don't change the logic.  This was to address comment from Jason.
> He wanted to express the exact condition which crb_go_idle(),
> crb_cmd_ready(), and the check for "Bad ACPI memory layout" in
> crb_map_io() should run, instead of the if not the condition, return.
> Since you want it as is, I'll change it back. It's already excluding
> CRB_FL_CRB_SMC_START in addition to CRB_FL_ACPI_START which is what's
> intended.

I think this very in simple terms. It does not change *anything*.

> Like I said the goal for this patch is to really further exclude
> CRB_FL_CRB_SMC_START from the check for "Bad ACPI memory layout"
> in crb_map_io() in the code below.
> 
> @@ -458,7 +455,7 @@ static int crb_map_io(struct acpi_device *device, struct
> crb_priv *priv,
>   * the control area, as one nice sane region except for some older
>   * stuff that puts the control area outside the ACPI IO region.
>   */
>  -if (!(priv->flags & CRB_FL_ACPI_START)) {
>  +if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
>   		if (buf->control_address == io_res.start +
>   		    sizeof(*priv->regs_h))
>   			priv->regs_h = priv->iobase;
>   		else
>   		    dev_warn(dev, FW_BUG "Bad ACPI memory layout");
>   }
> 
> I'll submit v2 with only this change.  Are you okay which this change?

I'm not OK with those parts that do nothing except shuffle the code.

As I said before it would make much more sense to make code always deal
with sm and remove flags completely. That would help maintaining code
easier as new logic for TZ is introduced.

> Thanks
> - Jiandi

/Jarkko
