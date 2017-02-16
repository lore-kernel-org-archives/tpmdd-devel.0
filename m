From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 21:59:17 +0200
Message-ID: <20170216195917.pid75fojnrbhcqc6@intel.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 11:15:41AM +0000, Davide Guerri wrote:
>    Hello guys,
>    I am trying to get the fTPM on an Intel NUC working bit I get this err=
or
> =

>    [=C2=A0 =C2=A0 3.191376] tpm_crb MSFT0101:00: can't request region for=
 resource
>    [mem 0xfed40080-0xfed40fff]
> =

>    [=C2=A0 =C2=A0 3.200378] tpm_crb: probe of MSFT0101:00 failed with err=
or -16
> =

>    and, of course, the TPM device is not registered in dev/sysfs
>    In my understanding this is a regression as it has been already fixed =
in
>    the past and merged in 4.7 or 4.8.
>    I also verified my source and tpm_crb.c contains this
>    patch:=C2=A0https://git.kernel.org/cgit/linux/kernel/git/torvalds/linu=
x.git/commit/?id=3D422eac3f7deae34dbaffd08e03e27f37a5394a56
>    Is that a known issue? If so, are there workaround/patches?
>    Thanks in advance,
>    =C2=A0Davide.

Could you please use plain text email, '>' quoting and reply inline?
Your emails are almost impossible to read with plain text email client
like the one that I use (links dump looks terrible).

/Jarkko

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
