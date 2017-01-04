From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 4 Jan 2017 11:44:22 -0700
Message-ID: <20170104184422.GA12283@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 01:04:59PM -0500, Stefan Berger wrote:

>    > @@ -943,7 +943,9 @@ EXPORT_SYMBOL_GPL(tpm2_probe);
>    >   */
>    >  int tpm2_auto_startup(struct tpm_chip *chip)
>    >  {
>    > +   u32 nr_commands;
>    >     int rc;
>    > +   int i;
>    >
>    >     rc = tpm_get_timeouts(chip);
>    >     if (rc)
>    > @@ -967,8 +969,49 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>    >        }
>    >     }
>    >
>    > +   rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands,
>    NULL);
>    > +   if (rc)
>    > +      return rc;
>    > +
>    > +   chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
>    > +                 GFP_KERNEL);
>    For some reason this devm_kzalloc bombs for the vtpm proxy driver. The
>    only reason I could come up with is that it's being called before
>    tpm_add_char_device() has been called.

It would also fail if nr_commands is wrong, and this should be one of
the array safe allocation functions since nr_command is data from the
TPM...

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
