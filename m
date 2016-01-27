From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 07:17:17 -0500
Message-ID: <201601271217.u0RCHRPe017929@d03av04.boulder.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdGB9031710@d01av04.pok.ibm.com>
	<20160127023603.GA23863@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2772149113711409476=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127023603.GA23863-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2772149113711409476==
Content-Type: multipart/alternative;
	boundary="=_alternative 0043811C85257F47_="


--=_alternative 0043811C85257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/26/2016=20
09:36:03 PM:

>=20
> On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
> > > Presumably some namespace magic can be used to make them show up as
> > > tpm0 in a container?
> >=20
> > The magic is to have the container management stack create the device=20
pair.
> > From the ioctl it learns the name of the devices that were created
> and it then
> > finds out about the major/minor number of the created device and=20
> have /dev/tpm0
> > with that major/minor created in the container's /dev directory.
>=20
> Is the device created before container launched? I would assume that
> this would work user space accesses through /dev/tpm0.

Yes, device would be created before container is launched.

>=20
> I don't know how this would work for kernel clients.

For IMA we have these additional ioctls to either 'reserve' a vTPM for a=20
container before clone() or to hook the vTPM up to a IMA namespace after=20
clone() -- you may have read the discussions about these in other emails.=20
As for trusted and encrypted keys and the TPM based RNG, the kernel=20
determines the current IMA namespace a process that wants to use the=20
kernel service is associated with. It then uses the TPM associated with=20
the IMA namespace or returns an error if there is none.

   Stefan

>=20
> /Jarkko
>=20



--=_alternative 0043811C85257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/26/2016 09:36:03 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:<br=
>&gt; &gt; &gt; Presumably some namespace magic can be used to make them
show up as<br>&gt; &gt; &gt; tpm0 in a container?<br>&gt; &gt; <br>&gt; &gt=
; The magic is to have the container management stack create the
device pair.<br>&gt; &gt; From the ioctl it learns the name of the devices =
that were created<br>&gt; and it then<br>&gt; &gt; finds out about the majo=
r/minor number of the created device
and <br>&gt; have /dev/tpm0<br>&gt; &gt; with that major/minor created in t=
he container's /dev directory.<br>&gt; <br>&gt; Is the device created befor=
e container launched? I would assume that<br>&gt; this would work user spac=
e accesses through /dev/tpm0.</font></tt><br><br><tt><font size=3D2>Yes, de=
vice would be created before container is launched.</font></tt><br><tt><fon=
t size=3D2><br>&gt; <br>&gt; I don't know how this would work for kernel cl=
ients.</font></tt><br><br><tt><font size=3D2>For IMA we have these addition=
al ioctls to either
'reserve' a vTPM for a container before clone() or to hook the vTPM up
to a IMA namespace after clone() -- you may have read the discussions about
these in other emails. As for trusted and encrypted keys and the TPM based
RNG, the kernel determines the current IMA namespace a process that wants
to use the kernel service is associated with. It then uses the TPM associat=
ed
with the IMA namespace or returns an error if there is none.</font></tt><br=
><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=
=3D2><br>&gt; <br>&gt; /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 0043811C85257F47_=--



--===============2772149113711409476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============2772149113711409476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2772149113711409476==--
