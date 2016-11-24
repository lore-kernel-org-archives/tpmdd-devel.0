From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/4 v2] tpm/tpm2-chip: fix kdoc errors
Date: Thu, 24 Nov 2016 15:16:44 +0200
Message-ID: <20161124131644.5hg4mp2gdzlup5zk@intel.com>
References: <1479315821-27349-1-git-send-email-tomas.winkler@intel.com>
	<1479315821-27349-2-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479315821-27349-2-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Wed, Nov 16, 2016 at 07:03:39PM +0200, Tomas Winkler wrote:
> Use correct kdoc format, describe correct parameters and return values.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> ---
> V2: rework and rebase of tpm_transmit_cmd kdoc fix
> 
>  drivers/char/tpm/tpm2-cmd.c | 104 ++++++++++++++++++++++++--------------------
>  1 file changed, 57 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index da5b782a9731..6f9eea7eda7a 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -258,11 +258,9 @@ static const struct tpm_input_header tpm2_pcrread_header = {
>   * tpm2_pcr_read() - read a PCR value
>   * @chip:	TPM chip to use.
>   * @pcr_idx:	index of the PCR to read.
> - * @ref_buf:	buffer to store the resulting hash,
> + * @res_buf:	buffer to store the resulting hash,
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return: same as with tpm_transmit_cmd
>   */
>  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  {
> @@ -304,13 +302,12 @@ static const struct tpm_input_header tpm2_pcrextend_header = {
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
> + * Return: same as with tpm_transmit_cmd
>   */
>  int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
>  {
> @@ -348,13 +345,14 @@ static const struct tpm_input_header tpm2_getrandom_header = {
>  
>  /**
>   * tpm2_get_random() - get random bytes from the TPM RNG
> + *
>   * @chip: TPM chip to use
>   * @out: destination buffer for the random bytes
>   * @max: the max number of bytes to write to @out
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return:
> + *    size of the output buffer;
> + *    -EIO on error
>   */
>  int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
>  {
> @@ -404,15 +402,16 @@ static const struct tpm_input_header tpm2_get_tpm_pt_header = {
>  };
>  
>  /**
> - * Append TPMS_AUTH_COMMAND to the buffer. The buffer must be allocated with
> - * tpm_buf_alloc().
> - *
> - * @param buf: an allocated tpm_buf instance
> - * @param nonce: the session nonce, may be NULL if not used
> - * @param nonce_len: the session nonce length, may be 0 if not used
> - * @param attributes: the session attributes
> - * @param hmac: the session HMAC or password, may be NULL if not used
> - * @param hmac_len: the session HMAC or password length, maybe 0 if not used
> + * tpm_buf_alloc() - Append TPMS_AUTH_COMMAND to the buffer.
> + *      The buffer must be allocated with
> + *
> + * @buf: an allocated tpm_buf instance
> + * @session_handle: session handle
> + * @nonce: the session nonce, may be NULL if not used
> + * @nonce_len: the session nonce length, may be 0 if not used
> + * @attributes: the session attributes
> + * @hmac: the session HMAC or password, may be NULL if not used
> + * @hmac_len: the session HMAC or password length, maybe 0 if not used
>   */
>  static void tpm2_buf_append_auth(struct tpm_buf *buf, u32 session_handle,
>  				 const u8 *nonce, u16 nonce_len,
> @@ -435,7 +434,8 @@ static void tpm2_buf_append_auth(struct tpm_buf *buf, u32 session_handle,
>  
>  /**
>   * tpm2_seal_trusted() - seal the payload of a trusted key
> - * @chip_num: TPM chip to use
> + *
> + * @chip: TPM chip to use
>   * @payload: the key data in clear and encrypted form
>   * @options: authentication values and other options
>   *
> @@ -540,11 +540,17 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  
>  /**
>   * tpm2_load_cmd() - execute a TPM2_Load command
> - * @chip_num: TPM chip to use
> + *
> + * @chip: TPM chip to use
>   * @payload: the key data in clear and encrypted form
>   * @options: authentication values and other options
> + * @blob_handle: returned blob handle
> + * @flags: tpm transmit flags
>   *
> - * Return: same as with tpm_transmit_cmd
> + * Return: 0 on success
> + *        -E2BIG on wrong payload size
> + *        -EPERM on tpm error status
> + *        < 0 error from tpm_transmit_cmd
>   */
>  static int tpm2_load_cmd(struct tpm_chip *chip,
>  			 struct trusted_key_payload *payload,
> @@ -600,9 +606,10 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
>  
>  /**
>   * tpm2_flush_context_cmd() - execute a TPM2_FlushContext command
> - * @chip_num: TPM chip to use
> - * @payload: the key data in clear and encrypted form
> - * @options: authentication values and other options
> + *
> + * @chip: TPM chip to use
> + * @handle: the key data in clear and encrypted form
> + * @flags: tpm transmit flags
>   *
>   * Return: same as with tpm_transmit_cmd
>   */
> @@ -632,11 +639,16 @@ static void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
>  
>  /**
>   * tpm2_unseal_cmd() - execute a TPM2_Unload command
> - * @chip_num: TPM chip to use
> + *
> + * @chip: TPM chip to use
>   * @payload: the key data in clear and encrypted form
>   * @options: authentication values and other options
> + * @blob_handle: blob handle
> + * @flags: tpm_transmit_cmd flags
>   *
> - * Return: same as with tpm_transmit_cmd
> + * Return: 0 on success
> + *         -EPERM on tpm error status
> + *         < 0 error from tpm_transmit_cmd
>   */
>  static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  			   struct trusted_key_payload *payload,
> @@ -681,11 +693,12 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  
>  /**
>   * tpm2_unseal_trusted() - unseal the payload of a trusted key
> - * @chip_num: TPM chip to use
> + *
> + * @chip: TPM chip to use
>   * @payload: the key data in clear and encrypted form
>   * @options: authentication values and other options
>   *
> - * Return: < 0 on error and 0 on success.
> + * Return: same as with tpm_transmit_cmd
>   */
>  int tpm2_unseal_trusted(struct tpm_chip *chip,
>  			struct trusted_key_payload *payload,
> @@ -715,9 +728,7 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
>   * @value:		output variable.
>   * @desc:		passed to tpm_transmit_cmd()
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return: same as with tpm_transmit_cmd
>   */
>  ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  			const char *desc)
> @@ -750,13 +761,12 @@ static const struct tpm_input_header tpm2_startup_header = {
>  
>  /**
>   * tpm2_startup() - send startup command to the TPM chip
> + *
>   * @chip:		TPM chip to use.
> - * @startup_type	startup type. The value is either
> + * @startup_type:	startup type. The value is either
>   *			TPM_SU_CLEAR or TPM_SU_STATE.
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return: same as with tpm_transmit_cmd
>   */
>  static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
>  {
> @@ -781,8 +791,9 @@ static const struct tpm_input_header tpm2_shutdown_header = {
>  
>  /**
>   * tpm2_shutdown() - send shutdown command to the TPM chip
> + *
>   * @chip:		TPM chip to use.
> - * @shutdown_type	shutdown type. The value is either
> + * @shutdown_type:	shutdown type. The value is either
>   *			TPM_SU_CLEAR or TPM_SU_STATE.
>   */
>  void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
> @@ -805,12 +816,11 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
>  
>  /*
>   * tpm2_calc_ordinal_duration() - maximum duration for a command
> + *
>   * @chip:	TPM chip to use.
>   * @ordinal:	command code number.
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return: maximum duration for a command
>   */
>  unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
>  {
> @@ -842,13 +852,12 @@ static const struct tpm_input_header tpm2_selftest_header = {
>  
>  /**
>   * tpm2_continue_selftest() - start a self test
> + *
>   * @chip: TPM chip to use
>   * @full: test all commands instead of testing only those that were not
>   *        previously tested.
>   *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
> + * Return: same as with tpm_transmit_cmd with exception of RC_TESTING
>   */
>  static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
>  {
> @@ -874,14 +883,13 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
>  
>  /**
>   * tpm2_do_selftest() - run a full self test
> + *
>   * @chip: TPM chip to use
>   *
> + * Return: same as with tpm_transmit_cmd
> + *
>   * During the self test TPM2 commands return with the error code RC_TESTING.
>   * Waiting is done by issuing PCR read until it executes successfully.
> - *
> - * 0 is returned when the operation is successful. If a negative number is
> - * returned it remarks a POSIX error code. If a positive number is returned
> - * it remarks a TPM error.
>   */
>  static int tpm2_do_selftest(struct tpm_chip *chip)
>  {
> @@ -928,6 +936,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>   * tpm2_probe() - probe TPM 2.0
>   * @chip: TPM chip to use
>   *
> + * Return: < 0 error and 0 on success.
> + *
>   * Send idempotent TPM 2.0 command and see whether TPM 2.0 chip replied based on
>   * the reply tag.
>   */
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
