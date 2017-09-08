From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: constify transmit data pointers
Date: Sat, 9 Sep 2017 00:28:37 +0300
Message-ID: <20170908212837.yhtvgp6gmxspgiad@linux.intel.com>
References: <20170907133130.2463746-1-arnd@arndb.de>
 <20170907200153.GA6350@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907200153.GA6350@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Colin Ian King <colin.king@canonical.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 07, 2017 at 02:01:53PM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 07, 2017 at 03:30:45PM +0200, Arnd Bergmann wrote:
> > Making cmd_getticks 'const' introduced a couple of harmless warnings:
> > 
> > drivers/char/tpm/tpm_tis_core.c: In function 'probe_itpm':
> > drivers/char/tpm/tpm_tis_core.c:469:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
> >   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> > drivers/char/tpm/tpm_tis_core.c:477:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
> >   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> > drivers/char/tpm/tpm_tis_core.c:255:12: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'const u8 * {aka const unsigned char *}'
> >  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> > 
> > This changes the related functions to all take 'const' pointers
> > so that gcc can see this as being correct. I had to slightly
> > modify the logic around tpm_tis_spi_transfer() for this to work
> > without introducing ugly casts.
> > 
> > Fixes: 5e35bd8e06b9 ("tpm_tis: make array cmd_getticks static const to shink object code size")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Bit confused how the compile warnings introduced by the original patch
> were missed?? Jarkko do you run compile tests and sparse before
> sending pull requests?
> 
> Cheers,
> Jason

Yes, I do. This has not been part of any pull request so I fail to
understand why you bring them up?

I did run compile tests but managed somehow miss the warning. Sorry
about that but something like this has happened rarely. I can only
blame ridiculous amount of multitasking in last couple of weeks.

/Jarkko
