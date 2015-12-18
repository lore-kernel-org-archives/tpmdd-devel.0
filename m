From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 10:03:31 -0500
Message-ID: <201512181503.tBIF3diB018165@d03av04.boulder.ibm.com>
References: <1450021353-8775-1-git-send-email-jarkko.sakkinen@linux.intel.com><C5A28EF7B98F574C85C70238C8E9ECC04E682BF194@ABGEX74E.FSC.NET><20151214095830.GA21291@intel.com><C5A28EF7B98F574C85C70238C8E9ECC04E682BF197@ABGEX74E.FSC.NET><20151214112501.GA26100@intel.com><C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET><20151215233237.GA31965@obsidianresearch.com><201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com><20151216171633.GB32594@obsidianresearch.com><201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com><20151216174523.GC32594@obsidianresearch.com><201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2895835971202319208=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <C5A28EF7B98F574C85C70238C8E9ECC04E69407545-bIoXcEM4pvRAuK1PVaBULA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2895835971202319208==
Content-Type: multipart/alternative;
	boundary="=_alternative 0052B90385257F1F_="


--=_alternative 0052B90385257F1F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

> From: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>

> I am glad that this disucssion is gaining momentum. Whether to do
> resource arbitration in user or kernel space is an important question
> that should be discussed broadly.

I am too.  Putting the resource manager in the kernel make the design so=20
much=20
cleaner than a resource manager in user space, another smaller one in the=20
kernel,=20
and communications hacks to make it hopefully work

> > > If the kernel takes over TSS's role of virtualization then we don't
> > > need TSS in user space any more. Multiple opens is a missing peice
> > to replace tss.

Just to be clear on TCG terminology, there is a "TSS" library per=20
application,
in user space, that handles crypto and the forming of the command byte=20
stream.
Whatever the RM solution, you still need that TSS.  2-3 solutions are=20
already
open sourced.

There is one (or a layered) "Resource Manager" that schedules application=20
access
to the TPM, does resource swapping, handle virtualization, and much more.




--=_alternative 0052B90385257F1F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>&gt; From: &quot;Wilck, Martin&quot; &lt;martin.wilck@ts=
.fujitsu.com&gt;</font></tt><br><tt><font size=3D2><br>&gt; I am glad that =
this disucssion is gaining momentum. Whether to do<br>&gt; resource arbitra=
tion in user or kernel space is an important question<br>&gt; that should b=
e discussed broadly.</font></tt><br><br><tt><font size=3D2>I am too. &nbsp;=
Putting the resource manager in the
kernel make the design so much </font></tt><br><tt><font size=3D2>cleaner t=
han a resource manager in user space, another
smaller one in the kernel, </font></tt><br><tt><font size=3D2>and communica=
tions hacks to make it hopefully work</font></tt><br><tt><font size=3D2><br=
>&gt; &gt; &gt; If the kernel takes over TSS's role of virtualization then
we don't<br>&gt; &gt; &gt; need TSS in user space any more. Multiple opens =
is a missing
peice<br>&gt; &gt; to replace tss.<br></font></tt><br><tt><font size=3D2>Ju=
st to be clear on TCG terminology, there is a &quot;TSS&quot;
library per application,</font></tt><br><tt><font size=3D2>in user space, t=
hat handles crypto and the forming
of the command byte stream.</font></tt><br><tt><font size=3D2>Whatever the =
RM solution, you still need that TSS.
&nbsp;2-3 solutions are already</font></tt><br><tt><font size=3D2>open sour=
ced.</font></tt><br><br><tt><font size=3D2>There is one (or a layered) &quo=
t;Resource Manager&quot;
that schedules application access</font></tt><br><tt><font size=3D2>to the =
TPM, does resource swapping, handle virtualization,
and much more.<br><br></font></tt><BR>
--=_alternative 0052B90385257F1F_=--



--===============2895835971202319208==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============2895835971202319208==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2895835971202319208==--
