From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix type issues in tpm_getcap()
Date: Wed, 1 Feb 2017 20:40:06 +0200
Message-ID: <20170201184006.p6iqgshipdcfuovo@intel.com>
References: <20170201175347.2035-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170201175347.2035-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 01, 2017 at 07:53:47PM +0200, Jarkko Sakkinen wrote:
> There are two type issues associated with tpm_getcap().
> 
> You must not do arithmetic with __be32 or __le32 types because sometimes
> it results incorrect results. Calculations must be done only with data
> that is in CPU byte order. This commit migrates tpm_getcap() to struct
> tpm_buf in order to sort out these issues.
> 
> The second issue is with struct cap_t as the size of the type bool is
> assumed to be one byte. This commit sorts out the issue by changing the
> type to u8.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> v2:
> - Use struct tpm_buf.
> - Merge the type change of 'owned' to this patch.
>  drivers/char/tpm/tpm-interface.c | 33 ++++++++++++++++++---------------
>  drivers/char/tpm/tpm.h           | 15 +--------------
>  2 files changed, 19 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 423938e..7af1e8c 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -480,31 +480,34 @@ static const struct tpm_input_header tpm_getcap_header = {
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		   const char *desc, size_t min_cap_length)

Last two parameters are in the wrong order (different than
tpm_transmit_cmd).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
