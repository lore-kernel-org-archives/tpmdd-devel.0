From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v4 4/5] tpm: split out tpm-dev.c into
 tpm-dev.c and tpm-common-dev.c
Date: Mon, 23 Jan 2017 14:28:23 -0800
Message-ID: <1485210503.2534.32.camel@HansenPartnership.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
         <20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
         <20170123164754.GA29360@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170123164754.GA29360@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-23 at 09:47 -0700, Jason Gunthorpe wrote:
> On Mon, Jan 23, 2017 at 01:44:32AM +0200, Jarkko Sakkinen wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > Signed-off-by: James Bottomley
> > <James.Bottomley@HansenPartnership.com>
> 
> I really think we should not use the ugly read/write interface for 
> any new things.

The R/W interface is needed for backward compat, so we don't really
have a choice (well, it could go in for long term deprecation, but I
found in SCSI that "long term" == "never").  I think no-one objects to
the ioctl interface ... it's just no-one feels strongly enough to build
and test it.  I'm sure if you send patches, Jarkko will include them.

James

> Still unconvinced we should add a new cdev at this point.. But seeing
> seesion support certainl is encouraging..


