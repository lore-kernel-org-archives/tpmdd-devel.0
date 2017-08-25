From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm_tis: make array cmd_getticks static const to shink
 object code size
Date: Fri, 25 Aug 2017 10:52:42 -0600
Message-ID: <20170825165242.GA5254@obsidianresearch.com>
References: <20170825164505.23447-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825164505.23447-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 25, 2017 at 05:45:05PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate array cmd_getticks on the stack, instead make it static
> const.  Makes the object code smaller by over 160 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   18813	   3152	    128	  22093	   564d	drivers/char/tpm/tpm_tis_core.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   18554	   3248	    128	  21930	   55aa	drivers/char/tpm/tpm_tis_core.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
