From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix invalid constant expressions in tpm.h
Date: Tue, 30 Aug 2016 09:31:03 +0300
Message-ID: <20160830063103.GA4352@intel.com>
References: <1472520498-24173-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160830034536.GA29261@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160830034536.GA29261@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 29, 2016 at 09:45:36PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 04:28:17AM +0300, Jarkko Sakkinen wrote:
> > The enums tpm_capabilities and tpm_sub_capabilities do not contain legit
> > constant expressions. This commit makes cap_id a separate parameter
> > in
> 
> I wonder if this is a bug in sparse? the macro uses gcc magic to
> expand to a constexpr.
> 
> You could also use __constant_cpu_to_be32 and similar instead.
> 
> But I admit I never liked the use of no-host endian in the constants..

It's too much magic for me, be it way or another :)


> >  #define TPM_ORD_STARTUP cpu_to_be32(153)
> >  #define TPM_ST_CLEAR cpu_to_be16(1)
> 
> Would be nice to see these fixed into an enum someday too

(putting note into my backlog text file)

> > +enum tpm1_capabilities {
> > +	TPM1_CAP_FLAG		= 0x04,
> > +	TPM1_CAP_PROP		= 0x05,
> > +	TPM1_CAP_VERSION_1_1	= 0x06,
> > +	TPM1_CAP_VERSION_1_2	= 0x1A,
> 
> I usually discourage the extra horizontal whitespace, just causes patch churn to
> keep it up (and clang-format won't do it automatically). Not sure if
> there is a consensus on that though.
> 
> But looks fine to me.
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks!

> Jason

/Jarkko
