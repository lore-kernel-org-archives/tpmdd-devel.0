From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/12] Rework of tpm_tis to share
 common logic accross phy's (lpc/spi/-i2c-)
Date: Wed, 20 Apr 2016 08:52:11 +0200
Message-ID: <5717271B.7000502@gmail.com>
References: <1460788542-2455-1-git-send-email-christophe-h.ricard@st.com>
	<20160418172352.GB13979@obsidianresearch.com>
	<5715BDFF.5000702@gmail.com>
	<20160419175906.GB26460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160419175906.GB26460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 19/04/2016 19:59, Jason Gunthorpe wrote:
> On Tue, Apr 19, 2016 at 07:11:27AM +0200, Christophe Ricard wrote:
>> Please have a look to:
>> https://github.com/cricard13/linux-tpmdd
> Okay, looking at how everything ended up..
>
> The indentation in tpm_tis_core.h should be fixed up.
I am not sure where you are seeing indentation issues in v4 ?
> These:
>
>   static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
>   				  u8 *result)
>
> Should not take a 'chip' as an argument, they only work with tpm_tis
> devices, so they should take tpm_tis_data as an argument. Same with
> the ops. Typesafety for correctness..
Ok
>
> Why is release_localtity exported but request_locality is not? There
> is something really wonky looking with how that locality stuff works.
request_locality is called in tpm_tis_send_data.
The fact is that to run itpm workaround, we need to execute 
tpm_tis_send_data, tpm_tis_ready and release_locality.

To answer to the remaining point i see 3 possibles options:
- implement in tpm_tis.c a tpm_tis_release that would execute the 
equivalent sequence of tpm_tis_ready and release_locality.
It would avoid to export those functions.
- rename release_locality tpm_tis_release_locality as per your previous 
request... Sorry for that :(.
- Implement a specific tpm_tis_release exported function in tpm_tis_core 
that would execute tpm_tis_ready/release_locality.

My personal choice would go for options 2 and rename release_locality 
tpm_tis_release_locality.

Another option would be to remove this workaround but i don't think it 
is the solution ;).

> I wonder if the itpm detection routine should move to the core code?
> It uses so many internal functions it isn't all that nice to have them
> exported just for that. A phy could have a flag TPM_TIS_ITPM_POSSIBLE
> to turn it on.
So actually that's where "the pain" came from... How to manage the itpm 
workaround in
a phy specific layer in a clean way ?
To my mind, the realistic goal was to provide a specific handle for 
proprietary post probing steps.
I hope this workaround will not be required for future "itpm" running on 
spi, i2c and such.
> No to stuff like this:
>
> 	/* Check SPI platform functionnalities */
> 	if (!dev) {
> 		pr_err("%s: dev is NULL. Device is not accessible.\n",
> 				__func__);
> 		return -ENODEV;
> 	}
Ok
>
> The core has a tpm_tis_remove function, but the spi driver doesn't
> call it, that looks wrong.
Yes it is wrong i got it fixed for a newer version. :)
> Use inlines functions:
>   #define to_tpm_tis_spi_phy(data) container_of(data, struct tpm_tis_spi_phy,\
ok
> Review all the EXPORT'd symbols and see if they are really necessary..
> eg tpm_tis_ready(chip); is just chip->ops->cancel(chip)
Yes. I think the most discussible EXPORT'd symbols now are 
tpm_tis_send_data and release_locality.
I gave some input above
> Make sure you put the new obj-XX lines in Makefile in the correct
> sorted position. Ditto for kconfig
ok
>
> Jason


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
