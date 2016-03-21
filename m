From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 08/12] tpm/tpm_tis: Split tpm_tis driver
 into a core and TCG TIS compliant phy
Date: Mon, 21 Mar 2016 17:26:09 -0600
Message-ID: <20160321232609.GB1516@obsidianresearch.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-9-git-send-email-christophe-h.ricard@st.com>
	<20160321013243.GA9417@obsidianresearch.com>
	<56F0774F.7040707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56F0774F.7040707-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> >On Sun, Mar 20, 2016 at 08:34:39PM +0100, Christophe Ricard wrote:
> >>+++ b/drivers/char/tpm/tpm.h
> >>@@ -142,6 +142,7 @@ struct tpm_vendor_specific {
> >>  	int region_size;
> >>  	int have_region;
> >>+	bool itpm;
> >>  	struct list_head list;
> >>  	int locality;
> >>@@ -149,6 +150,7 @@ struct tpm_vendor_specific {
> >>  	bool timeout_adjusted;
> >>  	unsigned long duration[3]; /* jiffies */
> >>  	bool duration_adjusted;
> >>+	bool irq_tested;
> >>  	void *priv;
> >No adding driver specific stuff to this structure.
> I suppose irq_tested is fine because it is common all drivers and related to
> irq management. I guess it can be moved below irq field.

No, we are trying to get rid of the vendor_specific structure, it is a
mistake.

You need to add some kind of new structure shared between the tpm_tis
shared code and the tpm_tis phy code. Put all this stuff there. If it
isn't used by the core code it should not be in the core structures.

> I somewhat understand your mean for itpm.
> I believe it is specific for the legacy/lpc/0xfed4xxxx addressing mode. Can
> you confirm ?

Yes, there is a specific device with bad behavior that detects.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
