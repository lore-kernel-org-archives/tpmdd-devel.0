From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 05/11] tpm: Get rid of module locking
Date: Mon, 22 Feb 2016 19:26:30 -0500
Message-ID: <201602230026.u1N0Qusd016784@d01av01.pok.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-6-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222182245.GC22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6656250355724218684=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222182245.GC22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============6656250355724218684==
Content-Type: multipart/alternative;
	boundary="=_alternative 000275C585257F62_="


--=_alternative 000275C585257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
01:22:45 PM:


> Subject: Re: [tpmdd-devel] [PATCH v3 05/11] tpm: Get rid of module=20
locking
>=20
> On Fri, Feb 19, 2016 at 07:42:02AM -0500, Stefan Berger wrote:
> > Get rid of the locking of the module
>=20
> Little more in the comment please..
>=20
>   Now that the tpm core has strong locking around 'ops' it is possible
>   to remove a TPM driver, module and all, even while user space still
>   has things like /dev/tpmX open. For consistency and simplicity, drop
>   the module locking entirely.


Took the text :-) Thanks.

   Stefan


--=_alternative 000275C585257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 01:22:45 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v3 05/11] tpm:
Get rid of module locking</font></tt><br><tt><font size=3D2>&gt; <br>&gt; O=
n Fri, Feb 19, 2016 at 07:42:02AM -0500, Stefan Berger wrote:<br>&gt; &gt; =
Get rid of the locking of the module<br>&gt; <br>&gt; Little more in the co=
mment please..<br>&gt; <br>&gt; &nbsp; Now that the tpm core has strong loc=
king around 'ops' it is
possible<br>&gt; &nbsp; to remove a TPM driver, module and all, even while =
user space
still<br>&gt; &nbsp; has things like /dev/tpmX open. For consistency and si=
mplicity,
drop<br>&gt; &nbsp; the module locking entirely.</font></tt><br><br><br><tt=
><font size=3D2>Took the text :-) Thanks.</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><BR>
--=_alternative 000275C585257F62_=--



--===============6656250355724218684==
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
--===============6656250355724218684==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6656250355724218684==--
