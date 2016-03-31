From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: cleanup tpm_tis_remove()
Date: Thu, 31 Mar 2016 19:19:28 +0300
Message-ID: <20160331161928.GA8011@intel.com>
References: <1459419087-20487-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160331101536.GA20686@intel.com>
	<20160331101713.GB20686@intel.com>
	<20160331102958.GA22364@intel.com>
	<8646C2A85C5D44419E1B33F16B0BD501024AFA6B6E@SAFEX1MAIL1.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8646C2A85C5D44419E1B33F16B0BD501024AFA6B6E-+EwDPpWUVoThJTuQ9jeba9BPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Henri RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 31, 2016 at 04:55:50PM +0200, Christophe Henri RICARD wrote:
> Tested-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Thanks. This is quite on brainer cleanup and since it is peer tested you
should be able safely rebase your patch set on top of it. It's applied
to my master branch.

/Jarkko

> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org] 
> Sent: jeudi 31 mars 2016 12:30
> To: Christophe Henri RICARD
> Cc: Marcel Selhorst; Jason Gunthorpe; moderated list:TPM DEVICE DRIVER; open list; Peter Huewe
> Subject: Re: [PATCH] tpm: cleanup tpm_tis_remove()
> 
> On Thu, Mar 31, 2016 at 01:17:13PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Mar 31, 2016 at 01:15:36PM +0300, Jarkko Sakkinen wrote:
> > > Christophe,
> > > 
> > > On Thu, Mar 31, 2016 at 01:11:27PM +0300, Jarkko Sakkinen wrote:
> > > > Created a local variable for the register in order to clean up 
> > > > experession where TPM_GLOBAL_INT_ENABLE is cleared. This 
> > > > expression is horrible to read and makes changing the function 
> > > > uncomfortable because like easily surpass 80 characters.
> > > 
> > > Can you test this patch your hardware and reply with Tested-by tag 
> > > if it does? I can then update your iobase patch to apply on top of this.
> > > 
> > > I thought it was better idea to simplify the expression a little bit 
> > > than make it even worse mess.
> > 
> > And yes  I'll fix all the typos in the commit msg in this patch before 
> > applying it :)
> 
> I committed this to my master branch with the option to drop if there it does not get reviewed/tested-by's (which I doubt). Since this touches multiple patches (locality patch too) and in addition there was couple glitches maybe it would be good if you would prepare one more round of the series if you don't mind?
> 
> /Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
