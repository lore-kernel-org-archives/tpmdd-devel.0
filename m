From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: constify transmit data pointers
Date: Thu, 7 Sep 2017 14:01:53 -0600
Message-ID: <20170907200153.GA6350@obsidianresearch.com>
References: <20170907133130.2463746-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170907133130.2463746-1-arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 07, 2017 at 03:30:45PM +0200, Arnd Bergmann wrote:
> Making cmd_getticks 'const' introduced a couple of harmless warnings:
> 
> drivers/char/tpm/tpm_tis_core.c: In function 'probe_itpm':
> drivers/char/tpm/tpm_tis_core.c:469:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> drivers/char/tpm/tpm_tis_core.c:477:31: error: passing argument 2 of 'tpm_tis_send_data' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> drivers/char/tpm/tpm_tis_core.c:255:12: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'const u8 * {aka const unsigned char *}'
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> 
> This changes the related functions to all take 'const' pointers
> so that gcc can see this as being correct. I had to slightly
> modify the logic around tpm_tis_spi_transfer() for this to work
> without introducing ugly casts.
> 
> Fixes: 5e35bd8e06b9 ("tpm_tis: make array cmd_getticks static const to shink object code size")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Bit confused how the compile warnings introduced by the original patch
were missed?? Jarkko do you run compile tests and sparse before
sending pull requests?

Cheers,
Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
