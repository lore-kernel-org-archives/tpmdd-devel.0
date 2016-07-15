From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: add sysfs attributes for tpm2
Date: Thu, 14 Jul 2016 20:32:01 -0700
Message-ID: <20160715033201.GA27104@apronin>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
	<1468547496-16215-2-git-send-email-apronin@chromium.org>
	<20160715032145.GE9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715032145.GE9347-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Thu, Jul 14, 2016 at 09:21:45PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 06:51:35PM -0700, Andrey Pronin wrote:
> > -	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
> > -
> > -	for (i = chip->groups[0]->attrs; *i != NULL; ++i)
> > -		sysfs_remove_link(&chip->dev.parent->kobj, (*i)->name);
> > +	for (ngrp = 0; ngrp < chip->groups_cnt; ++ngrp) {
> > +		if (chip->groups[ngrp]->name) {
> > +			sysfs_remove_link(&chip->dev.parent->kobj,
> > +					  chip->groups[ngrp]->name);
> > +		} else {
> > +			for (i = chip->groups[ngrp]->attrs; *i != NULL; ++i)
> > +				sysfs_remove_link(&chip->dev.parent->kobj,
> > +						  (*i)->name);
> > +		}
> > +	}
> 
> NAK
> 
> No new compat symlinks. Only the existing set of links are permitted.
> 
> Any new sysfs entries must use only the new location.
> 
> > +static struct attribute *tpm2_dev_attrs[] = {
> >  	NULL,
> >  };
> 
> > +static const struct attribute_group tpm2_dev_group = {
> > +	.attrs = tpm2_dev_attrs,
> > +};
> 
> Don't add dead code, add this and related in the patch that requires it.
> 
> >  void tpm_sysfs_add_device(struct tpm_chip *chip)
> >  {
> >  	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
> > @@ -290,4 +306,8 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
> >  	 */
> >  	WARN_ON(chip->groups_cnt != 0);
> >  	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		chip->groups[chip->groups_cnt++] = &tpm2_dev_group;
> > +	else
> > +		chip->groups[chip->groups_cnt++] = &tpm1_dev_group;
> 
> .. and this can't really happen either..
> 
> To make things simple you can just have tpm2 not ever create any links
> for any files by never using groups[0]. There is no need to try and
> create a shared 'tpm_dev_group'.
> 
> Jason

Hi Jason,

Mostly understood. One question.

tpm2 shares some of the attributes with tpm1 (e.g. timeouts). Do I still
just add those separately for tpm2 to groups[1] and keep groups[0] empty?

Andrey


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
