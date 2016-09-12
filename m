From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: 4b68112 causes 'Could not get TPM timeouts
	anddurations'
Date: Mon, 12 Sep 2016 11:59:49 -0400
Message-ID: <OF094E5F6F.9F1CCCDF-ON0025802C.0056E42F-8525802C.0057EE5F@notes.na.collabserv.com>
References: <OF8C8919AB.C1A2AE5E-ON0025802C.005396B8-8525802C.0053E181@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7793970490862505869=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <OF8C8919AB.C1A2AE5E-ON0025802C.005396B8-8525802C.0053E181-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "moderated list:TPM
	DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7793970490862505869==
Content-Type: multipart/alternative;
	boundary="=_alternative 0057EE5E8525802C_="


--=_alternative 0057EE5E8525802C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger/Watson/IBM@IBMUS wrote on 09/12/2016 11:15:34 AM:

>=20
> Patch 4b68112 seems like an unlikely candidate for such a failure,=20
> nevertheless that's what I am seeing: 'Could not get TPM timeouts=20
> and durations'.

Actually, the patch seems to be quite broken. tpm=5Fcmd is being read from =

after calling tpm1=5Fgetcap=5Fcmd(), but tpm=5Fcmd is not passed to that=20
function, so it wasn't touched. I am not sure how this was intended to=20
work and where the check for the returned size was going to be done.


--=_alternative 0057EE5E8525802C_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger/Watson/IBM@IBMUS wrote on 09/12/2016 11:15=
:34
AM:<br><br>&gt; <br>&gt; Patch 4b68112 seems like an unlikely candidate for=
 such a failure,
<br>&gt; nevertheless that's what I am seeing: 'Could not get TPM timeouts
<br>&gt; and durations'.</font></tt><br><br><tt><font size=3D2>Actually, th=
e patch seems to be quite broken. tpm=5Fcmd
is being read from after calling tpm1=5Fgetcap=5Fcmd(), but tpm=5Fcmd is not
passed to that function, so it wasn't touched. I am not sure how this was
intended to work and where the check for the returned size was going to
be done.</font></tt><BR>
--=_alternative 0057EE5E8525802C_=--



--===============7793970490862505869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
--===============7793970490862505869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7793970490862505869==--
