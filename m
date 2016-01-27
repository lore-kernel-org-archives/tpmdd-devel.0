From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 06:23:46 -0800
Message-ID: <20160127142346.GB3756@intel.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31hLD018933@d03av02.boulder.ibm.com>
	<20160127025057.GB23863@intel.com>
	<201601271220.u0RCKpEG016626@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601271220.u0RCKpEG016626-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 27, 2016 at 07:20:48AM -0500, Stefan Berger wrote:
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/26/2016 09:50:57
> PM:
> 
> 
> >
> > On Wed, Jan 20, 2016 at 10:01:38PM -0500, Stefan Berger wrote:
> > > > Except that isn't good enough - the IMA kernel side doesn't knowthat this
> > > > tpm is now acting as the 'main' 'default' TPM.
> > >
> > > Hooking the vTPM to IMA requires another patch that I haven't
> > shown since IMA
> > > namespacing isn't public yet. Basically we implement another ioctl
> > () that is to
> > > be called before the clone() in order to 'reserve' a vtpm device
> > pair for the
> > > calling process. During the clone() call IMA namespacing code can query the
> > > vTPM driver for a 'reserved' device pair. Hooking IMA up after the
> > clone() may
> > > also work but in case of docker/golang it's better to do this
> > before since the
> > > language libraries do a lot after the clone automatically.
> >
> > Can we expect that "in the end" there will be a single patch set that
> > contains both TPM and IMA changes? Otherwise, I see it very hard to make
> > decision to apply TPM patches.
> 
> If this can be posted to the same lists, then 'yes'. I cannot set a timeframe
> for this, though. Nevertheless, the vTPM driver reviews were fruitful, I think.

Thanks, this is good to hear.

> The vTPM driver could be used standalone as well, though it may be more useful
> in conjunction with the namespacing of IMA.
> 
> Stefan

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
