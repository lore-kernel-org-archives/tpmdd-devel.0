From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: declare tpm2_get_pcr_allocation() as static
Date: Wed, 15 Feb 2017 21:06:48 +0200
Message-ID: <20170215190648.w5i3fkkjvmipzbeb@intel.com>
References: <20170215180228.25650-1-jarkko.sakkinen@linux.intel.com>
 <20170215185643.GG19162@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170215185643.GG19162@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 15, 2017 at 11:56:43AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 15, 2017 at 08:02:28PM +0200, Jarkko Sakkinen wrote:
> > There's no need to export tpm2_get_pcr_alloation() because it is only
> > a helper function for tpm2_auto_startup(). For the same reason it does
> > not make much sense to maintain documentation for it.
> 
> Please stop moving these functions around, you are just breaking the
> git history and git blame - there cosmetic reason of having a certain
> order is not worth this damage.
> 
> Jason

So you rather want a predeclaration?

Moving code for the right reasons is perfectly justifiable.

/Jarkko
