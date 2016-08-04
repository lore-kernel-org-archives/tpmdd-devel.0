From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Latest tip of the tree issues
Date: Thu, 4 Aug 2016 11:40:48 -0400
Message-ID: <OF39017581.C0F42D48-ON00258005.0054AEBE-85258005.00562C33@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1533729267648652942=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1533729267648652942==
Content-Type: multipart/alternative;
	boundary="=_alternative 00562C3385258005_="


--=_alternative 00562C3385258005_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko,

  when building the latest tree I have the following two issues when=20
building with modules:=20

- missing exported symbols tpm=5Fgetcap and tpm2=5Fget=5Ftpm=5Fpt. See the =
patch=20
below that should be squashed into the patch(es) that introduced the=20
problem (so one can bisect)

- the probing of TPM 1.2 doesn't work anymore ; the bad patch seems to be=20
the tip:

commit 783fa18d7bb7bac20b8591cf575418fce31dd397
Author: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date:   Fri Jun 17 13:12:20 2016 +0200

    tpm: use tpm=5Fpcr=5Fread=5Fdev() in tpm=5Fdo=5Fselftest()
=20
    Instead of a  ad-hoc protocol message construction it is better to
    call tpm=5Fpcr=5Fread=5Fdev().
=20
    Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
    Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>


# dmesg | grep tpm
[    4.385205] tpm=5Ftis 00:05: 1.2 TPM (device-id 0x1, rev-id 1)
[    4.424537] tpm tpm0: TPM self test failed
[    4.426630] tpm=5Ftis: probe of 00:05 failed with error -14

