From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm-chip: Return TPM error
 codes from auto_startup functions
Date: Tue, 29 Aug 2017 12:11:20 +0000
Message-ID: <68ebc7c2346e4db3bd5a7196677ee880@MUCSE603.infineon.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-3-Alexander.Steffen@infineon.com>
 <20170825170607.wfnr5y5zres2n42r@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170825170607.wfnr5y5zres2n42r-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index a353b7a..f20fcb7 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -404,8 +404,10 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  			rc = tpm2_auto_startup(chip);
> >  		else
> >  			rc = tpm1_auto_startup(chip);
> > -		if (rc)
> > +		if (rc < 0)
> >  			return rc;
> > +		else if (rc > 0)
> > +			return -ENODEV;
> 
> So what good this change makes in the end? I'm not sure I'm following.

This is just refactoring the code without changing the functionality. Before this change, tpm*_auto_startup could only return negative error codes (or 0 for success). With this change, tpm*_auto_startup can also return positive errors codes for TPM errors (but still 0 for success). Therefore, tpm_chip_register, the only caller of tpm*_auto_startup, now needs to convert positive error codes to -ENODEV, so that the external behavior is unchanged.

> >  	}
> >
> >  	tpm_sysfs_add_device(chip);
> > diff --git a/drivers/char/tpm/tpm-interface.c
> > b/drivers/char/tpm/tpm-interface.c
> > index 78fb41d..fe11f2a 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -1000,7 +1000,8 @@ EXPORT_SYMBOL_GPL(tpm_do_selftest);
> >   *                     sequence
> >   * @chip: TPM chip to use
> >   *
> > - * Returns 0 on success, < 0 in case of fatal error.
> > + * Returns 0 on success, < 0 in case of fatal error or a value > 0
> > + representing
> > + * a TPM error code.
> >   */
> 
> A nitpick.
> 
> According to https://www.kernel.org/doc/Documentation/kernel-doc-nano-
> HOWTO.txt
> you ought to use "Return:" keyword ;-)
> 
> I would favor here:
> 
>   "Return: same as with tpm_transmit_cmd()"

Agreed. I will fix that together with the rest, once the discussions for the other patches in the series have come to a conclusion.

> >  int tpm1_auto_startup(struct tpm_chip *chip)  { @@ -1015,10 +1016,7
> > @@ int tpm1_auto_startup(struct tpm_chip *chip)
> >  		goto out;
> >  	}
> >
> > -	return rc;
> >  out:
> > -	if (rc > 0)
> > -		rc = -ENODEV;
> >  	return rc;
> >  }
> >
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index e1a41b7..54a3123 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -1074,7 +1074,8 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip
> *chip)
> >   *                     sequence
> >   * @chip: TPM chip to use
> >   *
> > - * Returns 0 on success, < 0 in case of fatal error.
> > + * Returns 0 on success, < 0 in case of fatal error or a value > 0
> > + representing
> > + * a TPM error code.
> >   */
> >  int tpm2_auto_startup(struct tpm_chip *chip)  { @@ -1109,8 +1110,6 @@
> > int tpm2_auto_startup(struct tpm_chip *chip)
> >  	rc = tpm2_get_cc_attrs_tbl(chip);
> >
> >  out:
> > -	if (rc > 0)
> > -		rc = -ENODEV;
> >  	return rc;
> >  }
> >
> > --
> > 2.7.4
> >
> 
> At this point I can only see aero improvement how the driver works and a
> very minor clean up.
> 
> /Jarkko

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
