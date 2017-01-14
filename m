From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing commands on
 shutdown
Date: Fri, 13 Jan 2017 16:42:30 -0800
Message-ID: <20170114004230.GA21035@apronin>
References: <20170114000954.17728-1-apronin@chromium.org>
 <20170114002857.GA5851@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170114002857.GA5851@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, semenzato@chromium.org, groeck@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 05:28:57PM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 13, 2017 at 04:09:54PM -0800, Andrey Pronin wrote:
> > Resetting TPM while processing a command may lead to issues
> > on the next boot. Ensure that we don't have any ongoing
> > commands, and that no further commands can be sent to the chip
> > by unregistering the device in the shutdown handler.
> > tpm_chip_unregister() waits for the completion of an ongoing
> > command, if any, and then clears out chip->ops and unregisters
> > sysfs entities.
> 
> Unregistering in a shutdown handler seems very strange, it also waits
> for userspace things, so I wonder if it could be problematic?
> 
> Maybe just use
> 
>    down_write(&chip->ops_sem);
>    chip->ops = NULL;
>    up_write(&chip->ops_sem);
> 
> In the shutdown handler?

down_write(&chip->ops_sem) would still wait for completing the initiated
writes, since tpm_write() in tpm-dev.c calls tpm_try_get_ops().
Also, tpm-sysfs.c calls chip->ops directly, so sysfs should be
unregistered first.
And the last thing, this driver supports TPM 1.2, but if it was a 2.0
chip, it'd also need to send TPM2_Shutdown(CLEAR) from its shutdown
handler (or get an unorderly shutdown and DA counter increment).

All these things are handled by tpm_chip_unregister(). I thought about
creating a tpm_chip_shutdown routine that could be called from shutdown
handlers of the drivers that need it (and I'd do it for every driver,
especially in 2.0 case). But decided that it's better to reuse the
existing tpm_chip_unregister() that already does what's needed.

> 
> Jason
