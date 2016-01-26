From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Mon, 25 Jan 2016 16:29:31 -0800
Message-ID: <20160126002931.GA18126@intel.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160115101146.GA11987@intel.com>
	<201601151302.u0FD2wGG003518@d03av03.boulder.ibm.com>
	<20160125231532.GA10732@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160125231532.GA10732-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 25, 2016 at 03:15:32PM -0800, Jarkko Sakkinen wrote:
> On Fri, Jan 15, 2016 at 08:02:52AM -0500, Stefan Berger wrote:
> > Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/15/2016 05:11:46
> > AM:
> > 
> > >
> > > On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Berger wrote:
> > > > From: Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>
> > > >
> > > > The following series of patches implements a multi-instance vTPM driver
> > > > that can dynamically create TPM 'server' and client device pairs.
> > > >
> > > > Using ioctl's on the provided /dev/vtpmx, a server and a client
> > > > side vTPM device can be created. The server side offers a /dev/vtpms%d
> > > > device and a TPM emulator must be started on it to listen for TPM commands
> > > > that are written to /dev/vtpmc%d, which is created by the core TPM driver.
> > > >
> > > > The primary goal of this series of patches is enabling vTPM for containers
> > > > and hooking them up to a (future) namespaced IMA. However, the driver can
> > > > also be used for simulating a hardware TPM on the host.
> > > >
> > > > The last patch provides a test program for controlling device pairs.
> > >
> > > I like the idea. Looking into this in more detail after the next pull
> > > request. Thanks!
> > 
> > Thank you. I actually found some issues in the code yesterday, so I eventually
> > will need to repost.
> > I may put the latest on a public git repo in case someone wants to test.
> 
> I haven't yet reviewed the first version nor read the discussion you and
> Jason have had (except for some distinct emails). The main reasons is
> that I haven't received any feedback to some questions I've asked... One
> of the most important has been is there any documentation for vTPM?

I drown myself into shame. I thought this was somehow associated with
the ibmvtpm driver but this a separate driver. I just started to read
the code. My humblest apologies! I have to admit that I haven't been
too well on track with this.

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
