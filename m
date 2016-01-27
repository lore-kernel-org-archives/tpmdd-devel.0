From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 17:38:02 -0500
Message-ID: <201601272238.u0RMc7Jf010582@d01av02.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdGB9031710@d01av04.pok.ibm.com>
	<20160127023603.GA23863@intel.com>
	<201601271217.u0RCHQIX004914@d03av02.boulder.ibm.com>
	<20160127142239.GA3756@intel.com>
	<20160127182448.GA31680@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1022597025697332864=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160127182448.GA31680-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============1022597025697332864==
Content-Type: multipart/alternative;
	boundary="=_alternative 007C55E885257F47_="


--=_alternative 007C55E885257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/27/2016=20
01:24:48 PM:


> Subject: Re: [tpmdd-devel] [RFC PATCH 3/4] Implement driver for=20
> supporting multiple emulated TPMs
>=20
> On Wed, Jan 27, 2016 at 06:22:39AM -0800, Jarkko Sakkinen wrote:
>=20
> > Also, I'm wondering is it right to have this as a separate module or
> > should this be part of the core TPM infrastructure?
>=20
> The vtpm itself should be a module.
>=20
> Any namespace support for TPM (whatever form that takes) should be in
> the core infrastructure and apply equally to all TPMs.
>=20
> I do not like the idea that only vtpm could participate in namespace
> support.

How would the usage model of the TPM shared by multiple namespaces look=20
like? What subset of functionality is available to each namespace and what =

works and what doesn't? Again, how is the sharing of PCRs accomplished?=20

I think we should treat this sharing of the hardware TPM discussion=20
orthogonal to the vTPM so that we don't get hung up with it.

   Stefan

>=20
> Jason
>=20



--=_alternative 007C55E885257F47_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/27/2016 01:24:48 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [RFC PATCH 3/4] Implement
driver for <br>&gt; supporting multiple emulated TPMs</font></tt><br><tt><f=
ont size=3D2>&gt; <br>&gt; On Wed, Jan 27, 2016 at 06:22:39AM -0800, Jarkko=
 Sakkinen wrote:<br>&gt; <br>&gt; &gt; Also, I'm wondering is it right to h=
ave this as a separate module
or<br>&gt; &gt; should this be part of the core TPM infrastructure?<br>&gt;=
 <br>&gt; The vtpm itself should be a module.<br>&gt; <br>&gt; Any namespac=
e support for TPM (whatever form that takes) should be
in<br>&gt; the core infrastructure and apply equally to all TPMs.<br>&gt; <=
br>&gt; I do not like the idea that only vtpm could participate in namespac=
e<br>&gt; support.</font></tt><br><br><tt><font size=3D2>How would the usag=
e model of the TPM shared by multiple
namespaces look like? What subset of functionality is available to each
namespace and what works and what doesn't? Again, how is the sharing of
PCRs accomplished? </font></tt><br><br><tt><font size=3D2>I think we should=
 treat this sharing of the hardware
TPM discussion orthogonal to the vTPM so that we don't get hung up with
it.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><b=
r><tt><font size=3D2><br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 007C55E885257F47_=--



--===============1022597025697332864==
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
--===============1022597025697332864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1022597025697332864==--
