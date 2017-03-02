From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm: Apply an adapterlimit for
 retransmission.
Date: Thu, 2 Mar 2017 15:10:08 +0100
Message-ID: <20170302141008.GB1512@katana>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
 <20170221162948.GD25818@lunn.ch>
 <ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
 <20170222140134.GA23586@lunn.ch>
 <CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA@mail.gmail.com>
 <20170227191245.ecord2i7o6jwec5k@ninjato>
 <9E9945C5-50AD-465C-BE0E-F77499D79A04@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9E9945C5-50AD-465C-BE0E-F77499D79A04@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Enric Balletbo Serra <eballetbo@gmail.com>, Andrew Lunn <andrew@lunn.ch>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Marcel Selhorst <tpmdd@selhorst.net>, apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> TPMs are a not the best devices when it comes to i2c :/

BTW I blame the quirky I2C HW of the adapters, so far.


--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYuCfAAAoJEBQN5MwUoCm2E9oQAKokwp1satPlkDl/IVs1hDbv
karH07R3k2P+khXCCIvN8JJ/aiuP6r5hJLJNrdvBd0wreTz+XpF5b25Y262GAAqh
0lGNvX/1dP7Hwb2Iiy5hAWgH8r6GNrXsOGOo/KGg2kXUa+c+tzfrxpbV3kjWyzwH
RZtJF4Nk2ibtSOVV9kqmH4cqY2uChaXY/PdOux/RtHlacJjkCBblAq+EpYZDgRph
IYukZmlgRQizI0FItedKkJo37KqXYKL1b/cKReOByDQ6Lw8UgT0FWW3UJ8VcbqlJ
K/KHOCo+fBjCxduzQ3IZm4p861akaTg29JoQtQm981IWutO94zS4JruBGDPE3ckE
BHDXCrryaTWmrWBtycjUO/APqrFvryk554LUziJrXVQ/Mp3SUUL8ha2JNWPUC1Qt
o2tN+ijuO1qMn7WGfYq+G8iovdd4b3NB+avcvhd01EMw7jA95rsKHKN/N3NThVHR
UPfT1SD5iyDgfbENQNXhV7DnhGdfPoJwiT8/Z63fID/3FESm6Xvzo1rFL+AIq7kK
O+c5oNn7DujMhJ6PIjaYaG6xAm+aWQmRVVaWXlqDm05AApC6V1Xoe++Rz8VPjQeO
HNTIkQr56B0GG/tViqBHUemhJKUz52ZoW7elaw1XeRhyenT6UZ5lowcYgcoXmCEl
zMoAwMLtOKpT50kg/clE
=+Qe8
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
