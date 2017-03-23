From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH linux-next] tmp2: fix an off by one bug
Date: Thu, 23 Mar 2017 20:15:39 +0200
Message-ID: <20170323181539.y57qjubnciglapep@intel.com>
References: <20170208110713.14070-4-jarkko.sakkinen@linux.intel.com>
	<20170323154029.27816-1-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323154029.27816-1-vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 23, 2017 at 04:40:29PM +0100, Vincent Stehl=E9 wrote:
> In tpm2_map_to_phandle(), avoid the case where i equals
> ARRAY_SIZE(space->context_tbl) and we then access space->context_tbl[i].
> =

> This fixes the following smatch error:
> =

>   drivers/char/tpm/tpm2-space.c:232 tpm2_map_to_phandle() error: buffer o=
verflow 'space->context_tbl' 3 <=3D 3
> =

> Fixes: 5f6b4fbc12c8fc97 ("tpm: infrastructure for TPM spaces")
> Signed-off-by: Vincent Stehl=E9 <vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hi

Thanks for doing this. I just squashed a fix by Colin Ian King. Anyway,
thank you.

/Jarkko

> ---
> =

> =

> Hi,
> =

> I saw that in Linux next-20170323.
> =

> Best regards,
> =

> Vincent.
> =

> =

>  drivers/char/tpm/tpm2-space.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> =

> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index d36d81e07076..009934269514 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -229,7 +229,7 @@ static bool tpm2_map_to_phandle(struct tpm_space *spa=
ce, void *handle)
>  	int i;
>  =

>  	i =3D 0xFFFFFF - (vhandle & 0xFFFFFF);
> -	if (i > ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
> +	if (i >=3D ARRAY_SIZE(space->context_tbl) || !space->context_tbl[i])
>  		return false;
>  =

>  	phandle =3D space->context_tbl[i];
> -- =

> 2.11.0
> =


---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
