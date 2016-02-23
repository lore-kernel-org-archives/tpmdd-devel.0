From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/11] tpm: Split out the devm stuff
 from tpmm_chip_alloc
Date: Mon, 22 Feb 2016 19:45:33 -0500
Message-ID: <201602230045.u1N0jxjZ023935@d03av03.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-7-git-send-email-stefanb@linux.vnet.ibm.com><20160222211414.GC3310@intel.com>
	<20160222221328.GA27228@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6566940291562797476=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222221328.GA27228-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6566940291562797476==
Content-Type: multipart/alternative;
	boundary="=_alternative 0004343485257F62_="


--=_alternative 0004343485257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
05:13:28 PM:


>=20
> On Mon, Feb 22, 2016 at 11:14:14PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Feb 19, 2016 at 07:42:03AM -0500, Stefan Berger wrote:
> > > From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >=20
> > > tpm=5Fchip=5Falloc becomes a typical subsystem allocate call.
> >=20
> > Maybe a more verbose commit message?
>=20
> What more do you want to say?
>=20
> > >     spin=5Flock(&driver=5Flock);
> > >     chip->dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(dev=5Fmask, TPM=5FN=
UM=5FDEVICES);
> > > +   if (chip->dev=5Fnum < TPM=5FNUM=5FDEVICES)
> > > +      set=5Fbit(chip->dev=5Fnum, dev=5Fmask);
> >=20
> > I guess this change should a separate patch.
>=20
> Hurm, Stefan? This was not in the patch I sent you? This hunk looks
> incomplete to me, and replaced by the IDR stuff anyhow. Drop it?

Dropped.

   Stefan



--=_alternative 0004343485257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 05:13:28 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Feb 22, 2016 at 11:14:14PM +0200, Jarkko Sakkinen wro=
te:<br>&gt; &gt; On Fri, Feb 19, 2016 at 07:42:03AM -0500, Stefan Berger wr=
ote:<br>&gt; &gt; &gt; From: Jason Gunthorpe &lt;jgunthorpe@obsidianresearc=
h.com&gt;<br>&gt; &gt; &gt; <br>&gt; &gt; &gt; tpm=5Fchip=5Falloc becomes a=
 typical subsystem allocate call.<br>&gt; &gt; <br>&gt; &gt; Maybe a more v=
erbose commit message?<br>&gt; <br>&gt; What more do you want to say?<br>&g=
t; <br>&gt; &gt; &gt; &nbsp; &nbsp; spin=5Flock(&amp;driver=5Flock);<br>&gt=
; &gt; &gt; &nbsp; &nbsp; chip-&gt;dev=5Fnum =3D find=5Ffirst=5Fzero=5Fbit(=
dev=5Fmask,
TPM=5FNUM=5FDEVICES);<br>&gt; &gt; &gt; + &nbsp; if (chip-&gt;dev=5Fnum &lt=
; TPM=5FNUM=5FDEVICES)<br>&gt; &gt; &gt; + &nbsp; &nbsp; &nbsp;set=5Fbit(ch=
ip-&gt;dev=5Fnum, dev=5Fmask);<br>&gt; &gt; <br>&gt; &gt; I guess this chan=
ge should a separate patch.<br>&gt; <br>&gt; Hurm, Stefan? This was not in =
the patch I sent you? This hunk looks<br>&gt; incomplete to me, and replace=
d by the IDR stuff anyhow. Drop it?</font></tt><br><br><tt><font size=3D2>D=
ropped.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></t=
t><br><BR>
--=_alternative 0004343485257F62_=--



--===============6566940291562797476==
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
--===============6566940291562797476==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6566940291562797476==--
