From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Mon, 7 Mar 2016 16:12:45 -0500
Message-ID: <201603072115.u27LFgHU009205@d01av03.pok.ibm.com>
References: <20160306120537.GA22702@intel.com>
	<20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
	<201603070040.u270eq7U019952@d01av03.pok.ibm.com>
	<20160307203206.GA4303@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8051906127599961750=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160307203206.GA4303-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============8051906127599961750==
Content-Type: multipart/alternative;
	boundary="=_alternative 0074866E85257F6F_="


--=_alternative 0074866E85257F6F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 03/07/2016=20
03:32:06 PM:


>=20
> On Sun, Mar 06, 2016 at 07:40:40PM -0500, Stefan Berger wrote:
>=20
> >    If you have suggestions or comments, let me know.
> >    I adjusted the code to reflect the ENOSYS (previously EINVAL) in=20
case
> >    of unsupported flags or unsupported ioctls.
>=20
> Please don't use ENOSYS, the desire is that is only used by
> systemcalls.

Ok, found alternatives: ENOTSUPP for the flag and ENOIOCTLCMD for the=20
unsupported ioctl ?

   Stefan



--=_alternative 0074866E85257F6F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 03/07/2016 03:32:06 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Sun, Mar 06, 2016 at 07:40:40PM -0500, Stefan Berger wrote=
:<br>&gt; <br>&gt; &gt; &nbsp; &nbsp;If you have suggestions or comments, l=
et me know.<br>&gt; &gt; &nbsp; &nbsp;I adjusted the code to reflect the EN=
OSYS (previously
EINVAL) in case<br>&gt; &gt; &nbsp; &nbsp;of unsupported flags or unsupport=
ed ioctls.<br>&gt; <br>&gt; Please don't use ENOSYS, the desire is that is =
only used by<br>&gt; systemcalls.</font></tt><br><br><tt><font size=3D2>Ok,=
 found alternatives: ENOTSUPP for the flag and
ENOIOCTLCMD for the unsupported ioctl ?</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 0074866E85257F6F_=--



--===============8051906127599961750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
--===============8051906127599961750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8051906127599961750==--
