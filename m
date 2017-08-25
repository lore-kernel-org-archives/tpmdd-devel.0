From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_tis: make array cmd_getticks static const to shink
 object code size
Date: Fri, 25 Aug 2017 20:31:20 +0300
Message-ID: <20170825173120.l2mp4tckdtyixzii@linux.intel.com>
References: <20170825164505.23447-1-colin.king@canonical.com>
 <20170825165242.GA5254@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825165242.GA5254@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Colin King <colin.king@canonical.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 25, 2017 at 10:52:42AM -0600, Jason Gunthorpe wrote:
> On Fri, Aug 25, 2017 at 05:45:05PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Don't populate array cmd_getticks on the stack, instead make it static
> > const.  Makes the object code smaller by over 160 bytes:
> > 
> > Before:
> >    text	   data	    bss	    dec	    hex	filename
> >   18813	   3152	    128	  22093	   564d	drivers/char/tpm/tpm_tis_core.o
> > 
> > After:
> >    text	   data	    bss	    dec	    hex	filename
> >   18554	   3248	    128	  21930	   55aa	drivers/char/tpm/tpm_tis_core.o
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Jason

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
