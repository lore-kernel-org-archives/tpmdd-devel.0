From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Sat, 13 Feb 2016 10:39:11 -0500
Message-ID: <56BF4E1F.2030208@linux.vnet.ibm.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455321871-28296-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 02/12/2016 07:04 PM, Jason Gunthorpe wrote:
> This is a hold over from before the struct device conversion.
>
> - All prints should be using &chip->dev, which is the Linux
>    standard. This changes prints to use tpm0 as the device name,
>    not the PnP/etc ID.
> - The few places involving sysfs/modules that really do need the
>    parent just use chip->dev.parent instead
> - We no longer need to get_device(pdev) in any places since it is no
>    longer used by any of the code. The kref on the parent is held
>    by the device core during device_add and dropped in device_del
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---

> @@ -347,8 +347,8 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>    */
>   static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
>   {
> -	struct device *dev = chip->pdev;
> -	struct i2c_client *client = to_i2c_client(dev);
> +	struct device *dev = &chip->dev;
This looks wrong or are you fixing a bug here? chip->dev.parent ?
> +	struct i2c_client *client = to_i2c_client(chip->dev.parent);

Does this need to be replaced ?

     Stefan


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
