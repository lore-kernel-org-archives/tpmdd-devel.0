From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/10] Multi-instance vTPM driver
Date: Mon, 29 Feb 2016 15:30:35 -0500
Message-ID: <201602292030.u1TKUiGA021442@d03av03.boulder.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229202401.GA26296@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5017744730395674191=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160229202401.GA26296-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============5017744730395674191==
Content-Type: multipart/alternative;
	boundary="=_alternative 0070AA7885257F68_="


--=_alternative 0070AA7885257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 02/29/2016=20
03:24:01 PM:


>=20
> On Mon, Feb 29, 2016 at 12:29:46PM -0500, Stefan Berger wrote:
> > The following series of patches implements a multi-instance vTPM=20
driver
> > that can dynamically create TPM 'server' and client device pairs.
> >=20
> > Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> > and a server side file descriptor is created. The file descriptor must
> > be passed to a TPM emulator. The device driver will initialize the
> > emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> > the command durations from the device in case of a TPM 1.2. The choice
> > of emulated TPM device (1.2 or 2) must be provided with a flag in
> > the ioctl.
> >=20
> > The driver is based on James Morris's 'next' branch and uses several
> > recently posted patches from Jason and Jarkko. Some of these patches
> > needed to rebased on top of this tree.
>=20
> It is kind of hard to follow what has happend between patch set
> versions if you don't have a changelog in the cover letter.

Sorry for that. I followed your suggestion about the flags in the=20
vtpm-driver but moved the ops related to flag modifications under the=20
mutex lock.

    Stefan



--=_alternative 0070AA7885257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 02/29/2016 03:24:01 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Feb 29, 2016 at 12:29:46PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; The following series of patches implements a multi-instance =
vTPM
driver<br>&gt; &gt; that can dynamically create TPM 'server' and client dev=
ice pairs.<br>&gt; &gt; <br>&gt; &gt; Using an ioctl on the provided /dev/v=
tpmx, a client-side vTPM
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
n James Morris's 'next' branch and uses
several<br>&gt; &gt; recently posted patches from Jason and Jarkko. Some of=
 these
patches<br>&gt; &gt; needed to rebased on top of this tree.<br>&gt; <br>&gt=
; It is kind of hard to follow what has happend between patch set<br>&gt; v=
ersions if you don't have a changelog in the cover letter.</font></tt><br><=
br><tt><font size=3D2>Sorry for that. I followed your suggestion about the
flags in the vtpm-driver but moved the ops related to flag modifications
under the mutex lock.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; S=
tefan</font></tt><br><BR>
--=_alternative 0070AA7885257F68_=--



--===============5017744730395674191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
--===============5017744730395674191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5017744730395674191==--
