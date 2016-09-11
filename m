From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 10/26] tpm: constify local structures
Date: Sun, 11 Sep 2016 20:09:37 +0300
Message-ID: <20160911170937.GA5493@intel.com>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
	<1473599168-30561-11-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473599168-30561-11-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Sep 11, 2016 at 03:05:52PM +0200, Julia Lawall wrote:
> For structure types defined in the same file or local header files, find
> top-level static structure declarations that have the following
> properties:
> 1. Never reassigned.
> 2. Address never taken
> 3. Not passed to a top-level macro call
> 4. No pointer or array-typed field passed to a function or stored in a
> variable.
> Declare structures having all of these properties as const.
> 
> Done using Coccinelle.
> Based on a suggestion by Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

To be frank I don't understand (at all) what you are trying to say in
the commit message but change is still for better :)

Can I rephrase the commit message: "Move TPM header structures to the
.rodata section"? It should be obvious why that is for better for
anyone.

Anyway, thanks for the effort.

Acked-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
> The semantic patch seems too long for a commit log, but is in the cover
> letter.
> 
>  drivers/char/tpm/tpm-interface.c |   10 +++++-----
>  drivers/char/tpm/tpm-sysfs.c     |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 1abe2d7..e84888f 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -633,7 +633,7 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
>  #define TPM_ORD_CONTINUE_SELFTEST 83
>  #define CONTINUE_SELFTEST_RESULT_SIZE 10
>  
> -static struct tpm_input_header continue_selftest_header = {
> +static const struct tpm_input_header continue_selftest_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(10),
>  	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
> @@ -659,7 +659,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  
>  #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
>  #define READ_PCR_RESULT_SIZE 30
> -static struct tpm_input_header pcrread_header = {
> +static const struct tpm_input_header pcrread_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(14),
>  	.ordinal = TPM_ORDINAL_PCRREAD
> @@ -745,7 +745,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>   */
>  #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>  #define EXTEND_PCR_RESULT_SIZE 34
> -static struct tpm_input_header pcrextend_header = {
> +static const struct tpm_input_header pcrextend_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(34),
>  	.ordinal = TPM_ORD_PCR_EXTEND
> @@ -949,7 +949,7 @@ EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>  #define TPM_ORD_SAVESTATE cpu_to_be32(152)
>  #define SAVESTATE_RESULT_SIZE 10
>  
> -static struct tpm_input_header savestate_header = {
> +static const struct tpm_input_header savestate_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(10),
>  	.ordinal = TPM_ORD_SAVESTATE
> @@ -1032,7 +1032,7 @@ int tpm_pm_resume(struct device *dev)
>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  
>  #define TPM_GETRANDOM_RESULT_SIZE	18
> -static struct tpm_input_header tpm_getrandom_header = {
> +static const struct tpm_input_header tpm_getrandom_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(14),
>  	.ordinal = TPM_ORD_GET_RANDOM
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index b46cf70..26fccad 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -22,7 +22,7 @@
>  
>  #define READ_PUBEK_RESULT_SIZE 314
>  #define TPM_ORD_READPUBEK cpu_to_be32(124)
> -static struct tpm_input_header tpm_readpubek_header = {
> +static const struct tpm_input_header tpm_readpubek_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(30),
>  	.ordinal = TPM_ORD_READPUBEK
> 

------------------------------------------------------------------------------
