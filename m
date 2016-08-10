From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix build error
Date: Wed, 10 Aug 2016 19:44:01 +0300
Message-ID: <20160810164401.GA8952@intel.com>
References: <1470687926-32267-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160808202758.GA32391@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160808202758.GA32391-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

I'm going to fold this tomorrow with 4d970e733b09.

/Jarkko

On Mon, Aug 08, 2016 at 11:27:58PM +0300, Jarkko Sakkinen wrote:
> As the fix is quite trivial I already pushed this fixup on tip of my
> master branch in order to make testing easy.
> 
> /Jarkko
> 
> On Mon, Aug 08, 2016 at 11:25:26PM +0300, Jarkko Sakkinen wrote:
> > tpm_getcap and tpm2_get_tpm_pt were not properly exported. This commit
> > adds the exports. The build error exist only in the master (bleeding
> > edge) branch so this problem does not concern 4.8 release.
> > 
> > The commit will be folded to 4d970e733b09 as soon as it is tested and
> > reviewed.
> > 
> > Fixes: 4d970e733b09
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-interface.c | 1 +
> >  drivers/char/tpm/tpm2-cmd.c      | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > index ef5ad80..43ef0ef 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -458,6 +458,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
> >  		*cap = tpm_cmd.params.getcap_out.cap;
> >  	return rc;
> >  }
> > +EXPORT_SYMBOL_GPL(tpm_getcap);
> >  
> >  #define TPM_ORD_STARTUP cpu_to_be32(153)
> >  #define TPM_ST_CLEAR cpu_to_be16(1)
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index e1db404..499f405 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -707,6 +707,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
> >  
> >  	return rc;
> >  }
> > +EXPORT_SYMBOL_GPL(tpm2_get_tpm_pt);
> >  
> >  #define TPM2_STARTUP_IN_SIZE \
> >  	(sizeof(struct tpm_input_header) + \
> > -- 
> > 2.7.4
> > 
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity 
> planning reports. http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
