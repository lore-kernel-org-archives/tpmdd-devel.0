From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix type issues in tpm_getcap()
Date: Fri, 3 Feb 2017 21:06:42 +0200
Message-ID: <20170203190642.fahf7wlx77nh3xjy@intel.com>
References: <20170201175347.2035-1-jarkko.sakkinen@linux.intel.com>
 <58947D8E.20000@linux.vnet.ibm.com>
 <20170203181523.mu4hqhb7epqmthfd@intel.com>
 <5894D007.6060207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5894D007.6060207@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 04, 2017 at 12:16:31AM +0530, Nayna wrote:
> 
> 
> On 02/03/2017 11:45 PM, Jarkko Sakkinen wrote:
> > On Fri, Feb 03, 2017 at 06:24:38PM +0530, Nayna wrote:
> > > 
> > > 
> > > On 02/01/2017 11:23 PM, Jarkko Sakkinen wrote:
> > > > There are two type issues associated with tpm_getcap().
> > > > 
> > > > You must not do arithmetic with __be32 or __le32 types because sometimes
> > > > it results incorrect results. Calculations must be done only with data
> > > > that is in CPU byte order. This commit migrates tpm_getcap() to struct
> > > > tpm_buf in order to sort out these issues.
> > > > 
> > > > The second issue is with struct cap_t as the size of the type bool is
> > > > assumed to be one byte. This commit sorts out the issue by changing the
> > > > type to u8.
> > > > 
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > ---
> > > > v2:
> > > > - Use struct tpm_buf.
> > > > - Merge the type change of 'owned' to this patch.
> > > >    drivers/char/tpm/tpm-interface.c | 33 ++++++++++++++++++---------------
> > > >    drivers/char/tpm/tpm.h           | 15 +--------------
> > > >    2 files changed, 19 insertions(+), 29 deletions(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > > index 423938e..7af1e8c 100644
> > > > --- a/drivers/char/tpm/tpm-interface.c
> > > > +++ b/drivers/char/tpm/tpm-interface.c
> > > > @@ -480,31 +480,34 @@ static const struct tpm_input_header tpm_getcap_header = {
> > > 
> > > Is tpm_getcap_header still needed ?
> > 
> > Definitely not, thanks. Are you able to try this out so I could
> > move forward with pull request?
> 
> Yes, I tried it out and see a problem, I already replied that in one other
> mail.
> The tag and ordinal are converted to BE twice, once in #define  and again in
> tpm_buf_init.
> 
> Thanks & Regards,
>    - Nayna

Hmm... I wonder why it seemed to work when I tried it. I must have done
BuildRoot image build without this patch [1]. Hmm... I just take Stefans
patch that only changes 'owned' to u8 and refine this after the pull
request. Fixing the other sparse errors is not as high priority for the
release.

[1] http://git.infradead.org/users/jjs/buildroot-tpmdd.git

/Jarkko
