From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 18:11:30 -0700
Message-ID: <20160213011130.GA2547@obsidianresearch.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@us.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 07:37:10PM -0500, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote on 02/12/2016
>    07:04:30 PM:
>    >
>    > This is a hold over from before the struct device conversion.
>    >
>    > - All prints should be using &chip->dev, which is the Linux
>    >   standard. This changes prints to use tpm0 as the device name,
>    >   not the PnP/etc ID.
>    > - The few places involving sysfs/modules that really do need the
>    >   parent just use chip->dev.parent instead
>    > - We no longer need to get_device(pdev) in any places since it is no
>    >   longer used by any of the code. The kref on the parent is held
>    >   by the device core during device_add and dropped in device_del
>    That is exactly what was needed for the vtpm driver and now you're
>    removing it. Is that still going to work after this change? Or do we
>    need to re-add it as get/put_device(chip->dev.parent) ?

That code was not correct, the get_device side has racy
lack-of-locking problems and it serves no purpose for the tpm core or
any existing driver.

I already fixed this once in commit ba0ef85479c46a 'tpm: Fix
initialization of the cdev' - that solves the racing of get_device,
and grabs the correct device kref, but I forgot to delete the broken
residual get_device. Sigh.

It is unfortunate that bogus code sent you down this rabbit hole. My
bad :(

I'll send you something else that might work for vtpm...

Jason
