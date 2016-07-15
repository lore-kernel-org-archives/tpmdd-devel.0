From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/2] tpm: fix byte-order for the value read by
 tpm2_get_tpm_pt
Date: Fri, 15 Jul 2016 13:39:28 -0600
Message-ID: <20160715193928.GA20719@obsidianresearch.com>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
 <1468544838-9990-3-git-send-email-apronin@chromium.org>
 <20160715031046.GC9347@obsidianresearch.com>
 <20160715031701.GA25406@apronin>
 <20160715033553.GJ9347@obsidianresearch.com>
 <20160715193143.GA7052@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160715193143.GA7052@apronin>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 15, 2016 at 12:31:43PM -0700, Andrey Pronin wrote:

> I even tried changing the code there to
> 	__be32 vv = cmd.params.get_tpm_pt_out.value;
> 	u32 ret = vv;
> to make it clear what's going on. Still, no complaints from sparse.

Hum, I'm not an expert at sparse, but I expect a warning from it here?

Maybe Jarkko knows when he gets back?

Jason
