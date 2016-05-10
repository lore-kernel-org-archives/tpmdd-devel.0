From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm: Fix suspend regression
Date: Tue, 10 May 2016 13:38:57 -0400
Message-ID: <201605101739.u4AHd2Fk013484@d01av04.pok.ibm.com>
References: <1462892834-5631-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160510165251.GB29825@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3373651637234084106=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160510165251.GB29825-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3373651637234084106==
Content-Type: multipart/alternative;
	boundary="=_alternative 0060F6F885257FAF_="


--=_alternative 0060F6F885257FAF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 05/10/2016=20
12:52:51 PM:

>=20
> On Tue, May 10, 2016 at 11:07:14AM -0400, Stefan Berger wrote:
> > Fix the suspend regression due to wrong way of retrieving
> > the chip from the parent device.
>=20
> Yep, that is it, commentary needs a tweak though:
>=20
> Fix the susped regression due to the wrong way of retrieving the
> chip. The suspend functions are attached to the hardware device,
> not the chip and thus must rely on drvdata.
>=20
> > Reported-by: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>=20
> Fixes: e89f8b1ade9cc1a ("tpm: Remove all uses of drvdata from the TPM=20
Core")
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks. I'll post v2 tomorrow in case I can collect some more Tested-by's.

   Stefan



--=_alternative 0060F6F885257FAF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 05/10/2016 12:52:51 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Tue, May 10, 2016 at 11:07:14AM -0400, Stefan Berger wrote:<br=
>&gt; &gt; Fix the suspend regression due to wrong way of retrieving<br>&gt=
; &gt; the chip from the parent device.<br>&gt; <br>&gt; Yep, that is it, c=
ommentary needs a tweak though:<br>&gt; <br>&gt; Fix the susped regression =
due to the wrong way of retrieving the<br>&gt; chip. The suspend functions =
are attached to the hardware device,<br>&gt; not the chip and thus must rel=
y on drvdata.<br>&gt; <br>&gt; &gt; Reported-by: Jeremiah Mahler &lt;jmmahl=
er-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt;<br>&gt; &gt; Signed-off-by: Stefan Berger &lt;stefanb@linu=
x.vnet.ibm.com&gt;<br>&gt; &gt; Tested-by: Stefan Berger &lt;stefanb@linux.=
vnet.ibm.com&gt;<br>&gt; <br>&gt; Fixes: e89f8b1ade9cc1a (&quot;tpm: Remove=
 all uses of drvdata from
the TPM Core&quot;)<br>&gt; Reviewed-by: Jason Gunthorpe &lt;jgunthorpe@obs=
idianresearch.com&gt;</font></tt><br><br><tt><font size=3D2>Thanks. I'll po=
st v2 tomorrow in case I can collect
some more Tested-by's.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;S=
tefan</font></tt><br><BR>
--=_alternative 0060F6F885257FAF_=--



--===============3373651637234084106==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Mobile security can be enabling, not merely restricting. Employees who
bring their own devices (BYOD) to work are irked by the imposition of MDM
restrictions. Mobile Device Manager Plus allows you to control only the
apps on BYO-devices by containerizing them, leaving personal data untouched!
https://ad.doubleclick.net/ddm/clk/304595813;131938128;j
--===============3373651637234084106==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3373651637234084106==--