The reason for this is that rc in the following is 0.

       do {
                /* Attempt to read a PCR value */
                rc =3D tpm=5Fpcr=5Fread=5Fdev(chip, 0, dummy);

Looking at tpm=5Fpcr=5Fread=5Fdev, returning 0 is quite ok.

Stefan



diff --git a/drivers/char/tpm/tpm-interface.c=20
b/drivers/char/tpm/tpm-interface.c
index f43cc3f..3722fc0 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -458,6 +458,7 @@ ssize=5Ft tpm=5Fgetcap(struct tpm=5Fchip *chip, =5F=5Fb=
e32=20
subcap=5Fid, cap=5Ft *cap,
                *cap =3D tpm=5Fcmd.params.getcap=5Fout.cap;
        return rc;
 }
+EXPORT=5FSYMBOL=5FGPL(tpm=5Fgetcap);
=20
 #define TPM=5FORD=5FSTARTUP cpu=5Fto=5Fbe32(153)
 #define TPM=5FST=5FCLEAR cpu=5Fto=5Fbe16(1)
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index e1db404..499f405 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -707,6 +707,7 @@ ssize=5Ft tpm2=5Fget=5Ftpm=5Fpt(struct tpm=5Fchip *chip=
, u32=20
property=5Fid,  u32 *value,
=20
        return rc;
 }
+EXPORT=5FSYMBOL=5FGPL(tpm2=5Fget=5Ftpm=5Fpt);
=20
 #define TPM2=5FSTARTUP=5FIN=5FSIZE \
        (sizeof(struct tpm=5Finput=5Fheader) + \



--=_alternative 00562C3385258005_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<font size=3D2 face=3D"sans-serif">Jarkko,</font><br><br><font size=3D2 fac=
e=3D"sans-serif">&nbsp; when building the latest tree
I have the following two issues when building with modules: </font><br><br>=
<font size=3D2 face=3D"sans-serif">- missing exported symbols tpm=5Fgetcap
and tpm2=5Fget=5Ftpm=5Fpt. See the patch below that should be squashed into=
 the
patch(es) that introduced the problem (so one can bisect)</font><br><br><fo=
nt size=3D2 face=3D"sans-serif">- the probing of TPM 1.2 doesn't work
anymore ; the bad patch seems to be the tip:</font><br><br><font size=3D2 f=
ace=3D"sans-serif">commit 783fa18d7bb7bac20b8591cf575418fce31dd397</font><b=
r><font size=3D2 face=3D"sans-serif">Author: Jarkko Sakkinen &lt;jarkko.sak=
kinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font><br><font size=3D2 face=3D"sans-serif">Date=
: &nbsp; Fri Jun 17 13:12:20 2016
+0200</font><br><br><font size=3D2 face=3D"sans-serif">&nbsp; &nbsp; tpm: u=
se tpm=5Fpcr=5Fread=5Fdev()
in tpm=5Fdo=5Fselftest()</font><br><font size=3D2 face=3D"sans-serif">&nbsp=
; &nbsp; </font><br><font size=3D2 face=3D"sans-serif">&nbsp; &nbsp; Instea=
d of a &nbsp;ad-hoc
protocol message construction it is better to</font><br><font size=3D2 face=
=3D"sans-serif">&nbsp; &nbsp; call tpm=5Fpcr=5Fread=5Fdev().</font><br><fon=
t size=3D2 face=3D"sans-serif">&nbsp; &nbsp; </font><br><font size=3D2 face=
=3D"sans-serif">&nbsp; &nbsp; Signed-off-by: Jarkko
Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font><br><font size=3D2 f=
ace=3D"sans-serif">&nbsp; &nbsp; Reviewed-by: Jason Gunthorpe
&lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;</font><br><br><br><font size=3D2 fa=
ce=3D"sans-serif"># dmesg | grep tpm</font><br><font size=3D2 face=3D"sans-=
serif">[ &nbsp; &nbsp;4.385205] tpm=5Ftis 00:05:
1.2 TPM (device-id 0x1, rev-id 1)</font><br><font size=3D2 face=3D"sans-ser=
if">[ &nbsp; &nbsp;4.424537] tpm tpm0: TPM
self test failed</font><br><font size=3D2 face=3D"sans-serif">[ &nbsp; &nbs=
p;4.426630] tpm=5Ftis: probe
of 00:05 failed with error -14</font><br><br><font size=3D2 face=3D"sans-se=
rif">The reason for this is that rc in the
following is 0.</font><br><br><font size=3D2 face=3D"sans-serif">&nbsp; &nb=
sp; &nbsp; &nbsp;do {</font><br><font size=3D2 face=3D"sans-serif">&nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; /* Attempt to read a PCR value */</font><br><font size=3D2 fa=
ce=3D"sans-serif">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; rc =3D tpm=5Fpcr=5Fread=5Fdev(chip, 0, dummy);</font><br><br>=
<font size=3D2 face=3D"sans-serif">Looking at tpm=5Fpcr=5Fread=5Fdev, retur=
ning
0 is quite ok.</font><br><br><font size=3D2 face=3D"sans-serif">Stefan</fon=
t><br><br><br><br><font size=3D2 face=3D"sans-serif">diff --git a/drivers/c=
har/tpm/tpm-interface.c
b/drivers/char/tpm/tpm-interface.c</font><br><font size=3D2 face=3D"sans-se=
rif">index f43cc3f..3722fc0 100644</font><br><font size=3D2 face=3D"sans-se=
rif">--- a/drivers/char/tpm/tpm-interface.c</font><br><font size=3D2 face=
=3D"sans-serif">+++ b/drivers/char/tpm/tpm-interface.c</font><br><font size=
=3D2 face=3D"sans-serif">@@ -458,6 +458,7 @@ ssize=5Ft tpm=5Fgetcap(struct
tpm=5Fchip *chip, =5F=5Fbe32 subcap=5Fid, cap=5Ft *cap,</font><br><font siz=
e=3D2 face=3D"sans-serif">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; *cap =3D tpm=5Fcmd.params.getcap=5Fout.cap;</font><br><font s=
ize=3D2 face=3D"sans-serif">&nbsp; &nbsp; &nbsp; &nbsp; return rc;</font><b=
r><font size=3D2 face=3D"sans-serif">&nbsp;}</font><br><font size=3D2 face=
=3D"sans-serif">+EXPORT=5FSYMBOL=5FGPL(tpm=5Fgetcap);</font><br><font size=
=3D2 face=3D"sans-serif">&nbsp;</font><br><font size=3D2 face=3D"sans-serif=
">&nbsp;#define TPM=5FORD=5FSTARTUP cpu=5Fto=5Fbe32(153)</font><br><font si=
ze=3D2 face=3D"sans-serif">&nbsp;#define TPM=5FST=5FCLEAR cpu=5Fto=5Fbe16(1=
)</font><br><font size=3D2 face=3D"sans-serif">diff --git a/drivers/char/tp=
m/tpm2-cmd.c
b/drivers/char/tpm/tpm2-cmd.c</font><br><font size=3D2 face=3D"sans-serif">=
index e1db404..499f405 100644</font><br><font size=3D2 face=3D"sans-serif">=
--- a/drivers/char/tpm/tpm2-cmd.c</font><br><font size=3D2 face=3D"sans-ser=
if">+++ b/drivers/char/tpm/tpm2-cmd.c</font><br><font size=3D2 face=3D"sans=
-serif">@@ -707,6 +707,7 @@ ssize=5Ft tpm2=5Fget=5Ftpm=5Fpt(struct
tpm=5Fchip *chip, u32 property=5Fid, &nbsp;u32 *value,</font><br><font size=
=3D2 face=3D"sans-serif">&nbsp;</font><br><font size=3D2 face=3D"sans-serif=
">&nbsp; &nbsp; &nbsp; &nbsp; return rc;</font><br><font size=3D2 face=3D"s=
ans-serif">&nbsp;}</font><br><font size=3D2 face=3D"sans-serif">+EXPORT=5FS=
YMBOL=5FGPL(tpm2=5Fget=5Ftpm=5Fpt);</font><br><font size=3D2 face=3D"sans-s=
erif">&nbsp;</font><br><font size=3D2 face=3D"sans-serif">&nbsp;#define TPM=
2=5FSTARTUP=5FIN=5FSIZE \</font><br><font size=3D2 face=3D"sans-serif">&nbs=
p; &nbsp; &nbsp; &nbsp; (sizeof(struct
tpm=5Finput=5Fheader) + \</font><br><BR>
--=_alternative 00562C3385258005_=--



--===============1533729267648652942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============1533729267648652942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1533729267648652942==--
