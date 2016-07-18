From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: support driver-specific sysfs
 attrs in tpm_tis_core
Date: Mon, 18 Jul 2016 22:20:35 +0300
Message-ID: <20160718192035.GQ31463@intel.com>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
	<1468547496-16215-3-git-send-email-apronin@chromium.org>
	<20160715032327.GF9347@obsidianresearch.com>
	<20160715033530.GB27104@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715033530.GB27104@apronin>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 08:35:30PM -0700, Andrey Pronin wrote:
> On Thu, Jul 14, 2016 at 09:23:27PM -0600, Jason Gunthorpe wrote:
> > On Thu, Jul 14, 2016 at 06:51:36PM -0700, Andrey Pronin wrote:
> > > -	WARN_ON(chip->groups_cnt != 0);
> > 
> > Nope.
> > 
> > > -	const struct attribute_group *groups[3];
> > > +	/* up to 4 attribute groups:
> > > +	 * - driver-specific
> > > +	 * - common TPM1.2 and TPM2.0
> > > +	 * - TPM1.2/2.0-specific
> > > +	 * - ppi
> > > +	 */
> > > +	const struct attribute_group *groups[5];
> > 
> > The prior patch needed to have groups[4], every patch much work.
> > 
> > > +	if (priv->phy_ops->attr_group)
> > > +		chip->groups[chip->groups_cnt++] = priv->phy_ops->attr_group;
> > 
> > I am really not excited about having driver specific sysfs
> > files.
> > 
> > What is the justification for this?
> > 
> > Jason
> 
> Justification: give access to vendor-specific properties that are
> specific to a particular chip and its registers.

Please come with a vendor specific property or have this part of a
series where the need becomes somehow obvious so that we can talk about
a real problem and not in an abstract level.

Making user API vendor wobbling is almost over my dead body type of
thing but given the context there might be alternatives to consider.

I honestly don't understand why this was even bundled with TPM2 patch.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
