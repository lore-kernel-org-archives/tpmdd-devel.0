From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 11/11] A test program for vTPM
	devicecreation
Date: Thu, 10 Mar 2016 15:57:58 -0500
Message-ID: <201603102058.u2AKw6xV015494@d03av05.boulder.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-12-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1732014062755294551=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457545170-30120-12-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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


--===============1732014062755294551==
Content-Type: multipart/alternative;
	boundary="=_alternative 00732CAA85257F72_="


--=_alternative 00732CAA85257F72_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 03/09/2016 12:39:30=20
PM:
>=20
> This patch provides a program that is for testing purposes only.
>=20
> Build it using the following commands:
>=20
> make headers=5Finstall ARCH=3Dx86=5F64  INSTALL=5FHDR=5FPATH=3D/usr
>=20
> gcc vtpmctrl.c -o vtpmctrl
>=20
> To use it:
>=20
> To create a device pair and have vtpmctrl listen for commands, display
> them and respond with TPM success messages do:
>=20
> Created TPM device /dev/tpm0; vTPM device has fd 4, major/minor =3D=20
10/224.
>=20
> In another shell do
>=20
> 00000000 00 c4 00 00 00 0a 00 00 00 00
> 00000012


This test program is now available as part of a test suite at:

https://github.com/stefanberger/linux-vtpm-tests


   Stefan



--=_alternative 00732CAA85257F72_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt; wrote
on 03/09/2016 12:39:30 PM:</font></tt><br><tt><font size=3D2>&gt; <br>&gt; =
This patch provides a program that is for testing purposes only.<br>&gt; <b=
r>&gt; Build it using the following commands:<br>&gt; <br>&gt; make headers=
=5Finstall ARCH=3Dx86=5F64 &nbsp;INSTALL=5FHDR=5FPATH=3D/usr<br>&gt; <br>&g=
t; gcc vtpmctrl.c -o vtpmctrl<br>&gt; <br>&gt; To use it:<br>&gt; <br>&gt; =
To create a device pair and have vtpmctrl listen for commands, display<br>&=
gt; them and respond with TPM success messages do:<br>&gt; <br>&gt; Created=
 TPM device /dev/tpm0; vTPM device has fd 4, major/minor =3D
10/224.<br>&gt; <br>&gt; In another shell do<br>&gt; <br>&gt; 00000000 00 c=
4 00 00 00 0a 00 00 00 00<br>&gt; 00000012</font></tt><br><br><br><tt><font=
 size=3D2>This test program is now available as part of a test
suite at:</font></tt><br><br><a href=3D"https://github.com/stefanberger/lin=
ux-vtpm-tests"><tt><font size=3D2 color=3Dblue>https://github.com/stefanber=
ger/linux-vtpm-tests</font></tt></a><br><br><br><tt><font size=3D2>&nbsp; &=
nbsp;Stefan</font></tt><br><BR>
--=_alternative 00732CAA85257F72_=--



--===============1732014062755294551==
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
--===============1732014062755294551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1732014062755294551==--
