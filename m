From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Mon, 11 Apr 2016 14:28:11 -0600
Message-ID: <20160411202811.GA3663@obsidianresearch.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160407123539.GA17489@intel.com>
	<57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201604111933.u3BJXErj001305-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 11, 2016 at 03:33:10PM -0400, Stefan Berger wrote:
>    If the intent is to get rid of the priv field, I am not sure whether we
>    can solve the problem this way.

We are not 'getting rid' of priv, the desire is to replace chip->priv with
dev_get_drvdata(&chip->dev), which is more consistent with the core driver
model.

> You may remember that the vtpm proxy driver only registers the chip
> once startup and retrieval of durations and timeouts successfully

Doesn't matter, just dev_set_drvdata right after the chip is
allocated, just like vtpm does already for chip->priv.

> If this patch is some form of cleanup, that may be a different
> story.

The issue with swapping in drvdata is that your patch series causes
the sysfs code to conflict with it here:

>    > @@ -36,7 +36,7 @@ static ssize_t pubek_show(struct device *dev,
>    > struct device_attribute *attr,
>    >     int i, rc;
>    >     char *str = buf;
>    >
>    > -   struct tpm_chip *chip = dev_get_drvdata(dev);
>    > +   struct tpm_chip *chip = to_tpm_chip(dev);

This broad outline is a different way for you to address the NULL
parent & sysfs issue by using optional symlinks instead. By doing this
it is no longer necessary to abuse drvdata in the core code.

ie your sysfs patch would not longer call drv_set_drvdata.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
