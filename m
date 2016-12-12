From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v3 1/3] tpm_crb: map locality registers
Date: Mon, 12 Dec 2016 17:32:02 +0200
Message-ID: <20161212153202.d2ky3b5jsgaiacpi@intel.com>
References: <20161207115001.18332-1-jarkko.sakkinen@linux.intel.com>
 <20161207115001.18332-2-jarkko.sakkinen@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B5433A4BD@hasmsx108.ger.corp.intel.com>
 <20161212152001.53ewps3jczs4jdld@intel.com>
 <20161212153108.mc5xf72npprz7wpe@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161212153108.mc5xf72npprz7wpe@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, open list <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Dec 12, 2016 at 05:31:08PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 12, 2016 at 05:20:01PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 12, 2016 at 02:25:32PM +0000, Winkler, Tomas wrote:
> > > > 
> > > > In order to provide access to locality registers, this commits adds mapping of
> > > > the head of the CRB registers, which are located right before the control area.
> > > > 
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > ---
> > > >  drivers/char/tpm/tpm_crb.c | 89 +++++++++++++++++++++++++++++------------
> > > > -----
> > > >  1 file changed, 57 insertions(+), 32 deletions(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c index
> > > > 717b6b4..80b9759 100644
> > > > --- a/drivers/char/tpm/tpm_crb.c
> > > > +++ b/drivers/char/tpm/tpm_crb.c
> > > > @@ -52,18 +52,28 @@ enum crb_cancel {
> > > >  	CRB_CANCEL_INVOKE	= BIT(0),
> > > >  };
> > > > 
> > > > -struct crb_control_area {
> > > > -	u32 req;
> > > > -	u32 sts;
> > > > -	u32 cancel;
> > > > -	u32 start;
> > > > -	u32 int_enable;
> > > > -	u32 int_sts;
> > > > -	u32 cmd_size;
> > > > -	u32 cmd_pa_low;
> > > > -	u32 cmd_pa_high;
> > > > -	u32 rsp_size;
> > > > -	u64 rsp_pa;
> > > > +struct crb_regs_head {
> > > > +	u32 loc_state;
> > > > +	u32 reserved1;
> > > > +	u32 loc_ctrl;
> > > > +	u32 loc_sts;
> > > > +	u8 reserved2[32];
> > > > +	u64 intf_id;
> > > > +	u64 ctrl_ext;
> > > > +} __packed;
> > > > +
> > > 
> > > > +struct crb_regs_tail {
> > > Why to change the name this is still control_area 
> 
> And how would you name struct crb_regs_h then?
> 
> In my opinion PC it makes a lot of sense to speak about registers here
                ~~
Typo.

/Jarkko
