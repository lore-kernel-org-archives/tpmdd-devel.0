From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: About the SLB9670 TPM 2.0 driver status
Date: Wed, 26 Apr 2017 16:04:27 +0000
Message-ID: <a5616ca471a64e5ab4809a231966987b@MUCSE603.infineon.com>
References: <e7ee0491-3f29-5578-7cc4-af9c0a73dcb3@witekio.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <e7ee0491-3f29-5578-7cc4-af9c0a73dcb3-svHpOmPGTvqcqzYg7KEe8g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: gsavoundararadj-svHpOmPGTvqcqzYg7KEe8g@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> I am working with on Infineon SLB9670 TPM 2.0 on SPI.
> 
> How well is this chip supported in the mainline kernel?

Unfortunately, due to some small bugs, tpm_tis_spi in mainline is not yet compatible with this device. Starting with 4.12 it should be properly supported.

> I am currently using the linux-socfpga kernel (version 4.8.0; branch
> socfpga-4.8) [1]
> on which I applied the following patches from patchwork:
> 
> aacabbe0d5ec tpm_tis_spi: Add small delay after last transfer [2]
> a4a011be786f tpm_tis_spi: Remove limitation of transfers to
> MAX_SPI_FRAMESIZE bytes [3]
> 840157e08b2f tpm_tis_spi: Check correct byte for wait state indicator [4]
> 10cb31aec536 tpm_tis_spi: Abort transfer when too many wait states are
> signaled [5]
> 3ad7d9172a8c tpm_tis_spi: Use single function to transfer data [6]
> 4a809ec34a0f tpm_tis_core: Choose appropriate timeout for reading
> burstcount [7]
> 
> With these patches, I can read the Vendor ID properly.

Those are all the patches that I needed on a Raspberry Pi 2 for the device to work correctly. I did not use 4.8 though, but worked with 4.10.

> But, the driver initialization fails in the tpm2_probe function.

Could you be more specific? What exactly fails? What data is transferred to/from the TPM when it fails?

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
