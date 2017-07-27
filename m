From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm-chip: Move idr_replace calls to
 appropriate places
Date: Thu, 27 Jul 2017 14:07:49 +0000
Message-ID: <016fe4c80f0c4b209ac2337500f9dd2b@MUCSE603.infineon.com>
References: <20170704135648.7360-1-Alexander.Steffen@infineon.com>
 <20170709212430.GB19327@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170709212430.GB19327-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index 67ec9d3..a353b7a 100644
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -327,11 +327,6 @@ static int tpm_add_char_device(struct tpm_chip
> *chip)
> >  		}
> >  	}
> >
> > -	/* Make the chip available. */
> > -	mutex_lock(&idr_lock);
> > -	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> > -	mutex_unlock(&idr_lock);
> 
> This is actually in the wrong place already, it needs to be done before
> cdev_device_add - this is because cdev_device_add generates the uevent to
> userspace which could trigger userspace to use the kernel device. So a patch
> to move it to the start of this function woud be good. The function would be
> better described as 'make visible'

I have looked again at the code and I am not sure this is an issue. The call to idr_replace is only necessary to enable in-kernel usage (i.e. RNG, IMA, ...) of the TPM, but it should not affect userspace in any way. So the location of the idr_replace call does not matter much, as long as the TPM is already initialized. In fact, the main purpose of this patch series (please see PATCH 3/3) is to export the device to userspace without calling idr_replace at all under some circumstances.

Or is there something I missed? The only function that ever tries to access the value stored by idr_replace is tpm_chip_find_get. It is usually called with TPM_ANY_NUM, selecting any TPM that might be present. If no TPM is present (or if idr_replace has not been called) the caller needs to deal with the situation already.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
