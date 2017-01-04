From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: add TPM2 version of create_tpm2_key and
 libtpm2.so engine -> Hash algoritms
Date: Wed, 4 Jan 2017 15:55:05 -0500
Message-ID: <OFBCEDDB45.08EB1DA0-ON0025809E.007287A6-8525809E.0072E8AD@notes.na.collabserv.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
	<1483489026.2464.76.camel@HansenPartnership.com>
	<20170104004217.GA390@obsidianresearch.com>
	<OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C@notes.na.collabserv.com>
	<20170104185434.GA12614@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3697261675104172706=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170104185434.GA12614-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3697261675104172706==
Content-Type: multipart/alternative;
	boundary="=_alternative 0072E8218525809E_="


--=_alternative 0072E8218525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/04/2017=20
01:54:34 PM:

> We don't need the algorithm in the TPM. We just need to be able to RSA
> sign an arbitary OID + externally computed hash like TPM 1.2 could.
>=20
> What is the recommended way to create a key with a sign-only intent
> that can be used with arbitary OID + computed hash?

Probably the long-term correct way is to go to the TCG and ask for a=20
new feature.  However, this is (often certified) hardware, so the turn=20
around is likely to be a year.

> James is proposing using the Decrypt op to do this job.

That works.  I've coded it.  However, the key doesn't have
"sign only intent", in that the caller not only provides the OID
but also provides the padding.



--=_alternative 0072E8218525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/04/2017 01:54:34 PM:<br><br>&gt; We don't need the algorithm in=
 the TPM. We just need to be able to
RSA<br>&gt; sign an arbitary OID + externally computed hash like TPM 1.2 co=
uld.<br>&gt; <br>&gt; What is the recommended way to create a key with a si=
gn-only intent<br>&gt; that can be used with arbitary OID + computed hash?<=
/font></tt><br><br><tt><font size=3D2>Probably the long-term correct way is=
 to go to the
TCG and ask for a </font></tt><br><tt><font size=3D2>new feature. &nbsp;How=
ever, this is (often certified)
hardware, so the turn </font></tt><br><tt><font size=3D2>around is likely t=
o be a year.</font></tt><br><br><tt><font size=3D2>&gt; James is proposing =
using the Decrypt op to do
this job.</font></tt><br><br><tt><font size=3D2>That works. &nbsp;I've code=
d it. &nbsp;However, the
key doesn't have</font></tt><br><tt><font size=3D2>&quot;sign only intent&q=
uot;, in that the caller not
only provides the OID</font></tt><br><tt><font size=3D2>but also provides t=
he padding.<br></font></tt><BR>
--=_alternative 0072E8218525809E_=--



--===============3697261675104172706==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============3697261675104172706==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3697261675104172706==--
