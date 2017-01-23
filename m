From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC v4 4/5] tpm: split out tpm-dev.c into tpm-dev.c and
 tpm-common-dev.c
Date: Mon, 23 Jan 2017 09:47:54 -0700
Message-ID: <20170123164754.GA29360@obsidianresearch.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
 <20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 01:44:32AM +0200, Jarkko Sakkinen wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>

I really think we should not use the ugly read/write interface for any
new things.

Still unconvinced we should add a new cdev at this point.. But seeing
seesion support certainl is encouraging..

Jason
