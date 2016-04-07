From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: remove redundant code from self-test
	functions
Date: Thu, 7 Apr 2016 14:30:46 +0300
Message-ID: <20160407113046.GA12554@intel.com>
References: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160331054623.GB20504@obsidianresearch.com>
	<20160331063756.GA6393@intel.com>
	<20160402031615.GA28449@obsidianresearch.com>
	<20160405094221.GA12672@intel.com>
	<CALD+uuwQnvKL7TsiBXme=P8NKEX2gD1mOx-AxV7OHiBgmi4ykw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALD+uuwQnvKL7TsiBXme=P8NKEX2gD1mOx-AxV7OHiBgmi4ykw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jean-Luc BLANC <Jean-Luc.Blanc-qxv4g6HH51o@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 06, 2016 at 04:03:52PM +0200, Christophe Ricard wrote:
>    Hi Jarkko,
> =

>    I think there is a bug in the current version of this patch.
>    tpm1_pcr_read returns TPM status code (>=3D 0)
> =

>    In tpm_do_selftest, after tpm1_pcr_read, rc is compared with
>    TPM_HEADER_SIZE.
> =

>    In short:
>    "if (rc =3D=3D TPM_ERR_DISABLED || rc =3D=3D TPM_ERR_DEACTIVATED) {" i=
s never
>    reached because TPM_ERR_DISABLED(0x7) and TPM_ERR_DEACTIVATED(0x6) are=
 <
>    TPM_HEADER size.
>    TPM_HEADER_SIZE beeing already checked in tpm_transmit_cmd, i think a
>    reasonable fix will be to remove:
>    if (rc < TPM_HEADER_SIZE)
>    =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;
> =

>    in tpm_do_self_test.
> =

>    Can you merge this fix into the current patch or do you want me to sen=
d it
>    to you ?

This is my bad and thanks for catching this. I tested the patch but for
some reason the patch that I sent to LKML does not have this check
removed. The check can be safely removed because the same check is done
internally by tpm_transmit().

For now I removed the patch from my master branch since there is a crash
that I'm debugging and this is low priority change. I'll include this
change among couple of other patches to a patches to a patch set that
unifies all parts to call tpm_transmit_cmd() later on.

Thanks again for spotting this!

/Jarkko

>    Best Regards
>    Christophe
>    2016-04-05 11:42 GMT+02:00 Jarkko Sakkinen
>    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> =

>      On Fri, Apr 01, 2016 at 09:16:15PM -0600, Jason Gunthorpe wrote:
>      > On Thu, Mar 31, 2016 at 09:37:56AM +0300, Jarkko Sakkinen wrote:
>      > > On Wed, Mar 30, 2016 at 11:46:23PM -0600, Jason Gunthorpe wrote:
>      > > > On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wrot=
e:
>      > > >
>      > > > > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =
=3D
>      be32_to_cpu(cmd.header.out.return_code);
>      > > > >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0if (rc =3D=3D TPM_ERR_DISABLED || rc =3D=3D
>      TPM_ERR_DEACTIVATED) {
>      > > >
>      > > > This line is the entire reason it is open coded, I see it being
>      > > > removed, but I don't see how the functionality is maintained?
>      > >
>      > > When tpm_trance_cmd() returns a positive number it is the TPM er=
ror
>      code
>      > > that it returns. tpm_pcr_read() does pass through whatever
>      > > tpm_trace_cmd() returns so the above condition should still work=
 as
>      > > expected.
>      >
>      > Okay, everything looks fine to me
> =

>      I applied this to http://git.infradead.org/users/jjs/linux-tpmdd.git=
 in
>      order to get exposure (tested-by's are always welcome).
> =

>      > Jason
>      /Jarkko

---------------------------------------------------------------------------=
---
