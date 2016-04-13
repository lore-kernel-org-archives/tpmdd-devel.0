From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Wed, 13 Apr 2016 07:24:05 -0400
Message-ID: <201604131124.u3DBONR5003501@d03av02.boulder.ibm.com>
References: <57068198.6050407@linux.vnet.ibm.com>
	<20160411084358.GB11322@intel.com>
	<20160411181403.GB371@obsidianresearch.com>
	<201604111933.u3BJXErj001305@d03av03.boulder.ibm.com>
	<20160411202811.GA3663@obsidianresearch.com>
	<201604112030.u3BKUeJQ017181@d01av04.pok.ibm.com>
	<20160411205718.GC3663@obsidianresearch.com>
	<201604112213.u3BMD3i5028908@d03av02.boulder.ibm.com>
	<20160412000500.GC5861@obsidianresearch.com>
	<201604121512.u3CFCULH013445@d01av05.pok.ibm.com>
	<20160412175439.GB5759@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3171791004693727549=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160412175439.GB5759-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============3171791004693727549==
Content-Type: multipart/alternative;
	boundary="=_alternative 003EA91C85257F94_="


--=_alternative 003EA91C85257F94_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 04/12/2016=20
01:54:40 PM:

>=20
> On Tue, Apr 12, 2016 at 11:18:20AM -0400, Stefan Berger wrote:
> >    > Stick it before the TPM=5FCHIP=5FFLAG=5FVIRTUAL patch and throw aw=
ay=20
most of
> >    > that patch. Just add two flag checks into=20
tpm=5Fadd/del=5Flegacy=5Fsysfs()
>=20
> >    Here's the v10 series now. If you want a better text for that=20
patch,
> >    please let me know.
>=20
> Sure. I noticed a few other things, full tidied patch below, thanks for
> taking this on.
>=20
> >    I had to extend it to tpm-interface.c
> >    [2]https://github.com/stefanberger/linux/commits/vtpm-driver.v10
>=20
> Yes, that looks right, thanks

Updated it with your patch and the ioctl fix.


>=20
> >    The patches pass my test suite and tpm tis seems to also work fine.
> >    [3]https://github.com/stefanberger/linux-vtpm-tests
>=20
> >    > +   rc =3D =5F=5Fcompat=5Fonly=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(
> >    > +      &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
> >    > +   if (rc && rc !=3D -ENOENT)
> >    > +      goto out=5Ferr;
> >    I wonder whether it is necessary to goto out=5Ferr or not just retur=
n=20
rc
> >    here?
>=20
> Correct
>=20
> Good catch on the tpm=5Fpm=5F functions too
>=20
> >    Also, for tpm0 I now find the following two pcrs entries, as well=20
as
> >    all the rest of course:
> >    /sys/devices/pnp0/00:05/tpm/tpm0/pcrs
> >    /sys/devices/pnp0/00:05/pcrs
> >    Is this intentionately?
>=20
> Yes, the expectation is that the legacy path
> '/sys/devices/pnp0/00:05/pcrs' is a symlink to the new path
> '/sys/devices/pnp0/00:05/tpm/tpm0/pcrs'
>=20
> I assume you saw that all the symlinks were working?

Yes, all are working.

   Stefan



--=_alternative 003EA91C85257F94_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 04/12/2016 01:54:40 PM:<br><br>&gt; <br>&gt; On Tue, Apr 12, 2016 =
at 11:18:20AM -0400, Stefan Berger wrote:<br>&gt; &gt; &nbsp; &nbsp;&gt; St=
ick it before the TPM=5FCHIP=5FFLAG=5FVIRTUAL patch
and throw away most of<br>&gt; &gt; &nbsp; &nbsp;&gt; that patch. Just add =
two flag checks into tpm=5Fadd/del=5Flegacy=5Fsysfs()<br>&gt; <br>&gt; &gt;=
 &nbsp; &nbsp;Here's the v10 series now. If you want a better
text for that patch,<br>&gt; &gt; &nbsp; &nbsp;please let me know.<br>&gt; =
<br>&gt; Sure. I noticed a few other things, full tidied patch below, thanks
for<br>&gt; taking this on.<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;I had to ext=
end it to tpm-interface.c<br>&gt; &gt; &nbsp; &nbsp;[2]</font></tt><a href=
=3D"https://github.com/stefanberger/linux/commits/vtpm-driver.v10"><tt><fon=
t size=3D2>https://github.com/stefanberger/linux/commits/vtpm-driver.v10</f=
ont></tt></a><tt><font size=3D2><br>&gt; <br>&gt; Yes, that looks right, th=
anks</font></tt><br><br><tt><font size=3D2>Updated it with your patch and t=
he ioctl fix.</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; &gt; =
&nbsp; &nbsp;The patches pass my test suite and tpm tis seems
to also work fine.<br>&gt; &gt; &nbsp; &nbsp;[3]</font></tt><a href=3D"http=
s://github.com/stefanberger/linux-vtpm-tests"><tt><font size=3D2>https://gi=
thub.com/stefanberger/linux-vtpm-tests</font></tt></a><tt><font size=3D2><b=
r>&gt; <br>&gt; &gt; &nbsp; &nbsp;&gt; + &nbsp; rc =3D =5F=5Fcompat=5Fonly=
=5Fsysfs=5Flink=5Fentry=5Fto=5Fkobj(<br>&gt; &gt; &nbsp; &nbsp;&gt; + &nbsp=
; &nbsp; &nbsp;&amp;chip-&gt;dev.parent-&gt;kobj,
&amp;chip-&gt;dev.kobj, &quot;ppi&quot;);<br>&gt; &gt; &nbsp; &nbsp;&gt; + =
&nbsp; if (rc &amp;&amp; rc !=3D -ENOENT)<br>&gt; &gt; &nbsp; &nbsp;&gt; + =
&nbsp; &nbsp; &nbsp;goto out=5Ferr;<br>&gt; &gt; &nbsp; &nbsp;I wonder whet=
her it is necessary to goto out=5Ferr
or not just return rc<br>&gt; &gt; &nbsp; &nbsp;here?<br>&gt; <br>&gt; Corr=
ect<br>&gt; <br>&gt; Good catch on the tpm=5Fpm=5F functions too<br>&gt; <b=
r>&gt; &gt; &nbsp; &nbsp;Also, for tpm0 I now find the following two pcrs
entries, as well as<br>&gt; &gt; &nbsp; &nbsp;all the rest of course:<br>&g=
t; &gt; &nbsp; &nbsp;/sys/devices/pnp0/00:05/tpm/tpm0/pcrs<br>&gt; &gt; &nb=
sp; &nbsp;/sys/devices/pnp0/00:05/pcrs<br>&gt; &gt; &nbsp; &nbsp;Is this in=
tentionately?<br>&gt; <br>&gt; Yes, the expectation is that the legacy path=
<br>&gt; '/sys/devices/pnp0/00:05/pcrs' is a symlink to the new path<br>&gt=
; '/sys/devices/pnp0/00:05/tpm/tpm0/pcrs'<br>&gt; <br>&gt; I assume you saw=
 that all the symlinks were working?</font></tt><br><br><tt><font size=3D2>=
Yes, all are working.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;St=
efan</font></tt><br><BR>
--=_alternative 003EA91C85257F94_=--



--===============3171791004693727549==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
--===============3171791004693727549==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3171791004693727549==--
