From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 0/7] Rework of tpm_tis to share common
 logic across phy's (lpc/spi/-i2c-)
Date: Thu, 26 May 2016 09:19:23 -0400
Message-ID: <20160526131931.D7856AE043@b01ledav005.gho.pok.ibm.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
	<20160526122635.GA31557@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3501238127210740890=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160526122635.GA31557-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============3501238127210740890==
Content-Type: multipart/alternative;
	boundary="=_alternative 004931D885257FBF_="


--=_alternative 004931D885257FBF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 05/26/2016=20
08:26:35 AM:

>=20
> Stefan, Peter,
>=20
> Would it be possible for you to smoke test this patch set?

I tested ACPI S3 suspend/resume, running a test suite on /dev/tpm0=20
(TPM=5FTIS), and running the vTPM test suite. These tests were done on=20
today's master of your tree on infradead. All tests passed.

Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

   Stefan



--=_alternative 004931D885257FBF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 05/26/2016 08:26:35 AM:<br><br>&gt; <br>&gt; Stefan, Peter,<br>&gt=
; <br>&gt; Would it be possible for you to smoke test this patch set?</font=
></tt><br><br><tt><font size=3D2>I tested ACPI S3 suspend/resume, running a=
 test suite
on /dev/tpm0 (TPM=5FTIS), and running the vTPM test suite. These tests were
done on today's master of your tree on infradead. All tests passed.</font><=
/tt><br><br><tt><font size=3D2>Tested-by: Stefan Berger &lt;stefanb@linux.v=
net.ibm.com&gt;</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</=
font></tt><br><BR>
--=_alternative 004931D885257FBF_=--



--===============3501238127210740890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
--===============3501238127210740890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3501238127210740890==--
