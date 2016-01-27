From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 06:22:39 -0800
Message-ID: <20160127142239.GA3756@intel.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdGB9031710@d01av04.pok.ibm.com>
	<20160127023603.GA23863@intel.com>
	<201601271217.u0RCHQIX004914@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601271217.u0RCHQIX004914-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Jan 27, 2016 at 07:17:17AM -0500, Stefan Berger wrote:
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/26/2016 09:36:03
> PM:
> 
> >
> > On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
> > > > Presumably some namespace magic can be used to make them show up as
> > > > tpm0 in a container?
> > >
> > > The magic is to have the container management stack create the device pair.
> > > From the ioctl it learns the name of the devices that were created
> > and it then
> > > finds out about the major/minor number of the created device and
> > have /dev/tpm0
> > > with that major/minor created in the container's /dev directory.
> >
> > Is the device created before container launched? I would assume that
> > this would work user space accesses through /dev/tpm0.
> 
> Yes, device would be created before container is launched.
> 
> >
> > I don't know how this would work for kernel clients.
> 
> For IMA we have these additional ioctls to either 'reserve' a vTPM for a
> container before clone() or to hook the vTPM up to a IMA namespace after clone
> () -- you may have read the discussions about these in other emails. As for
> trusted and encrypted keys and the TPM based RNG, the kernel determines the
> current IMA namespace a process that wants to use the kernel service is
> associated with. It then uses the TPM associated with the IMA namespace or
> returns an error if there is none.

Yeah, I now have read the discussion but I still don't fully understand
this. I spent 2-3 hours yesterday reading it and frankly don't want do
it again. If I ask something that was already hidden somewhere there,
I just didn't get it.

If this applies to other kernel services than IMA, why this feature is
called IMA namespace?

I.e. as far as I can understand your description you could:

1. Use this feature without using IMA. Create namespace and apply TPM
   emulator or software implementation of TPM (you could do this for
   example with SGX).
2. Use this feature without TPM. Just create namespace and use IMA
   there.

"TPM namespace" that popped out in your and Jaosns discussion and also
"IMA namespace" both seem not to describe what is being developed.

Also, I'm wondering is it right to have this as a separate module or
should this be part of the core TPM infrastructure?

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
