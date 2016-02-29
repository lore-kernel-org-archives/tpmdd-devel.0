From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 00/10] Multi-instance vTPM driver
Date: Mon, 29 Feb 2016 22:57:39 +0200
Message-ID: <20160229205739.GB27210@intel.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229202401.GA26296@intel.com>
	<201602292030.u1TKUgSu010507@d01av03.pok.ibm.com>
	<20160229204846.GA27210@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160229204846.GA27210-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Mon, Feb 29, 2016 at 10:48:46PM +0200, Jarkko Sakkinen wrote:
> On Mon, Feb 29, 2016 at 03:30:35PM -0500, Stefan Berger wrote:
> >    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/29/2016
> >    03:24:01 PM:
> > 
> >    >
> >    > On Mon, Feb 29, 2016 at 12:29:46PM -0500, Stefan Berger wrote:
> >    > > The following series of patches implements a multi-instance vTPM
> >    driver
> >    > > that can dynamically create TPM 'server' and client device pairs.
> >    > >
> >    > > Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> >    > > and a server side file descriptor is created. The file descriptor must
> >    > > be passed to a TPM emulator. The device driver will initialize the
> >    > > emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> >    > > the command durations from the device in case of a TPM 1.2. The choice
> >    > > of emulated TPM device (1.2 or 2) must be provided with a flag in
> >    > > the ioctl.
> >    > >
> >    > > The driver is based on James Morris's 'next' branch and uses several
> >    > > recently posted patches from Jason and Jarkko. Some of these patches
> >    > > needed to rebased on top of this tree.
> >    >
> >    > It is kind of hard to follow what has happend between patch set
> >    > versions if you don't have a changelog in the cover letter.
> > 
> >    Sorry for that. I followed your suggestion about the flags in the
> >    vtpm-driver but moved the ops related to flag modifications under the
> >    mutex lock.
> 
> Thanks and no worries.

I looked at the patches and I think this could be applied to master
very soon. I still have to look it with time though so this is not yet
a promise. In big picture this looks really good.

That does not mean of course that they will go to linux-next any time
soon but this way they would get more exposure.

Does not make sense to waste your time for rolling out new version of
the series if the problems are localized to few lines...

/Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
