From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/7] tpm: infrastructure for TPM spaces
Date: Fri, 17 Mar 2017 22:44:29 +0200
Message-ID: <20170317204429.wsoe4r4jne437kyc@intel.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
	<20170303151912.14752-5-jarkko.sakkinen@linux.intel.com>
	<1aa1c9d32fd446f69551a36c37f0ed16@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1aa1c9d32fd446f69551a36c37f0ed16-nFblLGNE8XKJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 17, 2017 at 03:41:38PM +0000, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-
> > interface.c
> > index 20b1fe3..db5ffe9 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -376,11 +376,12 @@ static bool tpm_validate_command(struct
> > tpm_chip *chip, const u8 *cmd,
> >   *     0 when the operation is successful.
> >   *     A negative number for system errors (errno).
> >   */
> > -ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
> > -		     unsigned int flags)
> > +ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> > +		     u8 *buf, size_t bufsiz, unsigned int flags)
> 
> When adding parameters, please also update the parameter documentation
> at the top of the function. It is missing for the new parameter
> "space" here.

I missed that. I'll update the commits with the proper documentation.

> Alexander

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
