From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/5] tpm: unify tpm_gen_interrupt()
Date: Fri, 24 Jun 2016 23:25:39 +0300
Message-ID: <20160624202539.GE8399@intel.com>
References: <1466197847-4937-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1466197847-4937-2-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160624193024.GA563@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160624193024.GA563-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Fri, Jun 24, 2016 at 01:30:24PM -0600, Jason Gunthorpe wrote:
> On Fri, Jun 17, 2016 at 11:10:43PM +0200, Jarkko Sakkinen wrote:
> >  extern int tpm_get_timeouts(struct tpm_chip *);
> > -extern void tpm_gen_interrupt(struct tpm_chip *);
> > +void tpm_gen_interrupt(struct tpm_chip *);
> 
> Dropping the argument name is not the kernel standard, if these lines
> are going to be churned they may as well be churned to the standard.
> 
> FWIW, all the extern's should be dropped too.

Thanks for pointin these out. And yes, since this is mostly a cleanup
series, adding a patch that would clean up those unnecessary externs
would make sense. I'll send a revised version with your suggestions.

> Jason

/Jarkko

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
