From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 07/11] tpm: Replace device number
	bitmap with IDR
Date: Mon, 22 Feb 2016 12:06:29 -0700
Message-ID: <20160222190629.GE22088@obsidianresearch.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455885728-10315-8-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 19, 2016 at 07:42:04AM -0500, Stefan Berger wrote:
> +	if (chip_num == TPM_ANY_NUM)
> +		chip_next = 0;
> +
> +	mutex_lock(&idr_lock);
> +
> +	do {
> +		if (chip_num == TPM_ANY_NUM) {
> +			chip_prev = chip_next;
> +			chip = idr_get_next(&dev_nums_idr, &chip_next);
> +		} else
> +			chip = idr_find_slowpath(&dev_nums_idr, chip_num);
> +
> +		if (chip && !tpm_try_get_ops(chip))
> +			break;
> +	} while (chip_num == TPM_ANY_NUM && chip_prev != chip_next);

This while loop doesn't look very good if tpm_try_get_ops fails?

Maybe like this?

struct tpm_chip *tpm_chip_find_get(int chip_num)
{
	struct tpm_chip *res = NULL;

	mutex_lock(&idr_lock);

	if (chip_num == TPM_ANY_NUM) {
		struct tpm_chip *chip;

		chip_num = 0;
		do {
			chip = idr_get_next(&dev_nums_idr, &chip_num);
			if (res && !tpm_try_get_ops(chip)) {
				res = chip;
				break;
			}
		}
		while (chip);
	} else {
		res = idr_find_slowpath(&dev_nums_idr, chip_num);
		if (res && tpm_try_get_ops(chip))
			res = NULL;
	}

	mutex_unlock(&idr_lock);

	return res;
}

> +	if (err < 0) {
>  		dev_err(dev, "No available tpm device numbers\n");

I would drop the dev_err too

> @@ -247,12 +253,6 @@ static int tpm_dev_add_device(struct tpm_chip *chip)
>  static void tpm_dev_del_device(struct tpm_chip *chip)
>  {
>  	cdev_del(&chip->cdev);
> -
> -	/* Make the driver uncallable. */
> -	down_write(&chip->ops_sem);
> -	chip->ops = NULL;
> -	up_write(&chip->ops_sem);
> -
>  	device_del(&chip->dev);

Hum.. The ordering here is very important, I guess I got it slightly
wrong as well in my patch adding ops.

Lets go for this:

- Tear down /dev/tpmX, sysfs and all other user accessible entry
  points
- Do device_del (get rid of all the sysfs stuff)
- NULL the IDR (disables kAPI access and allow reuse of the ID)
- NULL the ops (flush in-progress access now that new access is impossible)
- put_device to kfree (via devm)

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
