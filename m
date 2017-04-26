From: Georges Savoundararadj <gsavoundararadj-svHpOmPGTvqcqzYg7KEe8g@public.gmane.org>
Subject: Re: About the SLB9670 TPM 2.0 driver status
Date: Wed, 26 Apr 2017 11:47:51 -0700
Message-ID: <39067149-b6e1-04e2-7677-5dc054475140@witekio.us>
References: <e7ee0491-3f29-5578-7cc4-af9c0a73dcb3@witekio.us>
	<a5616ca471a64e5ab4809a231966987b@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <a5616ca471a64e5ab4809a231966987b-nFblLGNE8XKJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Alexander,


On 04/26/2017 09:04 AM, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
>> I am working with on Infineon SLB9670 TPM 2.0 on SPI.
>>
>> How well is this chip supported in the mainline kernel?
> Unfortunately, due to some small bugs, tpm_tis_spi in mainline is not yet compatible with this device. Starting with 4.12 it should be properly supported.
Sounds good!
>
>> I am currently using the linux-socfpga kernel (version 4.8.0; branch
>> socfpga-4.8) [1]
>> on which I applied the following patches from patchwork:
>>
>> aacabbe0d5ec tpm_tis_spi: Add small delay after last transfer [2]
>> a4a011be786f tpm_tis_spi: Remove limitation of transfers to
>> MAX_SPI_FRAMESIZE bytes [3]
>> 840157e08b2f tpm_tis_spi: Check correct byte for wait state indicator [4]
>> 10cb31aec536 tpm_tis_spi: Abort transfer when too many wait states are
>> signaled [5]
>> 3ad7d9172a8c tpm_tis_spi: Use single function to transfer data [6]
>> 4a809ec34a0f tpm_tis_core: Choose appropriate timeout for reading
>> burstcount [7]
>>
>> With these patches, I can read the Vendor ID properly.
> Those are all the patches that I needed on a Raspberry Pi 2 for the device to work correctly. I did not use 4.8 though, but worked with 4.10.
>
>> But, the driver initialization fails in the tpm2_probe function.
> Could you be more specific? What exactly fails? What data is transferred to/from the TPM when it fails?
I tried again on the 4.11-rc8 kernel with the latest patches from 
linux-tpmdd to be integrated in 4.12 (between tpmdd-next-20170220 and 
tpmdd-next-20170425) and I got the same failure.

The following function calls fails
* tpm2_probe
** tpm_transmit_cmd
*** tpm_transmit
**** chips->ops->send/tpm_tis_send
***** tpm_tis_send_main
****** tpm_tis_send_data

tpm_tis_send_data fails at this moment when it checks the status:

     status = tpm_tis_status(chip);
     if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
         rc = -EIO;
         goto out_err;
     }

The data transferred is the command defined in the tpm2_probe function.

Thanks,

Georges
>
> Alexander


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
