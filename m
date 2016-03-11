From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is vTPM the right name for the new functionality?
Date: Fri, 11 Mar 2016 10:26:26 -0500
Message-ID: <201603111522.u2BFM8wc006269@d01av05.pok.ibm.com>
References: <20160311104304.GA14787@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8772502739584882392=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160311104304.GA14787-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============8772502739584882392==
Content-Type: multipart/alternative;
	boundary="=_alternative 0054D35585257F73_="


--=_alternative 0054D35585257F73_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/11/2016=20
05:43:04 AM:

>=20
> Hi Stefan,
>=20
> This is something I would like discuss and get other points of views.
>=20
> The thing that I would like to rise is the name of this new subsystem.
> The keyword 'vTPM' is already heavily referenced in contexts for more
> "full stack" solution of virtualization [1].
>=20
> If I look at this new functionality it is essentially a proxy and not
> much else, isn't it? You can apply for Linux containers but alone it is
> proxy tool. With the current name it is too easy to confuse it with
> existing solutions.

Fine by me. I can rename it to tpm=5Fproxy.c and reference to it as the=20
virtual TPM proxy driver or TPM emulator proxy driver, which I think=20
describes it well. It's not a 'Proxy TPM'.
The title of the cover letter for the patches would then be

Multi-instance vTPM proxy driver

  Stefan

>=20
> Maybe we should call it Proxy TPM instead (I'm open for other name
> suggestions)?
>=20
> [1] http://domino.research.ibm.com/library/cyberdig.nsf/
>=20
1e4115aea78b6e7c85256b360066f0d4/a0163fff5b1a61fe85257178004eee39?OpenDocum=
ent
>=20
> /Jarkko
>=20



--=_alternative 0054D35585257F73_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/11/2016 05:43:04 AM:<br><br>&gt; <br>&gt; Hi Stefan,<br>&gt; <b=
r>&gt; This is something I would like discuss and get other points of views=
.<br>&gt; <br>&gt; The thing that I would like to rise is the name of this =
new subsystem.<br>&gt; The keyword 'vTPM' is already heavily referenced in =
contexts for more<br>&gt; &quot;full stack&quot; solution of virtualization=
 [1].<br>&gt; <br>&gt; If I look at this new functionality it is essentiall=
y a proxy and
not<br>&gt; much else, isn't it? You can apply for Linux containers but alo=
ne
it is<br>&gt; proxy tool. With the current name it is too easy to confuse i=
t with<br>&gt; existing solutions.</font></tt><br><br><tt><font size=3D2>Fi=
ne by me. I can rename it to tpm=5Fproxy.c and reference
to it as the virtual TPM proxy driver or TPM emulator proxy driver, which
I think describes it well. It's not a 'Proxy TPM'.</font></tt><br><tt><font=
 size=3D2>The title of the cover letter for the patches would
then be</font></tt><br><br><font size=3D2 face=3D"sans-serif"><b>Multi-inst=
ance vTPM proxy driver</b></font><br><br><tt><font size=3D2>&nbsp; Stefan</=
font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; Maybe we should call it =
Proxy TPM instead (I'm open for other name<br>&gt; suggestions)?<br>&gt; <b=
r>&gt; [1] </font></tt><a href=3Dhttp://domino.research.ibm.com/library/cyb=
erdig.nsf/><tt><font size=3D2>http://domino.research.ibm.com/library/cyberd=
ig.nsf/</font></tt></a><tt><font size=3D2><br>&gt; 1e4115aea78b6e7c85256b36=
0066f0d4/a0163fff5b1a61fe85257178004eee39?OpenDocument<br>&gt; <br>&gt; /Ja=
rkko<br>&gt; <br></font></tt><BR>
--=_alternative 0054D35585257F73_=--



--===============8772502739584882392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
--===============8772502739584882392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8772502739584882392==--
