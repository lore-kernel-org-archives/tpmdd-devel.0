From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: fix: associate to the correct
 device
Date: Sat, 5 Mar 2016 01:32:41 +0200
Message-ID: <20160304233241.GA25079@intel.com>
References: <1455708211-9653-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160218180331.GA7191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218180331.GA7191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 18, 2016 at 11:03:31AM -0700, Jason Gunthorpe wrote:
> > +	INIT_LIST_HEAD(&resources);
> > +	rc = acpi_dev_get_resources(device, &resources, crb_check_resource,
> > +				    priv);
> > +	if (rc < 0)
> > +		return rc;
> > +	acpi_dev_free_resource_list(&resources);
> 
> I wonder if the acpi_dev_free_resource_list is what kill's the
> resource name? Maybe that needs to be delayed until after the
> ioremap, which is best done with this back in crb_map_io  ??
> 
> Thanks for looking at this stuff,

I had almost forgotten this comment. I'll try this out as soon as
possible. Might well be the reason.

> Jason

/Jarkko

------------------------------------------------------------------------------
