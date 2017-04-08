From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [tpmdd-devel] Regression between Linux 3.16 and 4.8/4.9 on
 Lenovo X60 with coreboot
Date: Sat, 8 Apr 2017 12:40:25 +0200
Message-ID: <20170408123651.76f18ba4@second-laptop.localdomain>
References: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
 <bf4ca184f43cc7b6ee8069b63558087c@molgen.mpg.de>
 <20170406165557.GD7657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9ffh+Y=5Ev9RYi.f+lMH2Wq"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170406165557.GD7657@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

--Sig_/9ffh+Y=5Ev9RYi.f+lMH2Wq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 6 Apr 2017 10:55:57 -0600
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> We added direct ACPI binding to the driver in addition to PNP, so if
> you have an ACPI table it goes down that path and does some additional
> validation of what is in the TPM. The BIOS must provide a
> acpi_dev_resource_memory and a ACPI_SIG_TPM2 for the ACPI entry at a
> minimum.

I am working on it[1]. This commit has not been merged and is a work in
progress. It is however available in coreboot's gerrit.

So far with it and a recent kernel and the patch mentioned above:
- The linux driver finds the TPM automatically and doesn't require
  force=3D1
- The driver however still require itpm=3D1 to fully work: without it the
  tpm is found, but I wasn't able to read the PCRs.

Since I use a rolling release distribution, the kenrel version I use
tend to change quite fast, I can re-test if needed.

I need to improve the following in my patch:
- The IDs readings obviously need to be fixed.
- I want to make it work without itpm=3D1 if possible. I'll test with
  INTC0102 as it is in the driver in the is_itpm function, and it was
  also suggested to me by someone on IRC.

I also still need to investigate more why the itpm workaround is needed.
Does the TPM shipped in such laptops respect the specifications?
Is the wiring bad?

References:
-----------
[1]https://review.coreboot.org/cgit/coreboot.git/commit/?id=3D060cf4e0f50f7=
65f85e3ecedd836eed85d1571fe

Denis.

--Sig_/9ffh+Y=5Ev9RYi.f+lMH2Wq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJRL8OiBX7u2q5IcffCVtd8XgZkUFAljovhoACgkQfCVtd8Xg
ZkWsDA/+KrXFe2WjD5ibqtN5hNwTl2VGUy6b9LFLNgyPbJpY8uftZmGK+E1T0+PI
UjKcxuTnYz9FRuymoUQYS9AxhzI7ftKr8Sw+wWBnzC+au3dNFEWjIMy/NsgtoWnp
zS/GRRlDpreavuAc0CioNcmqeYMlHLoXMRc5OHG4yzZ2xIp4ny2QGM0oTPsTndC1
HYJv0chev22bNuSyG3kfAcyoALLMqlqOiuVI53D9st4iuBwtoxZp7AMnIZexgdxW
DPQRwc+DPicMhcxHmffb7N3FzkSjw0K0I5KGYhrdZ3zPNwHPJNrT34lbIaSlKFn6
lZ6wHlpNO4UHgNQe0XoR50q3TddR8lsHmoCdNVFLAG+H1MnPOt8f7uD7Wqz5ms7I
sqS4Ct8AK57NB+aRsq5I0XxCfk2eS4WgTxGNIaE+NAYXrMyaef5m0M2Q2tzLXrFm
1zO7Q8uRk30TagMaDLJy0pLyPebC6eh9FnmsmsErxB4YyvTvxtNIP4fszBnFwlJ6
XNRa8GS1TfR2U79VtFK4cdThO6fsd+TBBrfnesg0oJ7Pn2zLOglV3gTDX+/Z1YzZ
9OUHICQyQUA0i4ce8kSlhQ1V68Kf8QL/E0jOs0oi76qvc9tl9GyfRpwS0ThkUb3z
yV4nUHJmQ0Dl0qjYQINR3VeNwwz/UMhqsMGFoSEexbkHcpV9whw=
=JEc4
-----END PGP SIGNATURE-----

--Sig_/9ffh+Y=5Ev9RYi.f+lMH2Wq--
