From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: drop chip->is_open and chip->duration_adjusted
Date: Mon, 14 Nov 2016 21:30:01 -0700
Message-ID: <20161115043001.GA22482@obsidianresearch.com>
References: <20161114234500.24839-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161114234500.24839-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 03:44:58PM -0800, Jarkko Sakkinen wrote:
> Use atomic bitops for chip->flags so that we do not need chip->is_open
> and chip->duration_adjusted anymore.

I don't know if it s a really great idea to use atomic bit ops for
things that do not need to be atomic.. It makes the locking scheme
less clear. is open is genuinely different since it relies on the
atomic for correctness.

Merging is_duration makes lots of sense though

Jason
