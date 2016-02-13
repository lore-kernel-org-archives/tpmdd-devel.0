From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm: Hold the kref during
	tpm_chip_find_get
Date: Sat, 13 Feb 2016 12:08:18 +0200
Message-ID: <20160213100818.GA12607@intel.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455321871-28296-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 05:04:29PM -0700, Jason Gunthorpe wrote:
> This was missed during the struct device conversion, we
> need to hold a kref on the chip to make sure it isn't freed.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1560MoZ6SYplyIw@public.gmane.org>

For rest of the patches I'll look at them post-v4.5. I'm still waiting
for my first pull request containing fixes for that release to be
taken.

James, would it be possible to take the pull request containing fixes
soon that I origianally sent already in Jan and bit updated version
few days ago [1]? I still have one more pull request coming after that. It will
contain only few line changes:

* Missing put_device() in two places.
* There is a small change to ABI behavior (I'll post it
  soon) of policy sealing so I really need it for this release because
  4.5 is the first release containing this feature and I cannot change
  it when the release is tagged.

Thank you.

[1] http://www.gossamer-threads.com/lists/linux/kernel/2366902

/Jarkko


> ---
>  drivers/char/tpm/tpm-chip.c | 2 ++
>  drivers/char/tpm/tpm.h      | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 45cc39aabeee..ae2fed8a162b 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -53,6 +53,8 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
>  			chip = pos;
>  			break;
>  		}
> +
> +		get_device(&chip->dev);
>  	}
>  	rcu_read_unlock();
>  	return chip;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 542a80cbfd9c..f6ba79d91857 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -207,6 +207,7 @@ struct tpm_chip {
>  static inline void tpm_chip_put(struct tpm_chip *chip)
>  {
>  	module_put(chip->pdev->driver->owner);
> +	put_device(&chip->dev);
>  }
>  
>  static inline int tpm_read_index(int base, int index)
> -- 
> 2.1.4
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
