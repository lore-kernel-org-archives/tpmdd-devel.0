From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm-chip: Move idr_replace calls to
 appropriate places
Date: Sun, 9 Jul 2017 15:24:30 -0600
Message-ID: <20170709212430.GB19327@obsidianresearch.com>
References: <20170704135648.7360-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170704135648.7360-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 04, 2017 at 03:56:46PM +0200, Alexander Steffen wrote:
> According to the comments, adding/removing the chip from the list should be
> the first/last action in (un)register.

The comments are misleading..

> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 67ec9d3..a353b7a 100644
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -327,11 +327,6 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  		}
>  	}
>  
> -	/* Make the chip available. */
> -	mutex_lock(&idr_lock);
> -	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> -	mutex_unlock(&idr_lock);

This is actually in the wrong place already, it needs to be done
before cdev_device_add - this is because cdev_device_add generates the
uevent to userspace which could trigger userspace to use the kernel
device. So a patch to move it to the start of this function woud
be good. The function would be better described as 'make visible'

Maybe resend this patch with only that change..

>  {
>  	cdev_device_del(&chip->cdev, &chip->dev);
>  
> -	/* Make the chip unavailable. */
> -	mutex_lock(&idr_lock);
> -	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> -	mutex_unlock(&idr_lock);
> -

The placement of this does not matter so much, but keeping it after
the cdev_device_del is easier to understand as it matches the
(corrected) setup order..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
