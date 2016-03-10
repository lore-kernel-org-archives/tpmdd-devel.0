From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 06/11] tpm: Replace device
 number	bitmap with IDR
Date: Thu, 10 Mar 2016 11:26:38 -0500
Message-ID: <201603101626.u2AGQiqG015119@d03av01.boulder.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com><1457545170-30120-7-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160310132156.GA16320@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8398061938293465046=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160310132156.GA16320-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============8398061938293465046==
Content-Type: multipart/alternative;
	boundary="=_alternative 005A556F85257F72_="


--=_alternative 005A556F85257F72_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/10/2016=20
08:21:56 AM:

> From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Date: 03/10/2016 08:22 AM
> Subject: Re: [tpmdd-devel] [PATCH v6 06/11] tpm: Replace device=20
> number bitmap with IDR
>=20
> Hi Stefan
>=20
> On Wed, Mar 09, 2016 at 12:39:25PM -0500, Stefan Berger wrote:
> > Replace the device number bitmap with IDR. Extend the number of=20
devices we
> > can create to 64k.
> > Since an IDR allows us to associate a pointer with an ID, we use this=20
now
> > to rewrite tpm=5Fchip=5Ffind=5Fget() to simply look up the chip pointer=
 by=20
the
> > given device ID.
> >=20
> > Protect the IDR calls with a mutex.
>=20
> Could you make a separate patch set of first six patches and CC them to
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and linux-security-module-u79uwXL29TaiAVqoAR/hOA@public.gmane.org

I'd rather post v7 of the whole series so that we don't have too many=20
different series flying around. I can add a comment into the cover letter=20
to request particular care for patches 1 to 6 or 7?

   Stefan



--=_alternative 005A556F85257F72_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/10/2016 08:21:56 AM:<br><br>&gt; From: Jarkko Sakkinen &lt;jark=
ko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org</font></tt><br><tt><font=
 size=3D2>&gt; Date: 03/10/2016 08:22 AM</font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v6 06/11] tpm:
Replace device <br>&gt; number bitmap with IDR</font></tt><br><tt><font siz=
e=3D2>&gt; <br>&gt; Hi Stefan<br>&gt; <br>&gt; On Wed, Mar 09, 2016 at 12:3=
9:25PM -0500, Stefan Berger wrote:<br>&gt; &gt; Replace the device number b=
itmap with IDR. Extend the number
of devices we<br>&gt; &gt; can create to 64k.<br>&gt; &gt; Since an IDR all=
ows us to associate a pointer with an ID, we
use this now<br>&gt; &gt; to rewrite tpm=5Fchip=5Ffind=5Fget() to simply lo=
ok up the chip pointer
by the<br>&gt; &gt; given device ID.<br>&gt; &gt; <br>&gt; &gt; Protect the=
 IDR calls with a mutex.<br>&gt; <br>&gt; Could you make a separate patch s=
et of first six patches and CC them
to<br>&gt; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and linux-security-module-u79uwXL29Tb/PtFMR13I2A@public.gmane.org=
el.org.</font></tt><br><br><tt><font size=3D2>I'd rather post v7 of the who=
le series so that we
don't have too many different series flying around. I can add a comment
into the cover letter to request particular care for patches 1 to 6 or
7?</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br=
><BR>
--=_alternative 005A556F85257F72_=--



--===============8398061938293465046==
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
--===============8398061938293465046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8398061938293465046==--
