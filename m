From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm_tis: override reported C and D timeouts for Atmel
 3203
Date: Thu, 12 Jan 2017 13:19:02 -0700
Message-ID: <20170112201902.GA15687@obsidianresearch.com>
References: <08953fb6-c332-ef29-2614-6335570023be@maciej.szmigiero.name>
 <20170112184229.GB12836@obsidianresearch.com>
 <259e1606-255b-5bf4-54bb-1bed967c228a@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <259e1606-255b-5bf4-54bb-1bed967c228a@maciej.szmigiero.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 09:09:33PM +0100, Maciej S. Szmigiero wrote:

> Hmm, I dug in history of tpm-interface.c and the code had actually rejected
> zero timeouts until commit 8e54caf407b98e (this is the commit that
> introduced the Atmel 3204 workaround) and let default timeout values remain
> instead (it looks like they were exactly like these in above override at
> that time).

The model changed around then.. Just printing if the timeout is 0 is
enough for now..

> Did Atmel 3204 report wrong but non-zero timeouts?

Yes, I think it may have..

Jason
