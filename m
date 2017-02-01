From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix a sparse error in tpm-sysfs.c
Date: Wed, 1 Feb 2017 14:00:35 +0200
Message-ID: <20170201120035.ifwuuawxlqs7y5ow@intel.com>
References: <1485888239-7727-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170131203714.phz6dpmbyaynbs44@intel.com>
 <20170201080839.l46vyziwwgusnu7a@intel.com>
 <20170201111734.77s4j7zuptik5epx@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201111734.77s4j7zuptik5epx@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 01, 2017 at 01:17:34PM +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 01, 2017 at 10:08:39AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 31, 2017 at 10:37:14PM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Jan 31, 2017 at 01:43:59PM -0500, Stefan Berger wrote:
> > > > drivers/char/tpm/tpm-sysfs.c:161:25: warning: expression using sizeof bool
> > > > 
> > > > Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
> > > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > > ---
> > > >  drivers/char/tpm/tpm.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > > index bff37be..6b4e7aa 100644
> > > > --- a/drivers/char/tpm/tpm.h
> > > > +++ b/drivers/char/tpm/tpm.h
> > > > @@ -281,7 +281,7 @@ struct permanent_flags_t {
> > > >  typedef union {
> > > >  	struct	permanent_flags_t perm_flags;
> > > >  	struct	stclear_flags_t	stclear_flags;
> > > > -	bool	owned;
> > > > +	__u8	owned;
> > > >  	__be32	num_pcrs;
> > > >  	struct	tpm_version_t	tpm_version;
> > > >  	struct	tpm_version_1_2_t tpm_version_1_2;
> > > > -- 
> > > > 2.4.3
> > > 
> > > A better description would be:
> > > 
> > >   The field owned has wrong sized type. This commit fixes the
> > >   issue.
> > > 
> > > ?
> > > 
> > > /Jarkko
> > 
> > And doesn't owned print invalid results on a big endian system
> > i.e. 0x1000000? The commit message needs to be rewritten to capture
> > the problem.
> 
> Please ignore this, the conversion is done in tpm_getcap(). I'll
> update the commit message.

Now I'm really tripping :( tpm_getcap() does not do any sort of
conversion. _Bool in gcc is one byte. Sorry about this. This is
purely a type error. The size is correct.

/Jarkko
