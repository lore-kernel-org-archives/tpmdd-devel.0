From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 3/5] tpm: Clean up reading of timeout
	and duration capabilities
Date: Tue, 21 Jun 2016 17:21:27 -0700
Message-ID: <CAO_EM_kFH+qO9P0b6dPOvYEGyPTq=3iGR8jVoDChtr6bB51Hzg@mail.gmail.com>
References: <1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
	<1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
	<1466474042-110773-4-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466474042-110773-4-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 20, 2016 at 6:54 PM, Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org> wrote:
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -461,9 +461,19 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
>                 tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>                 tpm_cmd.params.getcap_in.subcap = subcap_id;
>         }
> +
>         rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
> +
> +       if (!rc &&
> +           ((subcap_id == TPM_CAP_PROP_TIS_TIMEOUT &&
> +             be32_to_cpu(tpm_cmd.header.out.length) != TPM_HEADER_SIZE + 5) ||
> +            (subcap_id == TPM_CAP_PROP_TIS_DURATION &&
> +             be32_to_cpu(tpm_cmd.header.out.length) != TPM_HEADER_SIZE + 4)))
> +               rc = -EINVAL;
> +

Woops, a totally innocuous last-minute (post-testing) cleanup broke
this code; should be TPM_HEADER_SIZE + 20 and + 16. I'll push out v8
as soon as I redo my tests.

--Ed

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
