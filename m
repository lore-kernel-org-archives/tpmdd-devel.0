From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 15:31:13 -0500
Message-ID: <201602122031.u1CKVIqC012617@d01av04.pok.ibm.com>
References: <20160211070426.GB9307@intel.com>
	<201602111534.u1BFYvRs019573@d01av03.pok.ibm.com>
	<20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3292190909749569680=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160212184051.GB4289-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3292190909749569680==
Content-Type: multipart/alternative;
	boundary="=_alternative 0070C18085257F57_="


--=_alternative 0070C18085257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
01:40:51 PM:


>=20
> On Thu, Feb 11, 2016 at 10:56:47PM -0500, Stefan Berger wrote:
> >    Updated the branch. Are you going to upstream your patch? Otherwise =

I
> >    would just add your Signed-off-by to it if that's ok ?
>=20
> Yes, sorry about that. Just add it to your series with your
> tested-by/reviewed-by. It will need some rebasing to go on top of
> Jarkko's final patch that adds the devm=5F (just delete it from
> tpm=5Falloc and use my version for tpmm=5Falloc)
>=20
> The other thing that has come to my mind is device removal. Right now
> the tpm core is still fairly broken in that regard, and we have
> largely got away with ignoring that because drviers are rarely
> removed.
>=20
> However, you are adding something that actually requires removal to
> work and be race free, so we'll also have to fix core removal :(

Where is the race? I tested the following:

The tpm=5Fvtpm module use counter increases with every server file=20
descriptor being handed out, so every run of ./vtpmctrl increases it by 1.

Every opening of /dev/tpm%d (exec 1XY<>/dev/tpm%d) increases the tpm=5Fvtpm=
=20
module use counter also by 1.

If the vtpmctrl's die, the module use counter decreases for every vtpmctrl =

termiating. However, the use counter is still at the number of open=20
/dev/tpm%d devices.

vtpm=5Fdev and chip structures only get free'd once the file descriptor is =

close. So it looks like expected good behavior to me. We cannot remove the =

'backend' module following the usage counter increase, so this is good=20
too.

     Stefan


>=20
> The basic approach I'd suggest would be the same as what the rtc
> subsystem does.
>=20
> Add a mutex around 'chip->ops' and every place that
> uses ops has to hold the lock.
>=20
> Upon removal grab the mutex and null ops.
>=20
> Every place that graps the lock for ops has to check for null. Null
> means the device is being destroyed and the call must fail.
>=20
> Make changes to tpm=5Fchip=5Ffind=5Fget to check for null, and make it do
> put=5Fdevice. Reconsider the use of module locking there, not sure it
> makes any sense to do that if we have proper safe removal support.
>=20
> Jason
>=20



--=_alternative 0070C18085257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 01:40:51 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Thu, Feb 11, 2016 at 10:56:47PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;Updated the branch. Are you going to upstream y=
our
patch? Otherwise I<br>&gt; &gt; &nbsp; &nbsp;would just add your Signed-off=
-by to it if that's
ok ?<br>&gt; <br>&gt; Yes, sorry about that. Just add it to your series wit=
h your<br>&gt; tested-by/reviewed-by. It will need some rebasing to go on t=
op of<br>&gt; Jarkko's final patch that adds the devm=5F (just delete it fr=
om<br>&gt; tpm=5Falloc and use my version for tpmm=5Falloc)<br>&gt; <br>&gt=
; The other thing that has come to my mind is device removal. Right
now<br>&gt; the tpm core is still fairly broken in that regard, and we have=
<br>&gt; largely got away with ignoring that because drviers are rarely<br>=
&gt; removed.<br>&gt; <br>&gt; However, you are adding something that actua=
lly requires removal to<br>&gt; work and be race free, so we'll also have t=
o fix core removal :(</font></tt><br><br><tt><font size=3D2>Where is the ra=
ce? I tested the following:</font></tt><br><br><tt><font size=3D2>The tpm=
=5Fvtpm module use counter increases with every
server file descriptor being handed out, so every run of ./vtpmctrl increas=
es
it by 1.</font></tt><br><br><tt><font size=3D2>Every opening of /dev/tpm%d =
(exec 1XY&lt;&gt;/dev/tpm%d)
increases the tpm=5Fvtpm module use counter also by 1.</font></tt><br><br><=
tt><font size=3D2>If the vtpmctrl's die, the module use counter decreases
for every vtpmctrl termiating. However, the use counter is still at the
number of open /dev/tpm%d devices.</font></tt><br><br><tt><font size=3D2>vt=
pm=5Fdev and chip structures only get free'd once
the file descriptor is close. So it looks like expected good behavior to
me. We cannot remove the 'backend' module following the usage counter incre=
ase,
so this is good too.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; &n=
bsp;Stefan</font></tt><br><br><tt><font size=3D2><br>&gt; <br>&gt; The basi=
c approach I'd suggest would be the same as what the rtc<br>&gt; subsystem =
does.<br>&gt; <br>&gt; Add a mutex around 'chip-&gt;ops' and every place th=
at<br>&gt; uses ops has to hold the lock.<br>&gt; <br>&gt; Upon removal gra=
b the mutex and null ops.<br>&gt; <br>&gt; Every place that graps the lock =
for ops has to check for null. Null<br>&gt; means the device is being destr=
oyed and the call must fail.<br>&gt; <br>&gt; Make changes to tpm=5Fchip=5F=
find=5Fget to check for null, and make it do<br>&gt; put=5Fdevice. Reconsid=
er the use of module locking there, not sure it<br>&gt; makes any sense to =
do that if we have proper safe removal support.<br>&gt; <br>&gt; Jason<br>&=
gt; <br></font></tt><BR>
--=_alternative 0070C18085257F57_=--



--===============3292190909749569680==
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
--===============3292190909749569680==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3292190909749569680==--
