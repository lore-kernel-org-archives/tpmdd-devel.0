From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: use get_unaligned_be32 unaligned
	buffer access.
Date: Wed, 23 Nov 2016 20:56:25 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543308CB@hasmsx108.ger.corp.intel.com>
References: <1479899094-9486-1-git-send-email-tomas.winkler@intel.com>
	<20161123165734.GA2763@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161123165734.GA2763-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> On Wed, Nov 23, 2016 at 01:04:54PM +0200, Tomas Winkler wrote:
> > Use get_unaligned_be32 as b32_to_cpu doesn't work correctly on all
> > platforms for unaligned access.
> >
> > The fix doesn't cover all the cases as also some cast structures have
> > members on unaligned addresses.
> 
> I think this is a good idea..
> 
> > @@ -353,8 +353,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8
> *buf, size_t bufsiz,
> >  	if (bufsiz > TPM_BUFSIZE)
> >  		bufsiz = TPM_BUFSIZE;
> >
> > -	count = be32_to_cpu(*((__be32 *) (buf + 2)));
> > -	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > +	count = get_unaligned_be32(buf + 2);
> > +	ordinal = get_unaligned_be32(buf + 6);
> 
> But lets fix this better and get rid of the constants too...

>  const tpm_input_header *hdr = buf;
>  count = be32_to_cpu(hdr->length);
>  ordinal = be32_to_cpu(hdr->ordinal);
> 
> Compiler will take care of unaligned for __packed.

Yes, compiler takes care at performance penalty but probably we don't care about that much,
 and readability is maybe more important here. What I've done is pretty much mechanical fix, 
I agree this is better approach in this particular case.

> > @@ -178,7 +178,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf,
> size_t count)
> >  		return -EIO;
> >
> >  	memcpy_fromio(buf, priv->rsp, 6);
> > -	expected = be32_to_cpup((__be32 *) &buf[2]);
> > +	expected = get_unaligned_be32(buf + 2);
> 
> Here too, except tpm_output_header (and is tpm1 and 2 the same here?)
> 
> > @@ -451,7 +452,7 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >  		goto out;
> >  	}
> >
> > -	expected = be32_to_cpu(*(__be32 *)(buf + 2));
> > +	expected = get_unaligned_be32(buf + 2);
> 
> Ditto
> 
> > @@ -314,7 +315,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >  		 * convert number of expected bytes field from big endian 32
> bit
> >  		 * to machine native
> >  		 */
> > -		expected = be32_to_cpu(*(__be32 *) (buf + 2));
> > +		expected = get_unaligned_be32(buf + 2);
> 
> Ditto
> 
> >  		if (expected > count) {
> >  			dev_err(dev, "%s() expected > count\n", __func__);
> >  			size = -EIO;
> > @@ -442,7 +443,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8
> *buf, size_t len)
> >  		i2c_nuvoton_ready(chip);
> >  		return rc;
> >  	}
> > -	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > +	ordinal = get_unaligned_be32(buf + 6);
> 
> Ditto
> 
> > @@ -174,8 +173,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 *
> buf, size_t count)
> >  		return -EIO;
> >  	}
> >
> > -	native_size = (__force __be32 *) (buf + 2);
> > -	size = be32_to_cpu(*native_size);
> > +	size = get_unaligned_be32(buf + 2);
> 
> Ditto
> 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c
> > b/drivers/char/tpm/tpm_tis_core.c index 7993678954a2..5323c54dc917
> > 100644
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -222,7 +222,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >  		goto out;
> >  	}
> >
> > -	expected = be32_to_cpu(*(__be32 *) (buf + 2));
> > +	expected = get_unaligned_be32(buf + 2);
> 
> Ditto
> 
> > @@ -371,7 +371,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >  		goto out_err;
> >
> >  	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
> > -		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > +		ordinal = get_unaligned_be32(buf + 6);
> 
> Ditto
> 
> Jason

------------------------------------------------------------------------------
