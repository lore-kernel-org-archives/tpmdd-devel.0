From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] tpm: Issue a TPM2_Shutdown for
	TPM2devices.
Date: Thu, 18 May 2017 21:13:50 +0000
Message-ID: <OFBE16F6BF.0143BC70-ON00258124.00741785-00258124.00749FD3@notes.na.collabserv.com>
References: <CAHSjozBoysvjHh_4hKuE8v7Sq3L9LjmZEcpCb_SZ=g63GpS7Aw@mail.gmail.com>,
	<20170516000852.28400-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7493000086954094751=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAHSjozBoysvjHh_4hKuE8v7Sq3L9LjmZEcpCb_SZ=g63GpS7Aw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============7493000086954094751==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<div class=3D"socmaildefaultfont" dir=3D"ltr" style=3D"font-family:Arial, H=
elvetica, sans-serif;font-size:10.5pt" ><div dir=3D"ltr" >Does it work when=
 doing suspend (to RAM) and tpm=5Fpm=5Fsuspend sent a tpm2=5Fshutdown(chip,=
 TPM2=5FSU=5FSTATE) presumably before that?</div>
<div dir=3D"ltr" >&nbsp;</div>
<div dir=3D"ltr" >&nbsp;&nbsp;&nbsp; Stefan</div>
<div dir=3D"ltr" >&nbsp;</div>
<blockquote data-history-content-modified=3D"1" dir=3D"ltr" style=3D"border=
-left:solid #aaaaaa 2px; margin-left:5px; padding-left:5px; direction:ltr; =
margin-right:0px" >----- Original message -----<br>From: Josh Zimmerman &lt=
;joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org&gt;<br>To: Peter Huewe &lt;peterhuewe-Mmb7MZpHnFY@public.gmane.org&gt;, Marcel =
Selhorst &lt;tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org&gt;, Jarkko Sakkinen &lt;jarkko.sakkinen@li=
nux.intel.com&gt;, Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;,=
 tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>Cc: Greg Kroah-Hartman &lt;gregkh@lin=
