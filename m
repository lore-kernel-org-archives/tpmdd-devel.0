From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Tue, 19 Jan 2016 12:53:40 -0500
Message-ID: <201601191753.u0JHrkES016734@d01av02.pok.ibm.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<20160119174400.GA7616@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2153677186748385927=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160119174400.GA7616-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2153677186748385927==
Content-Type: multipart/alternative;
	boundary="=_alternative 00624D1985257F3F_="


--=_alternative 00624D1985257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016=20
12:44:00 PM:

>=20
> On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Berger wrote:
>=20
> > The primary goal of this series of patches is enabling vTPM for=20
containers
> > and hooking them up to a (future) namespaced IMA. However, the driver=20
can
> > also be used for simulating a hardware TPM on the host.
>=20
> If we go down the road of doing the kernel-side tpm resource
> management this series seems like a kludgy way to enable tpm
> namespaces? A future resource manager could be name space aware and
> keep everything sane.

This series has absolutely nothing to do with resource management.=20
Resource management in the kernel would be completely orthogonal to this=20
series here. Presumably one would do independent resource management per=20
client TPM device, so hook your resource management to the per client=20
tpm=5Fchip structure. That way you can have an unlimited number of clients =

with independent resource management related to the TPM/vTPM they are=20
using.

   Stefan



--=_alternative 00624D1985257F3F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 01/19/2016 12:44:00 PM:<br><br>&gt; <br>&gt; On Thu, Jan 14, 2016 =
at 11:01:54AM -0500, Stefan Berger wrote:<br>&gt; <br>&gt; &gt; The primary=
 goal of this series of patches is enabling vTPM for
containers<br>&gt; &gt; and hooking them up to a (future) namespaced IMA. H=
owever, the
driver can<br>&gt; &gt; also be used for simulating a hardware TPM on the h=
ost.<br>&gt; <br>&gt; If we go down the road of doing the kernel-side tpm r=
esource<br>&gt; management this series seems like a kludgy way to enable tp=
m<br>&gt; namespaces? A future resource manager could be name space aware a=
nd<br>&gt; keep everything sane.</font></tt><br><br><tt><font size=3D2>This=
 series has absolutely nothing to do with resource
management. Resource management in the kernel would be completely orthogonal
to this series here. Presumably one would do independent resource management
per client TPM device, so hook your resource management to the per client
tpm=5Fchip structure. That way you can have an unlimited number of clients
with independent resource management related to the TPM/vTPM they are using=
.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br>=
<BR>
--=_alternative 00624D1985257F3F_=--



--===============2153677186748385927==
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
--===============2153677186748385927==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2153677186748385927==--
