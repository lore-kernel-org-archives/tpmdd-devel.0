From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 6/6] tpm2: add session handle context
 saving and restoring to the space code
Date: Sat, 11 Feb 2017 00:48:47 +0200
Message-ID: <20170210224847.sh4a5hobcycs23j6@intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
 <20170208110713.14070-7-jarkko.sakkinen@linux.intel.com>
 <20170210123249.nrppoez2kdr2q4nw@intel.com>
 <1486743431.2502.6.camel@HansenPartnership.com>
 <20170210191004.yv5hgnd3h5scj5zt@intel.com>
 <1486753935.2502.35.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486753935.2502.35.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 10, 2017 at 11:12:15AM -0800, James Bottomley wrote:
> On Fri, 2017-02-10 at 21:10 +0200, Jarkko Sakkinen wrote:
> > On Fri, Feb 10, 2017 at 08:17:11AM -0800, James Bottomley wrote:
> > > On Fri, 2017-02-10 at 14:32 +0200, Jarkko Sakkinen wrote:
> > > > On Wed, Feb 08, 2017 at 01:07:08PM +0200, Jarkko Sakkinen wrote:
> > > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > [...] 
> > > > > +static int tpm2_session_add(struct tpm_chip *chip, u32 handle)
> > > > > +{
> > > > > +	struct tpm_space *space = &chip->work_space;
> > > > > +	int i;
> > > > > +
> > > > > +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
> > > > > +		if (space->session_tbl[i] == 0)
> > > > > +			break;
> > > > > +	if (i == ARRAY_SIZE(space->session_tbl)) {
> > > > > +		dev_err(&chip->dev, "out of session slots\n");
> > > > 
> > > > This really should be dev_dbg.
> > > 
> > > This was my reply to the comment the last time:
> > > 
> > >     I can do that, but I think this should be higher than debug. 
> > >  If
> > >     this trips, something an application was doing will fail with a
> > > non
> > >     TPM error and someone may wish to investigate why.  Having a
> > > kernel
> > >     message would help with that (but they won't see it if it's
> > > debug).
> > > 
> > >     I'm also leaning towards the idea that we should actually have
> > > one
> > >     more _tbl slot than we know the TPM does, so that if someone
> > > goes
> > >     over it's the TPM that gives them a real TPM out of memory
> > > error
> > >     rather than the space code returning -ENOMEM.
> > > 
> > >     If you agree, I think it should be four for both sessions_tbl
> > > and
> > >     context_tbl.
> > > 
> > > So I really don't think it should be debug.  Could we compromise on
> > > dev_info?
> > > 
> > > James
> > 
> > Oops, I'm sorry about that. I use the release chaos as an excuse :-)
> > I would lower it to dev_warn().
> 
> That works.  Do you want me to resend the patch?
> 
> James

No need for that.

/Jarkko
