From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/4] tmp/tpm_crb: implement runtime pm for
	tpm_crb
Date: Sat, 8 Oct 2016 21:43:56 +0300
Message-ID: <20161008184356.GA28692@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
	<1475927979-23484-5-git-send-email-tomas.winkler@intel.com>
	<20161008124708.GA10317@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F6741@hasmsx108.ger.corp.intel.com>
	<20161008160112.GB25893@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F684D@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F684D-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 08, 2016 at 06:18:36PM +0000, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> > Sent: Saturday, October 08, 2016 19:01
> > To: Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH 4/4] tmp/tpm_crb: implement runtime pm for tpm_crb
> > 
> > On Sat, Oct 08, 2016 at 01:37:31PM +0000, Winkler, Tomas wrote:
> > > >
> > > > On Sat, Oct 08, 2016 at 02:59:39PM +0300, Tomas Winkler wrote:
> > > > > From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > >
> > > > > Utilize runtime_pm for driving tpm crb idle states.
> > > > > The framework calls cmd_ready from the pm_runtime_resume handler
> > > > > and go idle from the pm_runtime_suspend handler.
> > > > > The TPM framework should wake the device before transmit and receive.
> > > > > In case the runtime_pm framework is not compiled in or enabled,
> > > > > the device will be in the permanent ready state.
> > > > >
> > > > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > >
> > > > I would rather want the fix as a separate patch to make review +
> > > > testing easier (without and with). Thanks.
> > >
> > > But you've dropped the patches, so I've resent them.
> > > Can you do the diff yourself, just branch it off.  it's really just
> > > few lines
> > 
> > Nope. I have only dropped the workaround.
> 
> This is what is current in the linus tree:
> 
> git log --oneline linux/master -- drivers/char/tpm/
> 
> 324152502b0e Revert "tpm/tpm_crb: implement tpm crb idle state"
> cfa188220363 Revert "tmp/tpm_crb: fix Intel PTT hw bug during idle state"
> 2b7926ae1cd4 Revert "tpm/tpm_crb: open code the crb_init into acpi_add"
> 4886cd80cb8e Revert "tmp/tpm_crb: implement runtime pm for tpm_crb"
> e350e24694e4 tmp/tpm_crb: implement runtime pm for tpm_crb
> 0c22db435bf7 tpm/tpm_crb: open code the crb_init into acpi_add
> 9514ff1961c6 tmp/tpm_crb: fix Intel PTT hw bug during idle state
> e17acbbb69d3 tpm/tpm_crb: implement tpm crb idle state

That's unrelated: https://lkml.org/lkml/2016/9/27/107

Anyway, I applied this because the change is fairly obvious but it would
be nicer to get the fix as a separate patch for a series that is already
applied. If you rely on "do the diff yourself", it is quite ineffective
way to crowdsource :)

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
