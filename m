From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG,
 bisect] tpm: Remove all uses of drvdata from the TPM Core
Date: Wed, 11 May 2016 06:27:52 -0400
Message-ID: <201605111027.u4BARvlO022608@d01av04.pok.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160510135523.GA1943@hudson.localdomain>
	<201605101505.u4AF5nHd032349@d03av04.boulder.ibm.com>
	<20160511012617.GA4657@hudson.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7921826616236617272=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160511012617.GA4657-ZO/ZziT/ZXRSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7921826616236617272==
Content-Type: multipart/alternative;
	boundary="=_alternative 00397FF385257FB0_="


--=_alternative 00397FF385257FB0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 05/10/2016 09:26:17 PM:


>=20
> Stefan,
>=20
> On Tue, May 10, 2016 at 11:05:43AM -0400, Stefan Berger wrote:
> > Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 05/10/2016 09:55:23 AM:
> >=20
> > >=20
> > > all,
> > >=20
> > > My machine is locking up during suspend and I have bisected the
> > > problem to this patch (e89f8b1ade9cc1a) in the latest linux-next
> > > (20160506) kernel.
> > >=20
> > > Let me know if I can test patches or do anything else to help.
> >=20
> > The chip retrieval method in the pm functions is wrong. Sending patch.
> >=20
> >    Stefan
> >=20
> >=20
>=20
> Thanks for the quick reply Stefan.  Let me know when you have a
> patch for me to test.


I forgot to cc you on the patch and obviously you weren't cc'ed through=20
the Reported-by: line.

Here's a pointer to the patch.

http://thread.gmane.org/gmane.comp.encryption.tpmdd.devel/974


Thanks for testing and bisecting.

Regards,
    Stefan

>=20
> --=20
> - Jeremiah Mahler
>=20



--=_alternative 00397FF385257FB0_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jeremiah Mahler &lt;jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt; wrote on 05/1=
0/2016
09:26:17 PM:<br><br></font></tt><br><tt><font size=3D2>&gt; <br>&gt; Stefan=
,<br>&gt; <br>&gt; On Tue, May 10, 2016 at 11:05:43AM -0400, Stefan Berger =
wrote:<br>&gt; &gt; Jeremiah Mahler &lt;jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt; wrote on 05/=
10/2016
09:55:23 AM:<br>&gt; &gt; <br>&gt; &gt; &gt; <br>&gt; &gt; &gt; all,<br>&gt=
; &gt; &gt; <br>&gt; &gt; &gt; My machine is locking up during suspend and =
I have bisected
the<br>&gt; &gt; &gt; problem to this patch (e89f8b1ade9cc1a) in the latest=
 linux-next<br>&gt; &gt; &gt; (20160506) kernel.<br>&gt; &gt; &gt; <br>&gt;=
 &gt; &gt; Let me know if I can test patches or do anything else to
help.<br>&gt; &gt; <br>&gt; &gt; The chip retrieval method in the pm functi=
ons is wrong. Sending
patch.<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;Stefan<br>&gt; &gt; <br>&gt;=
 &gt; <br>&gt; <br>&gt; Thanks for the quick reply Stefan. &nbsp;Let me kno=
w when you have
a<br>&gt; patch for me to test.</font></tt><br><br><br><tt><font size=3D2>I=
 forgot to cc you on the patch and obviously you
weren't cc'ed through the Reported-by: line.</font></tt><br><br><tt><font s=
ize=3D2>Here's a pointer to the patch.</font></tt><br><br><a href=3Dhttp://=
thread.gmane.org/gmane.comp.encryption.tpmdd.devel/974><tt><font size=3D2 c=
olor=3Dblue>http://thread.gmane.org/gmane.comp.encryption.tpmdd.devel/974</=
font></tt></a><br><br><br><tt><font size=3D2>Thanks for testing and bisecti=
ng.</font></tt><br><br><tt><font size=3D2>Regards,</font></tt><br><tt><font=
 size=3D2>&nbsp; &nbsp; Stefan</font></tt><br><tt><font size=3D2><br>&gt; <=
br>&gt; -- <br>&gt; - Jeremiah Mahler<br>&gt; <br></font></tt><BR>
--=_alternative 00397FF385257FB0_=--



--===============7921826616236617272==
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
--===============7921826616236617272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7921826616236617272==--
