From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] tpm: return error code from
	tpm_gen_interrupt()
Date: Tue, 19 Jul 2016 23:36:34 +0300
Message-ID: <20160719203634.GB26228@intel.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1468935171-7815-4-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160719202741.GB16042@obsidianresearch.com>
	<20160719203147.GA26228@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160719203147.GA26228-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 11:31:47PM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 19, 2016 at 02:27:41PM -0600, Jason Gunthorpe wrote:
> > On Tue, Jul 19, 2016 at 04:32:47PM +0300, Jarkko Sakkinen wrote:
> > > Return error code from tpm_gen_interrupt() and fail tpm_tis family of
> > > drivers on a system error. It doesn't make sense to continue if we
> > > cannot even reach the TPM.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >  drivers/char/tpm/tpm-interface.c | 6 +++---
> > >  drivers/char/tpm/tpm.h           | 2 +-
> > >  drivers/char/tpm/tpm_tis_core.c  | 4 +++-
> > >  3 files changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index 88dafcd..35b2722 100644
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -466,16 +466,16 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
> > >   * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
> > >   * a TPM error code.
> > >   */
> > > -void tpm_gen_interrupt(struct tpm_chip *chip)
> > > +int tpm_gen_interrupt(struct tpm_chip *chip)
> > 
> > drivers/char/tpm/st33zp24/st33zp24.c needs to be updated too.
> > 
> > I looked at st33zp24.c and it looks broken, I don't see any logic that
> > de-asserts TPM_CHIP_FLAG_IRQ if the irq test triggered by
> > tpm_gen_interrupt, so presumably it should not be calling it at all.
> > 
> > IMHO, DT binding devices should never auto-probe IRQS anyhow, we only
> > do it on PC because PC is insane...
> > 
> > If we fix st33 then I suggest just moving tpm_gen_interrupt into
> > tpm_tis - nothing else should really be using it..
> 
> I'm happy to take fix for st33 but not the move because it does not
> matter for the release.

Ignore this comment, this series is not anyway going to 4.8 release.

If Christophe could submit a fix for st33, I could include it to this
series and make one more revision. Thank you for reviewing this!

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
