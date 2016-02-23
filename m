From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 07/11] tpm: Replace device number
 bitmap with IDR
Date: Mon, 22 Feb 2016 19:16:06 -0700
Message-ID: <20160223021606.GC26177@obsidianresearch.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222190629.GE22088@obsidianresearch.com>
	<201602230116.u1N1G4iu012263@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602230116.u1N1G4iu012263-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Mon, Feb 22, 2016 at 08:15:38PM -0500, Stefan Berger wrote:
> > - Tear down /dev/tpmX, sysfs and all other user accessible entry
> >   points
> > - Do device_del (get rid of all the sysfs stuff)
> > - NULL the IDR (disables kAPI access and allow reuse of the ID)
> > - NULL the ops (flush in-progress access now that new access is impossible)
> 
> Why NULL the ops so late and allow access even after device_del? I'd do that at
> the beginning.

It absolutely has to be done as the very last thing.

None of the sysfs code checks ops, and thus can't fail on null ops
(see the comment I added in the ops patch in tpm-sysfs). All sysfs
must be rendered inaccessible and all in-progress accesses must be
completed before we attempt to drop ops.

Since we are moving to using chip->groups to register sysfs a full
device_del seems necessary to fully fence sysfs access.

> Also the IDR has a two-stages:
>  one making the chip inaccessible on the idr : idr_replace(&dev_nums_idr, NULL,
> chip->dev_num)
>  the other one by freeing the IDR for re-use : idr_remove(&dev_nums_ir, chip->
> dev_num)

Oh, I missed that, yes, that is the way to go for the IDR part,
do the idr_remove after device_del.

If you set to null I expect that means the while loop example I gave
will need adjusting.

> - Free the chip's device number from the IDR (makes IDR re-usable; must happen
> after /dev/tpmX is released to avoid clashes

With this new arrangment the idr_remove can happen directly after
device_del and we can avoid the intermediate state of a NULL'd entry,
which seems slightly simplifying. Before there was the problem because
vtpm was using a struct device, but that is gone now.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
