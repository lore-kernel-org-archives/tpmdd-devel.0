From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH 1/2] tpm_tis_core: add optional max xfer size check
Date: Thu, 14 Jul 2016 20:25:17 -0700
Message-ID: <20160715032517.GB25406@apronin>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
 <1468546745-14646-2-git-send-email-apronin@chromium.org>
 <20160715031351.GD9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160715031351.GD9347@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 09:13:51PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 06:39:04PM -0700, Andrey Pronin wrote:
> 
> > +static inline u16 tpm_tis_max_xfer_size(struct tpm_tis_data *data)
> > +{
> > +	return data->phy_ops->max_xfer_size;
> > +}
> > +
> > +static inline bool tpm_tis_burstcnt_is_valid(struct tpm_tis_data *data,
> > +					     u16 burstcnt)
> > +{
> > +	return (tpm_tis_max_xfer_size(data) == 0)
> > +		|| (burstcnt <= tpm_tis_max_xfer_size(data));
> > +}
> 
> We don't need these accessors, just open code it in the one call
> site. That is more clear as the ==0 case is important to understand
> that the flow is correct.
> 
> BTW, I dodn't think || as the start of a line was cannonical kernel
> style.. Did checkpatch accept that?
> 
> Jason

You mean completely open code it inside get_burstcount()? Will do.
checkpatch.pl had no problems with it, but I can move it to the end
of the line, if it feels better.

Andrey
