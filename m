From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 04 Jan 2017 10:19:36 -0800
Message-ID: <1483553976.2561.38.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-04 at 13:04 -0500, Stefan Berger wrote:
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/02/2017
> 08:22:08 AM:
> 
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -943,7 +943,9 @@ EXPORT_SYMBOL_GPL(tpm2_probe);
> >   */
> >  int tpm2_auto_startup(struct tpm_chip *chip)
> >  {
> > +   u32 nr_commands;
> >     int rc;
> > +   int i;
> > 
> >     rc = tpm_get_timeouts(chip);
> >     if (rc)
> > @@ -967,8 +969,49 @@ int tpm2_auto_startup(struct tpm_chip *chip)
> >        }
> >     }
> > 
> > +   rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands,
> NULL);
> > +   if (rc)
> > +      return rc;
> > +
> > +   chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
> > +                 GFP_KERNEL);
> 
> For some reason this devm_kzalloc bombs for the vtpm proxy driver. 
> The only reason I could come up with is that it's being called before
> tpm_add_char_device() has been called.

No, it should be sufficient that chip->dev be initialized (which it is
in tpm_chip_alloc()).  What's the error you're getting?

It does look like the intention was to have non-devm with
tpm_chip_alloc() and devm with tpmm_chip_alloc(), but devm_kzalloc
should just work regardless because it's tied to the device model.

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
