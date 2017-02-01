From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix type issues in tpm_getcap()
Date: Wed, 1 Feb 2017 20:30:58 +0200
Message-ID: <20170201183058.ubnf7wfctlryqy6v@intel.com>
References: <20170201175347.2035-1-jarkko.sakkinen@linux.intel.com>
 <20170201181845.bsy3pfdmryqm4zgb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201181845.bsy3pfdmryqm4zgb@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 01, 2017 at 08:18:45PM +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 01, 2017 at 07:53:47PM +0200, Jarkko Sakkinen wrote:
> > There are two type issues associated with tpm_getcap().
> > 
> > You must not do arithmetic with __be32 or __le32 types because sometimes
> > it results incorrect results. Calculations must be done only with data
> > that is in CPU byte order. This commit migrates tpm_getcap() to struct
> > tpm_buf in order to sort out these issues.
> > 
> > The second issue is with struct cap_t as the size of the type bool is
> > assumed to be one byte. This commit sorts out the issue by changing the
> > type to u8.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> This is the only mandatory fix for the next pull request and 4.11.

I mean from the reported sparse errors.

/Jarkko
