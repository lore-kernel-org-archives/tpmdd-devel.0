From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: fix bad name pointer usage with
 struct resource
Date: Tue, 16 Feb 2016 21:52:19 -0700
Message-ID: <20160217045219.GA26086@obsidianresearch.com>
References: <1455668874-13261-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455668874-13261-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 17, 2016 at 02:27:54AM +0200, Jarkko Sakkinen wrote:
> -	if (acpi_dev_resource_memory(ares, &res))
> +	if (acpi_dev_resource_memory(ares, &res)) {
> +		res.name = NULL;

What? How is this not a bug in acpi_dev_resource_memory? Maybe it
needs to memcpy into devm allocated memory instead, but I'm confused
how/why/when acpi could free name.

The same code exists in tpm_tis as well.

>  {
> -	struct resource new_res = {
> -		.start	= start,
> -		.end	= start + size - 1,
> -		.flags	= IORESOURCE_MEM,
> -	};
> +	struct resource new_res;
> +
> +	memset(&new_res, 0, sizeof(new_res));
> +
> +	new_res.start	= start;
> +	new_res.end	= start + size - 1;
> +	new_res.flags	= IORESOURCE_MEM;

These two things are equivalent (C requires non-initialized members of
an initalized struct to be 0), why this change?

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
