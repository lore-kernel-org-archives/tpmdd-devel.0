From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 07:20:48 -0500
Message-ID: <201601271220.u0RCKr28004884@d01av03.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31hLD018933@d03av02.boulder.ibm.com>
	<20160127025057.GB23863@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4378939733097496510=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127025057.GB23863-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============4378939733097496510==
Content-Type: multipart/alternative;
	boundary="=_alternative 0043D36585257F47_="


--=_alternative 0043D36585257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 01/26/2016=20
09:50:57 PM:


>=20
> On Wed, Jan 20, 2016 at 10:01:38PM -0500, Stefan Berger wrote:
> > > Except that isn't good enough - the IMA kernel side doesn't knowthat =

this
> > > tpm is now acting as the 'main' 'default' TPM.
> >=20
> > Hooking the vTPM to IMA requires another patch that I haven't=20
> shown since IMA
> > namespacing isn't public yet. Basically we implement another ioctl
> () that is to
> > be called before the clone() in order to 'reserve' a vtpm device=20
> pair for the
> > calling process. During the clone() call IMA namespacing code can=20
query the
> > vTPM driver for a 'reserved' device pair. Hooking IMA up after the
> clone() may
> > also work but in case of docker/golang it's better to do this=20
> before since the
> > language libraries do a lot after the clone automatically.
>=20
> Can we expect that "in the end" there will be a single patch set that
> contains both TPM and IMA changes? Otherwise, I see it very hard to make
> decision to apply TPM patches.

If this can be posted to the same lists, then 'yes'. I cannot set a=20
timeframe for this, though. Nevertheless, the vTPM driver reviews were=20
fruitful, I think.

The vTPM driver could be used standalone as well, though it may be more=20
useful in conjunction with the namespacing of IMA.

Stefan

>=20
> /Jarkko
>=20



--=_alternative 0043D36585257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 01/26/2016 09:50:57 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Wed, Jan 20, 2016 at 10:01:38PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &gt; Except that isn't good enough - the IMA kernel side doe=
sn't
knowthat this<br>&gt; &gt; &gt; tpm is now acting as the 'main' 'default' T=
PM.<br>&gt; &gt; <br>&gt; &gt; Hooking the vTPM to IMA requires another pat=
ch that I haven't
<br>&gt; shown since IMA<br>&gt; &gt; namespacing isn't public yet. Basical=
ly we implement another
ioctl<br>&gt; () that is to<br>&gt; &gt; be called before the clone() in or=
der to 'reserve' a vtpm device
<br>&gt; pair for the<br>&gt; &gt; calling process. During the clone() call=
 IMA namespacing code
can query the<br>&gt; &gt; vTPM driver for a 'reserved' device pair. Hookin=
g IMA up after
the<br>&gt; clone() may<br>&gt; &gt; also work but in case of docker/golang=
 it's better to do this
<br>&gt; before since the<br>&gt; &gt; language libraries do a lot after th=
e clone automatically.<br>&gt; <br>&gt; Can we expect that &quot;in the end=
&quot; there will be a single patch
set that<br>&gt; contains both TPM and IMA changes? Otherwise, I see it ver=
y hard to
make<br>&gt; decision to apply TPM patches.</font></tt><br><br><tt><font si=
ze=3D2>If this can be posted to the same lists, then 'yes'.
I cannot set a timeframe for this, though. Nevertheless, the vTPM driver
reviews were fruitful, I think.</font></tt><br><br><tt><font size=3D2>The v=
TPM driver could be used standalone as well,
though it may be more useful in conjunction with the namespacing of IMA.</f=
ont></tt><br><br><tt><font size=3D2>Stefan</font></tt><br><tt><font size=3D=
2><br>&gt; <br>&gt; /Jarkko<br>&gt; <br></font></tt><BR>
--=_alternative 0043D36585257F47_=--



--===============4378939733097496510==
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
--===============4378939733097496510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4378939733097496510==--
