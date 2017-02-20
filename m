From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Mon, 20 Feb 2017 12:47:47 +0200
Message-ID: <20170220104747.dsp3ugixnqfmj6fi@intel.com>
References: <20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
	<CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
	<5B8DA87D05A7694D9FA63FD143655C1B54395CD5@hasmsx108.ger.corp.intel.com>
	<20170217164332.GB30677@obsidianresearch.com>
	<1487356105.6424.1.camel@intel.com>
	<20170217190125.GA5984@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170217190125.GA5984-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 17, 2017 at 12:01:25PM -0700, Jason Gunthorpe wrote:
> > I would rather review a patch with proper commit message than just pick
> > from an email thread in all cases with a proper explanation what the
> > patch does and why it is the right way to fix the issue.
> 
> Of course, but I am waiting for Davide to say the approach even works
> ..
> 
> Jason

I'm not sure what would be a good function name but maybe something
that would state that this is not status quo but workaround for a
bug. Since I do not have any better suggestion keep the current
name if nothing comes up.

Probably a dev_err message would make sense here to state in klog
that something is wrong in the BIOS.

Since there are multiple people complaining about the issue I will
take this workaround even if the BIOS is fixed.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
