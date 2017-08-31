From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/2] tpm_tis_spi: Use DMA-safe memory
Date: Thu, 31 Aug 2017 12:34:33 +0000
Message-ID: <6b67f719b71e4eb8abd2ba8b3ed57560@MUCSE603.infineon.com>
References: <20170824082745.9372-1-Alexander.Steffen@infineon.com>
 <20170826112259.ypwtqbwakyfdqkzo@linux.intel.com>
 <9aea582eccbe4655b5de487dacf7c745@MUCSE603.infineon.com>
 <fe81962beaec4c6fa21ea90df0f01560@SFHDAG3NODE3.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <fe81962beaec4c6fa21ea90df0f01560-tklXXlf0F76qZDvoWP1BVkEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: benoit.houyere-qxv4g6HH51o@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> Hi Alexander,
> 
> Obviously, we agree to cover validation with STM TPM to confirm your
> update.
> Following my availability, I cannot start it before mid of September. Is it inline
> with your expectation ?

As always, better than nothing, thanks :)

> If it's the case, I will start :
> - tpm_tis_spi on Raspberry PI 3
> Next
> - tpm_tis on X86_64

Those patches only change tpm_tis_spi, so you can skip the tests with tpm_tis.

> Could you send me patch file or link to get patch ?

Unfortunately, Patchwork is not working anymore, so I'll send you the patches in a separate mail.

> By taking Raspberry PI 3 example, How many Byte in SPI transfer size is
> necessary to use DMA transfer ?

The Raspberry Pi 3 uses drivers/spi/spi-bcm2835.c, which defines BCM2835_SPI_DMA_MIN_LENGTH = 96 bytes. The maximum frame size used by tpm_tis_spi is MAX_SPI_FRAMESIZE = 64 bytes, so the DMA code path is never taken. You could try to set BCM2835_SPI_DMA_MIN_LENGTH to a lower value, to force it to use DMA.

> Best Regards,
> 
> Benoit

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
