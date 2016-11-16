From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: drop chip->is_open and chip->duration_adjusted
Date: Wed, 16 Nov 2016 14:54:12 -0800
Message-ID: <20161116225412.gzvw7f5snnovk7na@intel.com>
References: <20161114234500.24839-1-jarkko.sakkinen@linux.intel.com>
 <20161115043001.GA22482@obsidianresearch.com>
 <20161115051106.u2xoduwf2kpcznv3@intel.com>
 <20161116052832.GB6044@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161116052832.GB6044@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 10:28:32PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 14, 2016 at 09:11:54PM -0800, Jarkko Sakkinen wrote:
> 
> > How strong is your opposition here? I do not see any exceptional damage
> > done but see some subtle but still significant benefits.
> 
> It seems OK, but I never like seeing locking made less clear - this
> should be manageable, and there isn't a performance concern with tpm
> either..

OK good to hear. I'm using this as part of my RM patch set. Just wanted
to get some feedback for this patch. Not for the next rel.

/Jarkko
