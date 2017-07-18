From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 3/4] Add "shutdown" to "struct class".'
Date: Tue, 18 Jul 2017 17:48:51 +0200
Message-ID: <20170718154851.GC30882@kroah.com>
References: <20170714195803.7035-1-joshz@google.com>
 <20170714195803.7035-4-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714195803.7035-4-joshz@google.com>
Sender: stable-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 14, 2017 at 12:58:02PM -0700, Josh Zimmerman wrote:
> Backport of commit f77af15165847406b15d8f70c382c4cb15846b2a upstream.
> 
> The TPM class has some common shutdown code that must be executed for
> all drivers. This adds some needed functionality for that.
> ---
>  drivers/base/core.c    | 6 +++++-
>  include/linux/device.h | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)

You forgot all of the signed-off-by and the like :(

I've taken the original patch instead, but please be more careful next
time.

thanks,

greg k-h
