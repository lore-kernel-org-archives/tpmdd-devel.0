From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/6] tpm: export tpm2_flush_context_cmd
Date: Fri, 10 Feb 2017 09:42:12 +0200
Message-ID: <20170210074212.pi7xb4rvjuwfkdj7@intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
	<20170208110713.14070-3-jarkko.sakkinen@linux.intel.com>
	<20170208175830.GA31571@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208175830.GA31571-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 08, 2017 at 10:58:30AM -0700, Jason Gunthorpe wrote:
> >  /**
> > + * tpm2_flush_context_cmd() - execute a TPM2_FlushContext command
> > + * @chip: TPM chip to use
> > + * @payload: the key data in clear and encrypted form
> > + * @options: authentication values and other options
> > + *
> > + * Return: same as with tpm_transmit_cmd
> > + */
> > +void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
> > +			    unsigned int flags)
> 
> Why did you move the function in the same file? Adding a prototype
> shouldn't require that..
> 
> Jason

To be logically positioned in the same way as it is in the header.

It cannot in-between the helper functions for tpm2_seal_trusted().

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
