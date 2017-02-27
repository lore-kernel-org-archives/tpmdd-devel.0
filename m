From: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Apply an adapterlimit for
 retransmission.
Date: Mon, 27 Feb 2017 20:12:45 +0100
Message-ID: <20170227191245.ecord2i7o6jwec5k@ninjato>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
	<20170221162948.GD25818@lunn.ch>
	<ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
	<20170222140134.GA23586@lunn.ch>
	<CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4244949490665710868=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Enric Balletbo Serra <eballetbo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, apronin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4244949490665710868==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pfm22rx7hy4aoghe"
Content-Disposition: inline


--pfm22rx7hy4aoghe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

> >> > Rather than trying small and smaller transfers, would it not be better
> >> > to get the i2c core to expose the quirk info about transfer limits?
> >> >
> >>
> >> Sounds a good idea to me, I guess the quirk info can be accessed with
> >>
> >>   tpm_dev.client->adapter->quirks->max_read_len
> >>
> >> so I think we don't need to touch the i2c core. I'll propose a second version of the patch.
> >
> > Hi Enric
> >
> > You should probably ask Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, the i2c
> > subsystem maintainer. He may prefer adding an API call.

Thanks for pointing me to this thread.

I understand it looks tempting to use the quirks struct directly, but I
don't think this is the proper solution. Quirks are complex and and to
determine which one finally applies, you need all the logic encoded in
i2c_check_for_quirks(). Which already gets called on every transfer.

So, my suggestion would be to simply fall back to a sane minimum when
the maximum failed. 32 (I2C_SMBUS_BLOCK_MAX) should be a good choice.

BTW I noted that the original patch checks for -EINVAL. The core returns
-EOPNOTSUPP, though. So, a) the patch needs to be adapted and b) it
looks the i2c host driver returning -EINVAL could be converted to use
the quirk infrastructure? Which driver is it?

Regards,

   Wolfram


--pfm22rx7hy4aoghe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAli0eh4ACgkQFA3kzBSg
KbawLA/+NaOT9wE9qrQ4JU6eIOs+P+i+sD7UC0Zy/OeAlzP2mWgSl8tNcUQMDMN3
8czgoisHsGFIcYXvgMO5rtryneXF6ftM3aoQML78tGjsIOE4T8XFC6Img05OIufG
pkWB1WX/7hFYJRM8vKyR7DqPwCv9h9bK8LMlSLaGfpQh99i4UTdIVxbA5sZDwTYz
PvJ0yd/38Kb5+5nZQdXcRTj5D0bu6Xpqa2k2mhbEdCEqr6rDgQCiWoMV2q1Emg0a
nd5ftFkm86xjwIBoJcTKuZPLm3ZcH2Z4BAsNLM0+AVWnR7OR7+eSgxG7ATt8v0sa
p/DxcIiwEMA6wxAyzW/Pos8RpMf3LFUGnkzlluHw+OydS2FvryT2+wQmkUYi5rJ3
rf/lgMNT86R1ECSjnWPCkRECIkUG2jYUy1H50RuIdqD0LboozXLeu3ZKtPpUiRNR
r0FT6Z3MUI8FIoaDNaFPCj+CqyeI2b9eqLqI9jw7GlCQyEu245bmRkm2dOISXU0o
iI3A3CgCDxSO4hh2l5DH+79cLKa1XWtW2hTSvsjNEKa/i1Inek791Ja0EAm8TTjF
h9BD6movBs1NIUZ8q8fOWKR8k2rL4cieaAic0OEUmEg0UpCFA6v2pn/KpAQGVT9Y
EiBWdWPl+IfzxcgjEy+zH//4M5CfbQizpKmYCTJDl6GX48v8GTw=
=wqJf
-----END PGP SIGNATURE-----

--pfm22rx7hy4aoghe--


--===============4244949490665710868==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============4244949490665710868==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4244949490665710868==--
