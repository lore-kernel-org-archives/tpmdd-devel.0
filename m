From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Wed, 17 Feb 2016 22:52:00 -0500
Message-ID: <201602180352.u1I3qLRX011411@d01av02.pok.ibm.com>
References: <20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
	<201602121813.u1CIDu4O015272@d01av01.pok.ibm.com>
	<20160212183415.GA4289@obsidianresearch.com>
	<201602140637.u1E6baNX028563@d03av04.boulder.ibm.com>
	<201602161648.u1GGmdZv000468@d01av03.pok.ibm.com>
	<20160216180028.GA4967@obsidianresearch.com>
	<201602161927.u1GJRJL6016216@d01av01.pok.ibm.com>
	<20160217044750.GB25049@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6605211547769931468=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160217044750.GB25049-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6605211547769931468==
Content-Type: multipart/alternative;
	boundary="=_alternative 0015463E85257F5D_="


--=_alternative 0015463E85257F5D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/16/2016=20
11:47:50 PM:


>=20
> On Tue, Feb 16, 2016 at 02:26:56PM -0500, Stefan Berger wrote:
> > The re-ordering of the tpm=5Fchip and vtpm=5Fdev release actually solve=
d=20
that
> > problem.
>=20
> ? You mean you don't see the lock up because there is no error unwind?
>=20
> > [My feeling is, something outside of the vtpm driver doesn't unroll=20
properly
> > and locks up if there's lots of concurrency].
>=20
> Hum, I'd be surprised if this is not caused by something outside=20
tpm/vtpm..
> It would be very nice to know, but perhaps not essential. I didn't see
> anything obvious in vtpm either.
>=20
> > > One other thing you can look at is ditching the vtpm struct
> > > device. With the last patches I sent the tpm core would only need=20
two
> > > more lines to work with a null parent device, which would be even
> > > simpler for vtpm.
> >=20
> > Not having a parent device isn't really necessary, except for not=20
having it
> > appear in sysfs maybe?
>=20
> Dropping the dummy parent out of vtpm makes it work a little more more
> like the rest of the virtual stuff and slightly changes the sysfs
> paths visble to user space. If this is the right way to go it would be
> great to do that at the start. It wasn't worth bringing up before, but
> now that I wrote the parent removal patch it is pretty trivial.

Beside the code to lock the module with the parent device, the=20
chip->dev.parent is used in sysfs API calls. Using the chip->dev.kobj=20
there in case chip->dev.parent is NULL also seems a way to hang the=20
system.

   Stefan




--=_alternative 0015463E85257F5D_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/16/2016 11:47:50 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Tue, Feb 16, 2016 at 02:26:56PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; The re-ordering of the tpm=5Fchip and vtpm=5Fdev release act=
ually
solved that<br>&gt; &gt; problem.<br>&gt; <br>&gt; ? You mean you don't see=
 the lock up because there is no error unwind?<br>&gt; <br>&gt; &gt; [My fe=
eling is, something outside of the vtpm driver doesn't
unroll properly<br>&gt; &gt; and locks up if there's lots of concurrency].<=
br>&gt; <br>&gt; Hum, I'd be surprised if this is not caused by something o=
utside tpm/vtpm..<br>&gt; It would be very nice to know, but perhaps not es=
sential. I didn't
see<br>&gt; anything obvious in vtpm either.<br>&gt; <br>&gt; &gt; &gt; One=
 other thing you can look at is ditching the vtpm struct<br>&gt; &gt; &gt; =
device. With the last patches I sent the tpm core would
only need two<br>&gt; &gt; &gt; more lines to work with a null parent devic=
e, which would
be even<br>&gt; &gt; &gt; simpler for vtpm.<br>&gt; &gt; <br>&gt; &gt; Not =
having a parent device isn't really necessary, except for
not having it<br>&gt; &gt; appear in sysfs maybe?<br>&gt; <br>&gt; Dropping=
 the dummy parent out of vtpm makes it work a little more
more<br>&gt; like the rest of the virtual stuff and slightly changes the sy=
sfs<br>&gt; paths visble to user space. If this is the right way to go it w=
ould
be<br>&gt; great to do that at the start. It wasn't worth bringing up befor=
e,
but<br>&gt; now that I wrote the parent removal patch it is pretty trivial.=
</font></tt><br><br><tt><font size=3D2>Beside the code to lock the module w=
ith the parent
device, the chip-&gt;dev.parent is used in sysfs API calls. Using the chip-=
&gt;dev.kobj
there in case chip-&gt;dev.parent is NULL also seems a way to hang the
system.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></t=
t><br><br><BR>
--=_alternative 0015463E85257F5D_=--



--===============6605211547769931468==
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
--===============6605211547769931468==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6605211547769931468==--
