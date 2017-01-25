From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Wed, 25 Jan 2017 20:59:19 +0200
Message-ID: <20170125185919.jpd46e4774t65e5s@intel.com>
References: <20170114000954.17728-1-apronin@chromium.org>
 <20170114002857.GA5851@obsidianresearch.com>
 <20170114004230.GA21035@apronin>
 <20170116093318.wmmr2z54pc6k7t2c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170116093318.wmmr2z54pc6k7t2c@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: linux-kernel@vger.kernel.org, semenzato@chromium.org, tpmdd-devel@lists.sourceforge.net, groeck@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 11:33:18AM +0200, Jarkko Sakkinen wrote:
> On Fri, Jan 13, 2017 at 04:42:30PM -0800, Andrey Pronin wrote:
> > On Fri, Jan 13, 2017 at 05:28:57PM -0700, Jason Gunthorpe wrote:
> > > On Fri, Jan 13, 2017 at 04:09:54PM -0800, Andrey Pronin wrote:
> > > > Resetting TPM while processing a command may lead to issues
> > > > on the next boot. Ensure that we don't have any ongoing
> > > > commands, and that no further commands can be sent to the chip
> > > > by unregistering the device in the shutdown handler.
> > > > tpm_chip_unregister() waits for the completion of an ongoing
> > > > command, if any, and then clears out chip->ops and unregisters
> > > > sysfs entities.
> > > 
> > > Unregistering in a shutdown handler seems very strange, it also waits
> > > for userspace things, so I wonder if it could be problematic?
> > > 
> > > Maybe just use
> > > 
> > >    down_write(&chip->ops_sem);
> > >    chip->ops = NULL;
> > >    up_write(&chip->ops_sem);
> > > 
> > > In the shutdown handler?
> > 
> > down_write(&chip->ops_sem) would still wait for completing the initiated
> > writes, since tpm_write() in tpm-dev.c calls tpm_try_get_ops().
> > Also, tpm-sysfs.c calls chip->ops directly, so sysfs should be
> > unregistered first.
> 
> Why don't you fix the tpm-sysfs issue but rather misusing
> tpm_chip_unregister?

Ignore this. I wasn't following this thread properly.

Only now had time read carefully through the discussion.

/Jarkko
