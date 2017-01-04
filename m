From: "Kenneth Goldman" <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 13:37:27 -0500
Message-ID: <OFAC076931.B5EBB915-ON8525809E.00656B6A-8525809E.00664EE7@notes.na.collabserv.com>
References: Ken Goldman <kgoldman@us.ibm.com> "Re: [tpmdd-devel] [PATCH RFC
	0/4] RFC: in-kernel resource manager" (Jan  3,  5:21pm)
	<201701041612.v04GCfPK031525@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4634870599216486367=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201701041612.v04GCfPK031525-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4634870599216486367==
Content-Type: multipart/alternative;
	boundary="=_alternative 00664E538525809E_="


--=_alternative 00664E538525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

"Dr. Greg Wettstein" <greg-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org> wrote on 01/04/2017 11:12:41 =

AM:

> The kernel needs a resource manager.  Everyone needs to think VERY
> hard and VERY, VERY carefully about what gets put into the kernel.  In
> making a decision, put the ABSOLUTE smallest amount of code into the
> kernel ...

If you're a TCG member, I invite you to join the TSS WG.  I'd like
an ally for simplicity.
=20
> Repeat incessantly to oneself, TPM1.2 and TPM2 are only similar by
> virtue of sharing three ASCII characters.

:-) I have to remember that one!

But, to be accurate, the hardware interface is nearly compatible, and
the high level concepts (key hierarchy, authorization, PCRs, BV space)=20
are similar.  The API and implementation are new.

> DO NOT rush this process.  If we do not get this right we will
> ultimately end up trying to shove something which is conceptually
> worse then tss/tscd into the kernel.

The (only?) reason to put any of this in the kernel is that the kernel
also needs access to the TPM.=20

> Pay homage to Ken, his TSS2 and TPM2 simulator work are beyond
> excellent...

Thank you.



--=_alternative 00664E538525809E_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>&quot;Dr. Greg Wettstein&quot; &lt;greg-DHO+NtfOqB5PEDpkEIzg7w@public.gmane.org=
m&gt;
wrote on 01/04/2017 11:12:41 AM:<br><br>&gt; The kernel needs a resource ma=
nager. &nbsp;Everyone needs to think
VERY<br>&gt; hard and VERY, VERY carefully about what gets put into the ker=
nel.
&nbsp;In<br>&gt; making a decision, put the ABSOLUTE smallest amount of cod=
e into the<br>&gt; kernel ...</font></tt><br><br><tt><font size=3D2>If you'=
re a TCG member, I invite you to join the TSS
WG. &nbsp;I'd like</font></tt><br><tt><font size=3D2>an ally for simplicity=
.</font></tt><br><tt><font size=3D2>&nbsp;<br>&gt; Repeat incessantly to on=
eself, TPM1.2 and TPM2 are only similar by<br>&gt; virtue of sharing three =
ASCII characters.</font></tt><br><br><tt><font size=3D2>:-) I have to remem=
ber that one!</font></tt><br><br><tt><font size=3D2>But, to be accurate, th=
e hardware interface is nearly
compatible, and</font></tt><br><tt><font size=3D2>the high level concepts (=
key hierarchy, authorization,
PCRs, BV space) </font></tt><br><tt><font size=3D2>are similar. &nbsp;The A=
PI and implementation are
new.</font></tt><br><tt><font size=3D2><br>&gt; DO NOT rush this process. &=
nbsp;If we do not get this right we will<br>&gt; ultimately end up trying t=
o shove something which is conceptually<br>&gt; worse then tss/tscd into th=
e kernel.</font></tt><br><br><tt><font size=3D2>The (only?) reason to put a=
ny of this in the kernel
is that the kernel</font></tt><br><tt><font size=3D2>also needs access to t=
he TPM. </font></tt><br><tt><font size=3D2><br>&gt; Pay homage to Ken, his =
TSS2 and TPM2 simulator work are beyond<br>&gt; excellent...</font></tt><br=
><br><tt><font size=3D2>Thank you.<br></font></tt><BR>
--=_alternative 00664E538525809E_=--



--===============4634870599216486367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
--===============4634870599216486367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4634870599216486367==--
