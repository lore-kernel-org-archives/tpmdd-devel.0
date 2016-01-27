From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 11:48:38 -0800
Message-ID: <20160127194838.GA21857@intel.com>
References: <20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<20160126014652.GB10732@intel.com>
	<20160126031919.GA24217@obsidianresearch.com>
	<20160126135658.GA6813@intel.com>
	<20160126175816.GA17937@obsidianresearch.com>
	<20160127020617.GB22703@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160127020617.GB22703-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 26, 2016 at 06:06:17PM -0800, Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2016 at 10:58:16AM -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 26, 2016 at 05:56:59AM -0800, Jarkko Sakkinen wrote:
> > > On Mon, Jan 25, 2016 at 08:19:19PM -0700, Jason Gunthorpe wrote:
> > > > On Mon, Jan 25, 2016 at 05:46:52PM -0800, Jarkko Sakkinen wrote:
> > > > > > The only issue is error unwind, the tpmm version assumes devm works
> > > > > > for that, but the vtpm_dev will not be destroyed if the tpm attach
> > > > > > fails, do devm is not appropriate.
> > > > > 
> > > > > At the moment tpmm_chip_alloc() does not use devm for anything. Are you
> > > > > speaking about stuff that happens between alloc and register as some of
> > > > > the drivers use devm to associate resources to pdev at that point?
> > > > 
> > > > Ugh, well I missed that when you made those patches.
> > > > 
> > > > You need to put the devm back ASAP, as it is all the drivers now have
> > > > broken error handling. eg
> > > > 
> > > > static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
> > > >                         acpi_handle acpi_dev_handle)
> > > > [..]
> > > >         chip = tpmm_chip_alloc(dev, &tpm_tis);
> > > > [..]
> > > >         if (IS_ERR(chip))
> > > > 	        return PTR_ERR(chip);
> > > > 			
> > > > Obviously leaks chip.
> > > 
> > > Could you describe how it leaks a chip and what do you mean by verb
> > > "leak"?
> > 
> > It looks like you alread figured this out. release is never called, so
> > the kalloc for chip is never freed.
> > 
> > > > The function is called tpmm_ specifically because it is supposed to
> > > > use devm resource unwind, it was a big mistake to remove the devm and
> > > > not rename the function or update the comments.
> > > 
> > > The function does not reserve any resources using devm. Should it?
> > 
> > It originally did, but commit 313d21eeab9282e01fdcecd40e9ca87e0953627f
> > took it out and didn't change the function name.
> > 
> > The original version looked like:
> > 
> > struct tpm_chip *tpmm_chip_alloc(struct device *dev,
> >                                  const struct tpm_class_ops *ops)
> > {
> > [..]
> >         devm_add_action(dev, tpmm_chip_remove, chip);
> >         dev_set_drvdata(dev, chip);
> > 
> >         return chip;
> > }
> > 
> > > > With the change to use a struct device the devm action should have
> > > > been a device_put to pair with the device_initialize.
> > > 
> > > Well, I found a regression that is luckily a rare one.
> > 
> > It isn't rare, any error path will cause this.
> > 
> > > So now I do have regression that does show up. If you don't have it,
> > > it does not make sense to "fix" the code even if it looks obviously
> > > wrong.
> > 
> > That isn't the kernel way, this is very obviosly a bug, I don't need
> > to see 'proof' to know it needs fixing.

I have to defend my position here. Of course you have to proof in a way
or another that there is a regresssion. Otherwise you cannot speak that
there is a bug. It's by definition like that. I need to see the
regression in order to apply a bug fix to the tpmdd tree.

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
