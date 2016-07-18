From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm_tis_core: add optional max xfer
	size check
Date: Mon, 18 Jul 2016 21:53:27 +0300
Message-ID: <20160718185327.GJ31463@intel.com>
References: <1468546745-14646-1-git-send-email-apronin@chromium.org>
	<1468546745-14646-2-git-send-email-apronin@chromium.org>
	<20160715031351.GD9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715031351.GD9347-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 09:13:51PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 06:39:04PM -0700, Andrey Pronin wrote:
> 
> > +static inline u16 tpm_tis_max_xfer_size(struct tpm_tis_data *data)
> > +{
> > +	return data->phy_ops->max_xfer_size;
> > +}
> > +
> > +static inline bool tpm_tis_burstcnt_is_valid(struct tpm_tis_data *data,
> > +					     u16 burstcnt)
> > +{
> > +	return (tpm_tis_max_xfer_size(data) == 0)
> > +		|| (burstcnt <= tpm_tis_max_xfer_size(data));
> > +}
> 
> We don't need these accessors, just open code it in the one call
> site. That is more clear as the ==0 case is important to understand
> that the flow is correct.

+1 They add only indirection here with no value.


> BTW, I dodn't think || as the start of a line was cannonical kernel
> style.. Did checkpatch accept that?
> 
> Jason

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
