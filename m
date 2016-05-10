From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG,
 bisect] tpm: Remove all uses of drvdata from the TPM Core
Date: Tue, 10 May 2016 11:05:43 -0400
Message-ID: <201605101506.u4AF5rPa009949@d01av03.pok.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com><1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160510135523.GA1943@hudson.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4895185364687071001=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160510135523.GA1943-ZO/ZziT/ZXRSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============4895185364687071001==
Content-Type: multipart/alternative;
	boundary="=_alternative 0052EFA185257FAF_="


--=_alternative 0052EFA185257FAF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 05/10/2016 09:55:23 AM:

>=20
> all,
>=20
> My machine is locking up during suspend and I have bisected the
> problem to this patch (e89f8b1ade9cc1a) in the latest linux-next
> (20160506) kernel.
>=20
> Let me know if I can test patches or do anything else to help.

The chip retrieval method in the pm functions is wrong. Sending patch.

   Stefan



--=_alternative 0052EFA185257FAF_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jeremiah Mahler &lt;jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt; wrote on 05/1=
0/2016
09:55:23 AM:<br><br>&gt; <br>&gt; all,<br>&gt; <br>&gt; My machine is locki=
ng up during suspend and I have bisected the<br>&gt; problem to this patch =
(e89f8b1ade9cc1a) in the latest linux-next<br>&gt; (20160506) kernel.<br>&g=
t; <br>&gt; Let me know if I can test patches or do anything else to help.<=
/font></tt><br><br><tt><font size=3D2>The chip retrieval method in the pm f=
unctions is wrong.
Sending patch.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</f=
ont></tt><br><BR>
--=_alternative 0052EFA185257FAF_=--



--===============4895185364687071001==
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
--===============4895185364687071001==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4895185364687071001==--
