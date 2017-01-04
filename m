From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ibmtpm20tss-users] add TPM2 version of
 create_tpm2_key and libtpm2.so engine -> Hash algoritms
Date: Wed, 4 Jan 2017 15:58:33 -0500
Message-ID: <OF68510AAF.A99491D3-ON0025809E.0072EF54-8525809E.007339EC@notes.na.collabserv.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
	<1483489026.2464.76.camel@HansenPartnership.com>
	<20170104004217.GA390@obsidianresearch.com>
	<OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C@notes.na.collabserv.com>
	<20170104185434.GA12614@obsidianresearch.com>
	<1483559121.2561.67.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6321481438964183880=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483559121.2561.67.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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


--===============6321481438964183880==
Content-Type: multipart/alternative;
	boundary="=_alternative 007339598525809E_="


--=_alternative 007339598525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 01/04/2017 02:45:21 PM:

> > James is proposing using the Decrypt op to do this job.
>=20
> I believe the TCG has decided this is the only way to sign arbitrary
> data.

My suspicion is that this was an omission, not a decision.  In fact,
Part 1 explicitly describes a caller provided OID.  It just wasn't
implemented - yet.



--=_alternative 007339598525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>James Bottomley &lt;jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt; wrote
on 01/04/2017 02:45:21 PM:<br><br>&gt; &gt; James is proposing using the De=
crypt op to do this job.<br>&gt; <br>&gt; I believe the TCG has decided thi=
s is the only way to sign arbitrary<br>&gt; data.<br></font></tt><br><tt><f=
ont size=3D2>My suspicion is that this was an omission, not a decision.
&nbsp;In fact,</font></tt><br><tt><font size=3D2>Part 1 explicitly describe=
s a caller provided OID.
&nbsp;It just wasn't</font></tt><br><tt><font size=3D2>implemented - yet.</=
font></tt><br><BR>
--=_alternative 007339598525809E_=--



--===============6321481438964183880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============6321481438964183880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6321481438964183880==--
