From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Mon, 25 Jan 2016 20:19:19 -0700
Message-ID: <20160126031919.GA24217@obsidianresearch.com>
References: <20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<20160126014652.GB10732@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160126014652.GB10732-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 25, 2016 at 05:46:52PM -0800, Jarkko Sakkinen wrote:
> > The only issue is error unwind, the tpmm version assumes devm works
> > for that, but the vtpm_dev will not be destroyed if the tpm attach
> > fails, do devm is not appropriate.
> 
> At the moment tpmm_chip_alloc() does not use devm for anything. Are you
> speaking about stuff that happens between alloc and register as some of
> the drivers use devm to associate resources to pdev at that point?

Ugh, well I missed that when you made those patches.

You need to put the devm back ASAP, as it is all the drivers now have
broken error handling. eg

static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
                        acpi_handle acpi_dev_handle)
[..]
        chip = tpmm_chip_alloc(dev, &tpm_tis);
[..]
        if (IS_ERR(chip))
	        return PTR_ERR(chip);
			
Obviously leaks chip.

The function is called tpmm_ specifically because it is supposed to
use devm resource unwind, it was a big mistake to remove the devm and
not rename the function or update the comments.

With the change to use a struct device the devm action should have
been a device_put to pair with the device_initialize.

> > As I said before the tpmm stuff was a hack I did to make it easier to
> > migrate the large number of drivers, core code should not be relying
> > on devm like that... One good option here would be unwind that a bit
> > and create a tpm_chip_alloc/tpm_chip_register flow that did not use
> > devm at all. That could be fairly straight forward..
> 
> AFAIK I implemented two phase initialization or are you talking about
> something else?

Right, I was confused because I wrote a different devm thing for TPM
that I discarded when I did the first rework.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
