From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v4 4/5] tpm: split out tpm-dev.c into
 tpm-dev.c and tpm-common-dev.c
Date: Mon, 23 Jan 2017 14:57:11 -0800
Message-ID: <1485212231.2534.35.camel@HansenPartnership.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
         <20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
         <20170123164754.GA29360@obsidianresearch.com>
         <1485210503.2534.32.camel@HansenPartnership.com>
         <20170123224952.GA21744@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170123224952.GA21744@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-23 at 15:49 -0700, Jason Gunthorpe wrote:
> On Mon, Jan 23, 2017 at 02:28:23PM -0800, James Bottomley wrote:
> > On Mon, 2017-01-23 at 09:47 -0700, Jason Gunthorpe wrote:
> > > On Mon, Jan 23, 2017 at 01:44:32AM +0200, Jarkko Sakkinen wrote:
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > Signed-off-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > 
> > > I really think we should not use the ugly read/write interface
> > > for 
> > > any new things.
> > 
> > The R/W interface is needed for backward compat,
> 
> With what? This is a new cdev with different semantics.

If you set TPM_DEVICE=/dev/tpms0 the old software just works.  If we
remove the R/W interface, nothing will work.  The point being the new
cdev has the same interface semantics, it just has different global
behavour.

James
