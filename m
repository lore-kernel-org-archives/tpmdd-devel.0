From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 10 Feb 2017 16:13:05 -0500
Message-ID: <OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com>
	<1486745163.2502.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7698238056590967650=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1486745163.2502.26.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7698238056590967650==
Content-Type: multipart/alternative;
	boundary="=_alternative 00748DDE852580C3_="


--=_alternative 00748DDE852580C3_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote on=20
02/10/2017 11:46:03 AM:

> > quote: 810 milliseconds
> > verify signature: 635 milliseconds
>=20
> Part of the way of reducing the latency is not to use the TPM for
> things that don't require secrecy:=20

Agreed.  There are a few times one would verify a signature inside the=20
TPM,
but they're far from mainstream:

1 - Early in the boot cycle, when there's no crypto library.

2 - When the crypto library doesn't support the required algorithm.

3 - When a ticket is needed to prove to the TPM later that it verified
the signature.


--=_alternative 00748DDE852580C3_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>James Bottomley &lt;James.Bottomley-d9PhHud1JfjCXq6kfMZ53+cjAYwBJIVk@public.gmane.org=
m&gt;
wrote on 02/10/2017 11:46:03 AM:<br><br>&gt; &gt; quote: 810 milliseconds<b=
r>&gt; &gt; verify signature: 635 milliseconds<br>&gt; <br>&gt; Part of the=
 way of reducing the latency is not to use the TPM for<br>&gt; things that =
don't require secrecy: </font></tt><br><br><tt><font size=3D2>Agreed. &nbsp=
;There are a few times one would verify
a signature inside the TPM,</font></tt><br><tt><font size=3D2>but they're f=
ar from mainstream:</font></tt><br><br><tt><font size=3D2>1 - Early in the =
boot cycle, when there's no crypto
library.</font></tt><br><br><tt><font size=3D2>2 - When the crypto library =
doesn't support the required
algorithm.</font></tt><br><br><tt><font size=3D2>3 - When a ticket is neede=
d to prove to the TPM later
that it verified</font></tt><br><tt><font size=3D2>the signature.</font></t=
t><BR>
--=_alternative 00748DDE852580C3_=--



--===============7698238056590967650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============7698238056590967650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7698238056590967650==--