uxfoundation.org&gt;<br>Subject: Re: [tpmdd-devel] [PATCH v3] tpm: Issue a =
TPM2=5FShutdown for TPM2 devices.<br>Date: Thu, May 18, 2017 11:22 AM<br>&n=
bsp;
<div><font size=3D"2" face=3D"Default Monospace,Courier New,Courier,monospa=
ce" >Are there any other changes I should make to this patch, or is it good=
<br>to go once the patch it depends on is in?<br><br>Thanks!<br>Josh<br><br=
><br>On Mon, May 15, 2017 at 5:08 PM, Josh Zimmerman &lt;joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org&g=
t; wrote:<br>&gt; If a TPM2 loses power without a TPM2=5FShutdown command b=
eing issued (a<br>&gt; "disorderly reboot"), it may lose some state that ha=
s yet to be<br>&gt; persisted to NVRam, and will increment the DA counter (=
eventually, this<br>&gt; will cause the TPM to lock the user out.)<br>&gt;<=
br>&gt; NOTE: This only changes behavior on TPM2 devices. Since TPM1 uses s=
ysfs,<br>&gt; and sysfs relies on implicit locking on chip-&gt;ops, it is n=
ot safe to<br>&gt; allow this code to run in TPM1, or to add sysfs support =
to TPM2, until<br>&gt; that locking is made explicit.<br>&gt;<br>&gt; This =
patch is dependent on '[PATCH] Add "shutdown" to "struct class".'<br>&gt; <=
a href=3D"http://marc.info/?l=3Dlinux-kernel&amp;m=3D149463235025420&amp;w=
=3D2" target=3D"=5Fblank" >http://marc.info/?l=3Dlinux-kernel&amp;m=3D14946=
3235025420&amp;w=3D2</a><br>&gt;<br>&gt; Signed-off-by: Josh Zimmerman &lt;=
joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org&gt;<br>&gt;<br>&gt; ----<br>&gt; v2:<br>&gt; &nbsp; - Prop=
erly split changes between this and another commit<br>&gt; &nbsp; - Use pro=
per locking primitive.<br>&gt; &nbsp; - Fix commenting style<br>&gt; v3:<br=
>&gt; &nbsp; - Re-fix commenting style<br>&gt; ---<br>&gt; &nbsp;drivers/ch=
ar/tpm/tpm-chip.c &nbsp;| 20 ++++++++++++++++++++<br>&gt; &nbsp;drivers/cha=
r/tpm/tpm-sysfs.c | &nbsp;3 +++<br>&gt; &nbsp;2 files changed, 23 insertion=
s(+)<br>&gt;<br>&gt; diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/cha=
r/tpm/tpm-chip.c<br>&gt; index 9dec9f551b83..272a42e77574 100644<br>&gt; --=
- a/drivers/char/tpm/tpm-chip.c<br>&gt; +++ b/drivers/char/tpm/tpm-chip.c<b=
r>&gt; @@ -142,6 +142,25 @@ static void tpm=5Fdevs=5Frelease(struct device =
*dev)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; put=5Fdevice(&amp;chip-&gt;dev);<=
br>&gt; &nbsp;}<br>&gt;<br>&gt; +static void tpm=5Fshutdown(struct device *=
dev)<br>&gt; +{<br>&gt; + &nbsp; &nbsp; &nbsp; struct tpm=5Fchip *chip =3D =
container=5Fof(dev, struct tpm=5Fchip, dev);<br>&gt; + &nbsp; &nbsp; &nbsp;=
 /* TPM 2.0 requires that the TPM2=5FShutdown() command be issued prior to<=
br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp;* loss of power. If it is not, the DA =
counter will be incremented and,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp;* eve=
ntually, the user will be locked out of their TPM.<br>&gt; + &nbsp; &nbsp; =
&nbsp; &nbsp;* XXX: This codepath relies on the fact that sysfs is not enab=
led for<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp;* TPM2: sysfs uses an implicit=
 lock on chip-&gt;ops, so this use could<br>&gt; + &nbsp; &nbsp; &nbsp; &nb=
sp;* race if TPM2 has sysfs support enabled before TPM sysfs's implicit<br>=
&gt; + &nbsp; &nbsp; &nbsp; &nbsp;* locking is fixed.<br>&gt; + &nbsp; &nbs=
p; &nbsp; &nbsp;*/<br>&gt; + &nbsp; &nbsp; &nbsp; if (chip-&gt;flags &amp; =
TPM=5FCHIP=5FFLAG=5FTPM2) {<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; down=5Fwrite(&amp;chip-&gt;ops=5Fsem);<br>&gt; + &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tpm2=5Fshutdown(chip, TPM=5FSU=5FCLEAR);=
<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; chip-&gt;ops =
=3D NULL;<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; up=5Fw=
rite(&amp;chip-&gt;ops=5Fsem);<br>&gt; + &nbsp; &nbsp; &nbsp; }<br>&gt; +}<=
br>&gt; +<br>&gt; &nbsp;/**<br>&gt; &nbsp; * tpm=5Fchip=5Falloc() - allocat=
e a new struct tpm=5Fchip instance<br>&gt; &nbsp; * @pdev: device to which =
the chip is associated<br>&gt; @@ -181,6 +200,7 @@ struct tpm=5Fchip *tpm=
=5Fchip=5Falloc(struct device *pdev,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; de=
vice=5Finitialize(&amp;chip-&gt;devs);<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; chip-&gt;dev.class =3D tpm=5Fclass;<br>&gt; + &nbsp; &nbsp; &nbsp; =
chip-&gt;dev.class.shutdown =3D tpm=5Fshutdown;<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; chip-&gt;dev.release =3D tpm=5Fdev=5Frelease;<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; chip-&gt;dev.parent =3D pdev;<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; chip-&gt;dev.groups =3D chip-&gt;groups;<br>&gt; diff --git a/driver=
s/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c<br>&gt; index 55405db=
e43fa..5e5ff7eb6f7e 100644<br>&gt; --- a/drivers/char/tpm/tpm-sysfs.c<br>&g=
t; +++ b/drivers/char/tpm/tpm-sysfs.c<br>&gt; @@ -294,6 +294,9 @@ static co=
nst struct attribute=5Fgroup tpm=5Fdev=5Fgroup =3D {<br>&gt;<br>&gt; &nbsp;=
void tpm=5Fsysfs=5Fadd=5Fdevice(struct tpm=5Fchip *chip)<br>&gt; &nbsp;{<br=
>&gt; + &nbsp; &nbsp; &nbsp; /* XXX: Before this restriction is removed, tp=
m=5Fsysfs must be updated<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp;* to explici=
tly lock chip-&gt;ops.<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp;*/<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; if (chip-&gt;flags &amp; TPM=5FCHIP=5FFLAG=5FTPM2)<=
br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return;<br>=
&gt;<br>&gt; --<br>&gt; 2.13.0.303.g4ebf302169-goog<br>&gt;<br><br>--------=
----------------------------------------------------------------------<br>C=
heck out the vibrant tech community on one of the world's most<br>engaging =
tech sites, Slashdot.org! <a href=3D"http://sdm.link/slashdot" target=3D"=
=5Fblank" >http://sdm.link/slashdot</a><br>=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>tpmdd-devel mailing list<br>tpmdd-d=
evel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br><a href=3D"https://lists.sourceforge.net/list=
s/listinfo/tpmdd-devel" target=3D"=5Fblank" >https://lists.sourceforge.net/=
lists/listinfo/tpmdd-devel</a></font><br>&nbsp;</div></blockquote>
<div dir=3D"ltr" >&nbsp;</div></div><BR>



--===============7493000086954094751==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============7493000086954094751==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7493000086954094751==--
