From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: add TPM2 version of create_tpm2_key and libtpm2.so
	engine -> Hash algoritms
Date: Wed, 4 Jan 2017 13:48:44 -0500
Message-ID: <OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C@notes.na.collabserv.com>
References: <1483224485.2518.20.camel@HansenPartnership.com><1483224763.2518.24.camel@HansenPartnership.com><20170103231126.GE29656@obsidianresearch.com><1483485776.2464.50.camel@HansenPartnership.com><20170103234053.GA32185@obsidianresearch.com><1483489026.2464.76.camel@HansenPartnership.com>
	<20170104004217.GA390@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9074442555860938653=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170104004217.GA390-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============9074442555860938653==
Content-Type: multipart/alternative;
	boundary="=_alternative 006756DE8525809E_="


--=_alternative 006756DE8525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/03/2017=20
07:42:17 PM:

> > ... but my current TPM doesn't understand
> > anything other than sha1 or sha256, so it wouldn't allow more state of
> > the art algorithms like sha224, sha384 or sha512 either.
>=20
> Okay, yes, that is horrible :( If it is that bad it might not be worth
> the effort.

The place to ask for new algorithms is the TCG's Device Driver WG.  It's
an odd WG name, but this is the WG where the TPM mandatory algorithms are
specified.

A real, commercial use case will likely be an effective argument, since
these are resource constrained and cost sensitive.

SHA-384 and SHA-512 are currently optional, which traditionally means=20
they won't be implemented.



--=_alternative 006756DE8525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/03/2017 07:42:17 PM:<br><br>&gt; &gt; ... but my current TPM do=
esn't understand<br>&gt; &gt; anything other than sha1 or sha256, so it wou=
ldn't allow more
state of<br>&gt; &gt; the art algorithms like sha224, sha384 or sha512 eith=
er.<br>&gt; <br>&gt; Okay, yes, that is horrible :( If it is that bad it mi=
ght not be worth<br>&gt; the effort.</font></tt><br><br><tt><font size=3D2>=
The place to ask for new algorithms is the TCG's Device
Driver WG. &nbsp;It's</font></tt><br><tt><font size=3D2>an odd WG name, but=
 this is the WG where the TPM mandatory
algorithms are</font></tt><br><tt><font size=3D2>specified.</font></tt><br>=
<br><tt><font size=3D2>A real, commercial use case will likely be an effect=
ive
argument, since</font></tt><br><tt><font size=3D2>these are resource constr=
ained and cost sensitive.</font></tt><br><br><tt><font size=3D2>SHA-384 and=
 SHA-512 are currently optional, which
traditionally means </font></tt><br><tt><font size=3D2>they won't be implem=
ented.<br></font></tt><BR>
--=_alternative 006756DE8525809E_=--



--===============9074442555860938653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============9074442555860938653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============9074442555860938653==--
