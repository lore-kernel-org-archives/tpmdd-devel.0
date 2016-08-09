From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix cacheline alignment for DMA-able
 buffers
Date: Tue, 9 Aug 2016 16:08:38 -0600
Message-ID: <20160809220837.GA5535@obsidianresearch.com>
References: <1469761153-85576-1-git-send-email-apronin@chromium.org>
 <20160729172702.GB7020@obsidianresearch.com>
 <CAE_wzQ-=8Su6xzA8Cv+C6ma8iYJfnOwR=hW-KBKjBG+4eOwF4g@mail.gmail.com>
 <20160809094610.GA13566@intel.com>
 <20160809150114.GA9672@intel.com>
 <CAE_wzQ95LAm7JkfB=V2VZVc4Vha4GcRyOBH_J8ZEh1gG+ZjEAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE_wzQ95LAm7JkfB=V2VZVc4Vha4GcRyOBH_J8ZEh1gG+ZjEAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Christophe Ricard <christophe.ricard@gmail.com>, tpmdd-devel@lists.sourceforge.net, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 08:18:00AM -0700, Dmitry Torokhov wrote:

>    Well, the main reason was simplicity and invasiveness of the
>    change.

Well, it isn't simple, because the proposed patches have had subtle
problems with DMA. Simple is to use a guaranteed dma-able allocation
for DMA memory and stop trying to over optimize.

Jason
