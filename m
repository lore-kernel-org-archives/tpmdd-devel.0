From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm: Apply an adapterlimit for
 retransmission.
Date: Thu, 2 Mar 2017 15:05:59 +0100
Message-ID: <20170302140558.GA1512@katana>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
 <20170221162948.GD25818@lunn.ch>
 <ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
 <20170222140134.GA23586@lunn.ch>
 <CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA@mail.gmail.com>
 <20170227191245.ecord2i7o6jwec5k@ninjato>
 <9E9945C5-50AD-465C-BE0E-F77499D79A04@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9E9945C5-50AD-465C-BE0E-F77499D79A04@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Enric Balletbo Serra <eballetbo@gmail.com>, Andrew Lunn <andrew@lunn.ch>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Marcel Selhorst <tpmdd@selhorst.net>, apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> If the command is larger than the supported adapter limit the command the only viable option is to return an error.
> For this the tpm layer would need the adapter limit.

There is no single value for a limit. This is why the quirks struct is
complex and we need a function to determine the limit each time for a
given transfer from it.


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYuCbGAAoJEBQN5MwUoCm2psAP/1WDYYgqDBW8jBM8FpTU7xW9
ZlAsxJIrZywRyCKP1h1Bfd6uiDGpedN/FeDLLHm6coLDA3xR/JP4zGdOmXTyaLRi
w/5mVlmBON8abX74Ny3Y+XqcQIUOECuqOqr0vHgSAcnkHKpZiOvOmwlMSyFeqDDF
G38Hp72osIzkMf7nC8W0vcfWL3QDW65MUi0acMfDmUugtnE05jsd9hdn+YSm/ocv
rFs2Zll00h1hWjxmEjojqmCYubB+5MqlucLtFXEtUwK/S9Bs4YLod4HONF9DQgRG
fL927554PpQUNLZKIAeuTHH4cwVC5AwOEEXvHQ6k7zqNrRncoTkTvk2xKBDZyCgo
dnP7XrIlxiohOPP1geX8fm/Gcea4bvQVPqiqNUGfm41YaFepHZn6hFQf1gqGfBhm
O1H2c/6ri3quH04h3AvRAGazOqMq46CoB+4Cq59S6jz0CSBMc3r+Zg7+ibqhSCCj
JGcbB7CuLwp6ibL9Nbdb8LrfxxTuaCmJsa7Vg9ALFdvvt4DEwI1ztach+E0hehz+
8yCRF02ZJLg4qx95ENYfzt+O895RPtcFHNJQsE0l3Cl5fq7tN2B55I5IEBaz+yC0
kNaLYY+JfipZ3cMBLzKiHFMBXWcLNY8FtetRhPkH8w5qFX0K97Ie+eYaID0RScA/
Me457Y8Jz8hgcjn+s5tv
=fxQc
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
