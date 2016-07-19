From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_tis_core: convert max timeouts from msec to jiffies
Date: Tue, 19 Jul 2016 15:53:46 +0300
Message-ID: <20160719125346.GA5047@intel.com>
References: <1468542580-5296-1-git-send-email-apronin@chromium.org>
 <20160718184532.GH31463@intel.com>
 <20160718184929.GA19217@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160718184929.GA19217@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrey Pronin <apronin@chromium.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jul 18, 2016 at 12:49:29PM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 18, 2016 at 09:45:32PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Jul 14, 2016 at 05:29:40PM -0700, Andrey Pronin wrote:
> > > tpm_tis_core was missing conversion from msec when assigning
> > > max timeouts from constants.
> > > 
> > > Signed-off-by: Andrey Pronin <apronin@chromium.org>
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Fixes: 41a5e1cf1fe1
> 
> Not sure that fixes isn't right, it looks like it has been broken for
> a really long time..

Thanks, I fixed the commit ID (in my GIT).

> Jason

/Jarkko
