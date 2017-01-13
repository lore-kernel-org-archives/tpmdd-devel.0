From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC v2 5/5] tpm2: expose resource manager via a device
 link /dev/tpms<n>
Date: Fri, 13 Jan 2017 10:25:37 -0700
Message-ID: <20170113172537.GA31125@obsidianresearch.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
 <20170112205628.qh3yf2jcargtw6qv@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112205628.qh3yf2jcargtw6qv@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 10:56:28PM +0200, Jarkko Sakkinen wrote:

> >  dev_t tpm_devt;
> 
> But they should have different major device numbers.

major/minors don't really matter these days since they are dynamic

Jason
