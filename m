From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: About the SLB9670 TPM 2.0 driver status
Date: Wed, 26 Apr 2017 13:37:40 +0300
Message-ID: <20170426103740.b5fdgrezwq35hnnz@intel.com>
References: <e7ee0491-3f29-5578-7cc4-af9c0a73dcb3@witekio.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e7ee0491-3f29-5578-7cc4-af9c0a73dcb3-svHpOmPGTvqcqzYg7KEe8g@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Georges Savoundararadj <gsavoundararadj-svHpOmPGTvqcqzYg7KEe8g@public.gmane.org>
Cc: peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 25, 2017 at 07:12:25PM -0700, Georges Savoundararadj wrote:
> Hello,
> 
> I am working with on Infineon SLB9670 TPM 2.0 on SPI.
> 
> How well is this chip supported in the mainline kernel?
> 
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
> But, the driver initialization fails in the tpm2_probe function.
> 
> Did I miss an important patch?
> 
> Regards,
> 
> Georges

Please try it out with the mainline kernel. Thank you.

> [1] https://github.com/altera-opensource/linux-socfpga/tree/socfpga-4.8
> [2] https://patchwork.kernel.org/patch/9600213/
> [3] https://patchwork.kernel.org/patch/9600209/
> [4] https://patchwork.kernel.org/patch/9600207/
> [5] https://patchwork.kernel.org/patch/9600211/
> [6] https://patchwork.kernel.org/patch/9600203/
> [7] https://patchwork.kernel.org/patch/9682259/

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
