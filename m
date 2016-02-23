From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 08/11] tpm:
 IntroduceTPM_CHIP_FLAG_VIRTUAL
Date: Mon, 22 Feb 2016 19:05:15 -0700
Message-ID: <20160223020515.GA26177@obsidianresearch.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222191922.GH22088@obsidianresearch.com>
	<201602230121.u1N1LYk2024786@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602230121.u1N1LYk2024786-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Mon, Feb 22, 2016 at 08:21:09PM -0500, Stefan Berger wrote:
> 
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016 02:19:22
> PM:
> 
> 
> > > +
> > > +   if (!(chip->flags & TPM_CHIP_FLAG_VIRTUAL))
> > > +      err = sysfs_create_group(&chip->dev.parent->kobj,
> > > +                &tpm_dev_group);
> > > +   else
> > > +      chip->groups[chip->groups_cnt++] = &tpm_dev_group;
> >
> > For other reviewers: The intent here is to make another patch that
> > moves the main sysfs to only use groups with symlinks link ppi does
> > now.
> >
> > Does sysfs work with vtpm? I am worried about dev_get_drvdata here
> > (and other places):
> 
> Yes, works. I have a set_drv_data in the vtpm driver.

?? I don't see that in the vtpm patch posted to the list? Can you
point me to it?

In any event, the core code should be self contained and not rely on
things in the drivers like this.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
