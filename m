From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] tmp/tpm_crb: fix Intel PTT hw bug
 during idle state
Date: Wed, 7 Sep 2016 21:21:34 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CBAD4@hasmsx108.ger.corp.intel.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-3-git-send-email-tomas.winkler@intel.com>
	<20160907161744.GB4791@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160907161744.GB4791-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> 
> On Wed, Sep 07, 2016 at 02:32:32PM +0300, Tomas Winkler wrote:
> >  	INIT_LIST_HEAD(&resources);
> > -	ret = acpi_dev_get_resources(device, &resources,
> crb_check_resource,
> > -				     &io_res);
> > +	ret = acpi_dev_get_resources(device, &resources,
> > +				     crb_check_resource, &io_res);
> 
> Do not randomly reflow unrelated text in patches

It wasn't random, who breaks code like that... 
 
> > +	/*
> > +	 * PTT HW bug w/a: wake up the device to access
> > +	 * possibly not retained registers.
> > +	 */
> > +	ret = __crb_cmd_ready(dev, priv);
> > +	if (ret)
> > +		return ret;
> > +
> > +	pa_high = ioread32(&priv->cca->cmd_pa_high);
> > +	pa_low  = ioread32(&priv->cca->cmd_pa_low);
> > +	cmd_pa = ((u64)pa_high << 32) | pa_low;
> 
> Why change from the original hunk?


This is where the bug is visible... I'll put the debug print back it might be useful. 
  
>  -	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
>  -		  (u64) ioread32(&priv->cca->cmd_pa_low);
> 
> >  	priv->rsp = priv->cmd;
> > +
> > +out:
> > +	__crb_go_idle(dev, priv);
> >  	return 0;
> 
> Nope on the return 0.. return ret I guess?

Right, good catch.



------------------------------------------------------------------------------
