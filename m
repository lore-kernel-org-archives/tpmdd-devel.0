From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 00/10] Multi-instance vTPM proxy driver
Date: Tue, 29 Mar 2016 11:31:05 -0500
Message-ID: <201603291631.u2TGVBxR001332@d03av04.boulder.ibm.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160329162433.GB24833@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7333724538624397130=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160329162433.GB24833-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7333724538624397130==
Content-Type: multipart/alternative;
	boundary="=_alternative 005ABD7885257F85_="


--=_alternative 005ABD7885257F85_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/29/2016=20
12:24:33 PM:

> From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: 03/29/2016 12:29 PM
> Subject: Re: [tpmdd-devel] [PATCH v8 00/10] Multi-instance vTPM proxy=20
driver
>=20
> On Sun, Mar 13, 2016 at 06:54:30PM -0400, Stefan Berger wrote:
> > The following series of patches implements a multi-instance vTPM=20
> > proxy driver that can dynamically create TPM 'server' and client=20
device
> > pairs.
> >=20
> > Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> > and a server side file descriptor is created. The file descriptor must
> > be passed to a TPM emulator. The device driver will initialize the
> > emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> > the command durations from the device in case of a TPM 1.2. The choice
> > of emulated TPM device (1.2 or 2) must be provided with a flag in
> > the ioctl.
> >=20
> > The driver is based on a recent checkout of James Morris's 'next'
> > branch and uses several recently posted patches from Jason and Jarkko.
>=20
> I don't remember if I said this but up to the IDR patch I merged patches
> to next (at the same day you sent this) so for v9 you can only include
> top four changes.


I rebased my patch set on top of your current master. Here's how it looks=20
like:

https://github.com/stefanberger/linux/commits/vtpm-driver.v9

   Stefan



--=_alternative 005ABD7885257F85_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"


<br><tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&=
gt;
wrote on 03/29/2016 12:24:33 PM:<br><br>&gt; From: Jarkko Sakkinen &lt;jark=
ko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;</font></tt><br><tt><font size=3D2>&gt; To: =
Stefan Berger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;</font></tt><br><tt><font s=
ize=3D2>&gt; Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-<br>&gt; deve=
l@lists.sourceforge.net, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</font></tt><br><tt><f=
ont size=3D2>&gt; Date: 03/29/2016 12:29 PM</font></tt><br><tt><font size=
=3D2>&gt; Subject: Re: [tpmdd-devel] [PATCH v8 00/10] Multi-instance
vTPM proxy driver</font></tt><br><tt><font size=3D2>&gt; <br>&gt; On Sun, M=
ar 13, 2016 at 06:54:30PM -0400, Stefan Berger wrote:<br>&gt; &gt; The foll=
owing series of patches implements a multi-instance vTPM
<br>&gt; &gt; proxy driver that can dynamically create TPM 'server' and cli=
ent
device<br>&gt; &gt; pairs.<br>&gt; &gt; <br>&gt; &gt; Using an ioctl on the=
 provided /dev/vtpmx, a client-side vTPM
device<br>&gt; &gt; and a server side file descriptor is created. The file =
descriptor
must<br>&gt; &gt; be passed to a TPM emulator. The device driver will initi=
alize
the<br>&gt; &gt; emulated TPM using TPM 1.2 or TPM 2 startup commands and i=
t will
read<br>&gt; &gt; the command durations from the device in case of a TPM 1.=
2. The
choice<br>&gt; &gt; of emulated TPM device (1.2 or 2) must be provided with=
 a flag
in<br>&gt; &gt; the ioctl.<br>&gt; &gt; <br>&gt; &gt; The driver is based o=
n a recent checkout of James Morris's 'next'<br>&gt; &gt; branch and uses s=
everal recently posted patches from Jason and
Jarkko.<br>&gt; <br>&gt; I don't remember if I said this but up to the IDR =
patch I merged patches<br>&gt; to next (at the same day you sent this) so f=
or v9 you can only include<br>&gt; top four changes.</font></tt><br><br><br=
><tt><font size=3D2>I rebased my patch set on top of your current master.
Here's how it looks like:</font></tt><br><br><a href=3D"https://github.com/=
stefanberger/linux/commits/vtpm-driver.v9"><tt><font size=3D2 color=3Dblue>=
https://github.com/stefanberger/linux/commits/vtpm-driver.v9</font></tt></a=
><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 005ABD7885257F85_=--



--===============7333724538624397130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
--===============7333724538624397130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7333724538624397130==--
