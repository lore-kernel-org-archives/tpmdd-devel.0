From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: fix invalid constant expressions in
	tpm.h
Date: Mon, 29 Aug 2016 21:45:36 -0600
Message-ID: <20160830034536.GA29261@obsidianresearch.com>
References: <1472520498-24173-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472520498-24173-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 04:28:17AM +0300, Jarkko Sakkinen wrote:
> The enums tpm_capabilities and tpm_sub_capabilities do not contain legit
> constant expressions. This commit makes cap_id a separate parameter
> in

I wonder if this is a bug in sparse? the macro uses gcc magic to
expand to a constexpr.

You could also use __constant_cpu_to_be32 and similar instead.

But I admit I never liked the use of no-host endian in the constants..

>  #define TPM_ORD_STARTUP cpu_to_be32(153)
>  #define TPM_ST_CLEAR cpu_to_be16(1)

Would be nice to see these fixed into an enum someday too

> +enum tpm1_capabilities {
> +	TPM1_CAP_FLAG		= 0x04,
> +	TPM1_CAP_PROP		= 0x05,
> +	TPM1_CAP_VERSION_1_1	= 0x06,
> +	TPM1_CAP_VERSION_1_2	= 0x1A,

I usually discourage the extra horizontal whitespace, just causes patch churn to
keep it up (and clang-format won't do it automatically). Not sure if
there is a consensus on that though.

But looks fine to me.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason

------------------------------------------------------------------------------
