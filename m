From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ibmtpm20tss-users] [TrouSerS-tech] [PATCH 1/1]
 add TPM2 version of create_tpm2_key and libtpm2.so engine
Date: Wed, 4 Jan 2017 13:05:50 -0500
Message-ID: <OF5814982B.77663DA2-ON8525809E.0062C054-8525809E.006369C1@notes.na.collabserv.com>
References: <1483224485.2518.20.camel@HansenPartnership.com><1483224763.2518.24.camel@HansenPartnership.com><20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2558335269992409520=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483485776.2464.50.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2558335269992409520==
Content-Type: multipart/alternative;
	boundary="=_alternative 006368068525809E_="


--=_alternative 006368068525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Trimmed the CC list a bit.  Where does this discussion really belong?=20
Trousers is for TPM 1.2,
and it's not a TSS or TPM device driver issue.

If you're all TCG members, the TCG's TPM WG is the real place to go if you =

want to get=20
something fixed.

James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote on=20
01/03/2017 06:22:56 PM:

> >=20
> > [Note, I haven't looked closely at TPM2, but TPM1.2 has a concept of
> >  key usage, and I assume that is carried over in the below comments]
>=20
> The TPM1.2 all uses the correct signing functions, the problem is only
> with 2.0.
>=20
> > I think it is very important to natively support the sign-only key
> > usage restriction. TPM1.2 goes so far as to declare keys that can be
> > used for arbitary decrypt as 'legacy do not use'.

TPM 2.0 has several features to support this:

- Signing keys, a usage restriction that can only sign.
- Policy only, with a policy restricted to specific commands, e.g., Quote=20
or Sign.
- Restricted keys, that have a fixed algorithm and can only sign TPM=20
generated data.

What it doesn't have is the ability (for a signing key) to prepend a=20
caller
specified OID and padding.



--=_alternative 006368068525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<font size=3D2 face=3D"sans-serif">Trimmed the CC list a bit. &nbsp;Where
does this discussion really belong? &nbsp;Trousers is for TPM 1.2,</font><b=
r><font size=3D2 face=3D"sans-serif">and it's not a TSS or TPM device driver
issue.</font><br><br><font size=3D2 face=3D"sans-serif">If you're all TCG m=
embers, the TCG's
TPM WG is the real place to go if you want to get </font><br><font size=3D2=
 face=3D"sans-serif">something fixed.</font><br><font size=3D2 face=3D"sans=
-serif"><br></font><tt><font size=3D2>James Bottomley &lt;James.Bottomley@H=
ansenPartnership.com&gt;
wrote on 01/03/2017 06:22:56 PM:<br><br>&gt; &gt; <br>&gt; &gt; [Note, I ha=
ven't looked closely at TPM2, but TPM1.2 has a concept
of<br>&gt; &gt; &nbsp;key usage, and I assume that is carried over in the b=
elow
comments]<br>&gt; <br>&gt; The TPM1.2 all uses the correct signing function=
s, the problem is
only<br>&gt; with 2.0.<br>&gt; <br>&gt; &gt; I think it is very important t=
o natively support the sign-only
key<br>&gt; &gt; usage restriction. TPM1.2 goes so far as to declare keys t=
hat
can be<br>&gt; &gt; used for arbitary decrypt as 'legacy do not use'.</font=
></tt><br><br><tt><font size=3D2>TPM 2.0 has several features to support th=
is:</font></tt><br><br><tt><font size=3D2>- Signing keys, a usage restricti=
on that can only
sign.</font></tt><br><tt><font size=3D2>- Policy only, with a policy restri=
cted to specific
commands, e.g., Quote or Sign.</font></tt><br><tt><font size=3D2>- Restrict=
ed keys, that have a fixed algorithm and
can only sign TPM generated data.</font></tt><br><br><tt><font size=3D2>Wha=
t it doesn't have is the ability (for a signing
key) to prepend a caller</font></tt><br><tt><font size=3D2>specified OID an=
d padding.<br></font></tt><BR>
--=_alternative 006368068525809E_=--



--===============2558335269992409520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============2558335269992409520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2558335269992409520==--
