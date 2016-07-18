From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2 0/6] Use tpm_transmit_cmd() consistently
Date: Mon, 18 Jul 2016 21:10:51 +0300
Message-ID: <20160718181051.GC31463@intel.com>
References: <1466891093-27766-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160706142143.GA4442@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706142143.GA4442@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 06, 2016 at 05:21:43PM +0300, Jarkko Sakkinen wrote:
> Pending for reviews. These are quite trivial patches.
> 
> /Jarkko
> 
> On Sun, Jun 26, 2016 at 12:44:45AM +0300, Jarkko Sakkinen wrote:
> > These commits update the subsystem consistently to use
> > tpm_transmit_cmd() throughout the subsystem the exception being
> > tpm_write() where it makes sense to use the raw interface because higher
> > level command handling is delegated to user space.
> > 
> > v2: Added commit that drops externs from all function declarations in
> > tpm.h as suggested by Jason Gunthorpe.

Jason, do you think I could apply these to master or do you see
anything wrong in them?

/Jarkko

> > Jarkko Sakkinen (6):
> >   tpm: remove unnecessary externs from tpm.h
> >   tpm: unify tpm_gen_interrupt()
> >   tpm: return error code from tpm_gen_interrupt()
> >   tpm: use tpm_transmit_cmd() in tpm2_probe()
> >   tpm: rename tpm_pcr_read_dev() to tpm1_pcr_read()
> >   tpm: use tpm1_pcr_read() in tpm_do_selftest()
> > 
> >  drivers/char/tpm/tpm-interface.c | 36 ++++++++++++++++++----------------
> >  drivers/char/tpm/tpm-sysfs.c     |  2 +-
> >  drivers/char/tpm/tpm.h           | 42 +++++++++++++++++++---------------------
> >  drivers/char/tpm/tpm2-cmd.c      | 21 +-------------------
> >  drivers/char/tpm/tpm_tis_core.c  |  7 +++----
> >  5 files changed, 44 insertions(+), 64 deletions(-)
> > 
> > -- 
> > 2.7.4
> > 
> 
> ------------------------------------------------------------------------------
> Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
> Francisco, CA to explore cutting-edge tech and listen to tech luminaries
> present their vision of the future. This family event has something for
> everyone, including kids. Get more information and register today.
> http://sdm.link/attshape
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
