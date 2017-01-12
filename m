From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Thu, 12 Jan 2017 22:31:22 +0200
Message-ID: <20170112203122.y72a46b5d3dbbd6b@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
	<1484246310.2417.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484246310.2417.15.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 10:38:30AM -0800, James Bottomley wrote:
> On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > @@ -435,17 +440,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip,
> > const u8 *buf, size_t bufsiz,
> >         goto out;
> > 
> >  out_recv:
> > -       rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
> > -       if (rc < 0)
> > +       len = chip->ops->recv(chip, (u8 *) buf, bufsiz);
> > +       if (len < 0) {
> >                 dev_err(&chip->dev,
> > -                       "tpm_transmit: tpm_recv: error %zd\n", rc);
> > +                       "tpm_transmit: tpm_recv: error %d\n", rc);
> > +               rc = len;
> > +               goto out;
> > +       }
> > +
> > +       rc = tpm2_commit_space(chip, space, ordinal, buf, bufsiz);
> 
> I think this should be
> 
> rc = tpm2_commit_space(chip, space, ordinal, buf, len)
> 
> because tpm2_commit_space wants to know the length of the response, not
> the length of the original command.

Yeah, would make sense.

> James

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
