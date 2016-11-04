From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm/tpm2-chip: fix kdoc errors
Date: Thu, 3 Nov 2016 22:25:59 -0600
Message-ID: <20161104042559.b2pp3sn4xdy7yvuc@intel.com>
References: <1477962314-26763-1-git-send-email-tomas.winkler@intel.com>
	<1477962314-26763-3-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477962314-26763-3-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 01, 2016 at 03:05:14AM +0200, Tomas Winkler wrote:
> Use correct kdoc format, describe correct parameters and return values.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm2-cmd.c | 107 +++++++++++++++++++++++++++-----------------
>  1 file changed, 66 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 7df55d58c939..a7a519c87bee 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -258,11 +258,13 @@ static const struct tpm_input_header tpm2_pcrread_header = {
>   * tpm2_pcr_read() - read a PCR value
>   * @chip:	TPM chip to use.
>   * @pcr_idx:	index of the PCR to read.
> - * @ref_buf:	buffer to store the resulting hash,
> + * @res_buf:	buffer to store the resulting hash,
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + *
> + * Return:
> + *     0 when the operation is successful
> + *     A negative number for system errors (errno)
> + *     A positive number for a TPM error.
>   */
>  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  {
> @@ -304,13 +306,15 @@ static const struct tpm_input_header tpm2_pcrextend_header = {
>  
>  /**
>   * tpm2_pcr_extend() - extend a PCR value
> + *
>   * @chip:	TPM chip to use.
>   * @pcr_idx:	index of the PCR.
>   * @hash:	hash value to use for the extend operation.
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return:
> + *     0 when the operation is successful
> + *     A negative number for system errors (errno)
> + *     A positive number for a TPM error.

Put this to tpm_transmit_cmd only and refer to that from other functions
with "same as with tpm_transmit_cmd()" with parenthesis because that
marks in rst a link to that function.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
