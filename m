From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 00/12] Rework of tpm_tis to share
 common logic accross phy's (lpc/spi/-i2c-)
Date: Tue, 19 Apr 2016 11:59:06 -0600
Message-ID: <20160419175906.GB26460@obsidianresearch.com>
References: <1460788542-2455-1-git-send-email-christophe-h.ricard@st.com>
	<20160418172352.GB13979@obsidianresearch.com>
	<5715BDFF.5000702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5715BDFF.5000702-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 07:11:27AM +0200, Christophe Ricard wrote:
> Please have a look to:
> https://github.com/cricard13/linux-tpmdd

Okay, looking at how everything ended up..

The indentation in tpm_tis_core.h should be fixed up.

These:

 static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 				  u8 *result)

Should not take a 'chip' as an argument, they only work with tpm_tis
devices, so they should take tpm_tis_data as an argument. Same with
the ops. Typesafety for correctness..

Why is release_localtity exported but request_locality is not? There
is something really wonky looking with how that locality stuff works.

I wonder if the itpm detection routine should move to the core code?
It uses so many internal functions it isn't all that nice to have them
exported just for that. A phy could have a flag TPM_TIS_ITPM_POSSIBLE
to turn it on.

No to stuff like this:

	/* Check SPI platform functionnalities */
	if (!dev) {
		pr_err("%s: dev is NULL. Device is not accessible.\n",
				__func__);
		return -ENODEV;
	}


The core has a tpm_tis_remove function, but the spi driver doesn't
call it, that looks wrong.

Use inlines functions:
 #define to_tpm_tis_spi_phy(data) container_of(data, struct tpm_tis_spi_phy,\

Review all the EXPORT'd symbols and see if they are really necessary..
eg tpm_tis_ready(chip); is just chip->ops->cancel(chip)

Make sure you put the new obj-XX lines in Makefile in the correct
sorted position. Ditto for kconfig

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
