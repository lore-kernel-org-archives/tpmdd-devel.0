From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: remove redundant code from self-test
	functions
Date: Wed, 6 Apr 2016 16:03:52 +0200
Message-ID: <CALD+uuwQnvKL7TsiBXme=P8NKEX2gD1mOx-AxV7OHiBgmi4ykw@mail.gmail.com>
References: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160331054623.GB20504@obsidianresearch.com>
	<20160331063756.GA6393@intel.com>
	<20160402031615.GA28449@obsidianresearch.com>
	<20160405094221.GA12672@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8476059079846867891=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160405094221.GA12672-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Luc BLANC <Jean-Luc.Blanc-qxv4g6HH51o@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============8476059079846867891==
Content-Type: multipart/alternative; boundary=001a114a59d6b88351052fd16f32

--001a114a59d6b88351052fd16f32
Content-Type: text/plain; charset=UTF-8

Hi Jarkko,

I think there is a bug in the current version of this patch.
tpm1_pcr_read returns TPM status code (>= 0)

In tpm_do_selftest, after tpm1_pcr_read, rc is compared with
TPM_HEADER_SIZE.

In short:
"if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {" is never
reached because TPM_ERR_DISABLED(0x7) and TPM_ERR_DEACTIVATED(0x6) are <
TPM_HEADER size.
TPM_HEADER_SIZE beeing already checked in tpm_transmit_cmd, i think a
reasonable fix will be to remove:
if (rc < TPM_HEADER_SIZE)
       return -EFAULT;

in tpm_do_self_test.

Can you merge this fix into the current patch or do you want me to send it
to you ?

Best Regards
Christophe


2016-04-05 11:42 GMT+02:00 Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
:

> On Fri, Apr 01, 2016 at 09:16:15PM -0600, Jason Gunthorpe wrote:
> > On Thu, Mar 31, 2016 at 09:37:56AM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Mar 30, 2016 at 11:46:23PM -0600, Jason Gunthorpe wrote:
> > > > On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wrote:
> > > >
> > > > > -               rc = be32_to_cpu(cmd.header.out.return_code);
> > > > >                 if (rc == TPM_ERR_DISABLED || rc ==
> TPM_ERR_DEACTIVATED) {
> > > >
> > > > This line is the entire reason it is open coded, I see it being
> > > > removed, but I don't see how the functionality is maintained?
> > >
> > > When tpm_trance_cmd() returns a positive number it is the TPM error
> code
> > > that it returns. tpm_pcr_read() does pass through whatever
> > > tpm_trace_cmd() returns so the above condition should still work as
> > > expected.
> >
> > Okay, everything looks fine to me
>
> I applied this to http://git.infradead.org/users/jjs/linux-tpmdd.git in
> order to get exposure (tested-by's are always welcome).
>
> > Jason
>
> /Jarkko
>

--001a114a59d6b88351052fd16f32
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div><div>Hi Jarkko,<br=
><br></div>I think there is a bug in the current version of this patch.<br>=
</div>tpm1_pcr_read returns TPM status code (&gt;=3D 0)<br><br></div>In tpm=
_do_selftest, after tpm1_pcr_read, rc is compared with TPM_HEADER_SIZE.<br>=
<br></div>In short:<br>&quot;if
 (rc =3D=3D TPM_ERR_DISABLED || rc =3D=3D TPM_ERR_DEACTIVATED) {&quot; is n=
ever=20
reached because TPM_ERR_DISABLED(0x7) and TPM_ERR_DEACTIVATED(0x6) are=20
&lt; TPM_HEADER size.<br></div>TPM_HEADER_SIZE beeing already checked in tp=
m_transmit_cmd, i think a reasonable fix will be to remove:<br>if (rc &lt; =
TPM_HEADER_SIZE)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;<br=
><br></div>in tpm_do_self_test.<br><br></div>Can you merge this fix into th=
e current patch or do you want me to send it to you ?<br><br></div>Best Reg=
ards<br></div>Christophe<div><div><div><div><br></div></div></div></div></d=
iv><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-04-05 11:=
42 GMT+02:00 Jarkko Sakkinen <span dir=3D"ltr">&lt;<a href=3D"mailto:jarkko=
.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" target=3D"_blank">jarkko.sakkinen-VuQAYsv1562vlLw7lfJaRg@public.gmane.org=
m</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Fri=
, Apr 01, 2016 at 09:16:15PM -0600, Jason Gunthorpe wrote:<br>
&gt; On Thu, Mar 31, 2016 at 09:37:56AM +0300, Jarkko Sakkinen wrote:<br>
&gt; &gt; On Wed, Mar 30, 2016 at 11:46:23PM -0600, Jason Gunthorpe wrote:<=
br>
&gt; &gt; &gt; On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wr=
ote:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0rc =3D be32_to_cpu(cmd.header.out.return_code);<br>
&gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0if (rc =3D=3D TPM_ERR_DISABLED || rc =3D=3D TPM_ERR_DEACTIVATED) {<br=
>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; This line is the entire reason it is open coded, I see it be=
ing<br>
&gt; &gt; &gt; removed, but I don&#39;t see how the functionality is mainta=
ined?<br>
&gt; &gt;<br>
&gt; &gt; When tpm_trance_cmd() returns a positive number it is the TPM err=
or code<br>
&gt; &gt; that it returns. tpm_pcr_read() does pass through whatever<br>
&gt; &gt; tpm_trace_cmd() returns so the above condition should still work =
as<br>
&gt; &gt; expected.<br>
&gt;<br>
&gt; Okay, everything looks fine to me<br>
<br>
</span>I applied this to <a href=3D"http://git.infradead.org/users/jjs/linu=
x-tpmdd.git" rel=3D"noreferrer" target=3D"_blank">http://git.infradead.org/=
users/jjs/linux-tpmdd.git</a> in<br>
order to get exposure (tested-by&#39;s are always welcome).<br>
<br>
&gt; Jason<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
/Jarkko<br>
</font></span></blockquote></div><br></div>

--001a114a59d6b88351052fd16f32--


--===============8476059079846867891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------

--===============8476059079846867891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============8476059079846867891==--
