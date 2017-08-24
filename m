From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm2-cmd: React correctly to
 RC_TESTING from self tests
Date: Thu, 24 Aug 2017 15:46:30 +0300
Message-ID: <20170824124630.xhs2g4lcvtkgqxpz@linux.intel.com>
References: <20170824083006.7704-1-Alexander.Steffen@infineon.com>
 <20170824083410.6964-1-Alexander.Steffen@infineon.com>
 <20170824083410.6964-2-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824083410.6964-2-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:34:10AM +0200, Alexander Steffen wrote:
> The TPM can choose one of two ways to react to the TPM2_SelfTest command.
> It can either run all self tests synchronously and then return RC_SUCCESS
> once all tests were successful. Or it can choose to run the tests
> asynchronously and return RC_TESTING immediately while the self tests still
> execute in the background.
> 
> The previous implementation apparently was not aware of those possibilities
> and attributed RC_TESTING to some prototype chips instead. With this change
> the return code of TPM2_SelfTest is interpreted correctly, i.e. the self
> test result is polled if and only if RC_TESTING is received.
> 
> Unfortunately, the polling cannot be done in the most straightforward way.
> If RC_TESTING is received, ideally the code should now poll the
> selfTestDone bit in the STS register, as this avoids sending more commands,
> that might interrupt self tests executing in the background and thus
> prevent them from ever completing. But it cannot be guaranteed that this
> bit is correctly implemented for all devices, so the next best thing would
> be to use TPM2_GetTestResult to query the test result. But the response to
> that command can be very long, and the code currently lacks the
> capabilities for efficient unmarshalling, so it is difficult to execute
> this command.
> 
> Therefore, we simply run the TPM2_SelfTest command in a loop, which should
> complete eventually, since we only request the execution of self tests that
> have not yet been done.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm2-cmd.c | 52 ++++++++++-----------------------------------
>  1 file changed, 11 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 2178437..70ee328 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -834,64 +834,34 @@ static const struct tpm_input_header tpm2_selftest_header = {
>  };
>  
>  /**
> - * tpm2_continue_selftest() - start a self test
> - *
> - * @chip: TPM chip to use
> - * @full: test all commands instead of testing only those that were not
> - *        previously tested.
> - *
> - * Return: Same as with tpm_transmit_cmd with exception of RC_TESTING.
> - */
> -static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
> -{
> -	int rc;
> -	struct tpm2_cmd cmd;
> -
> -	cmd.header.in = tpm2_selftest_header;
> -	cmd.params.selftest_in.full_test = full;
> -
> -	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
> -			      "continue selftest");
> -
> -	/* At least some prototype chips seem to give RC_TESTING error
> -	 * immediately. This is a workaround for that.
> -	 */
> -	if (rc == TPM2_RC_TESTING) {
> -		dev_warn(&chip->dev, "Got RC_TESTING, ignoring\n");
> -		rc = 0;
> -	}
> -
> -	return rc;
> -}
> -
> -/**
>   * tpm2_do_selftest() - ensure that all self tests have passed
>   *
>   * @chip: TPM chip to use
>   *
>   * Return: Same as with tpm_transmit_cmd.
>   *
> - * During the self test TPM2 commands return with the error code RC_TESTING.
> - * Waiting is done by issuing PCR read until it executes successfully.
> + * The TPM can either run all self tests synchronously and then return
> + * RC_SUCCESS once all tests were successful. Or it can choose to run the tests
> + * asynchronously and return RC_TESTING immediately while the self tests still
> + * execute in the background. This function handles both cases and waits until
> + * all tests have completed.
>   */
>  static int tpm2_do_selftest(struct tpm_chip *chip)
>  {
>  	int rc;
>  	unsigned int delay_msec = 20;
>  	long duration;
> +	struct tpm2_cmd cmd;
>  
>  	duration = jiffies_to_msecs(
>  		tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST));
>  
> -	rc = tpm2_start_selftest(chip, false);
> -	if (rc)
> -		return rc;
> -
>  	while (duration > 0) {
> -		/* Attempt to read a PCR value */
> -		rc = tpm2_pcr_read(chip, 0, NULL);
> -		if (rc < 0)
> -			break;
> +		cmd.header.in = tpm2_selftest_header;
> +		cmd.params.selftest_in.full_test = 0;
> +
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE,
> +				      0, 0, "continue selftest");
>  
>  		if (rc != TPM2_RC_TESTING)
>  			break;
> -- 
> 2.7.4
> 

Much better! Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

PS. I'm not subscribed at the moment to tpmdd mailing list because SF
kicked me out of the list. I've been trying to contact vger.kernel.org
to create a new ML there but haven't received any response. I just saw
your resends so it might have something to do with this. Also, patchwork
is broken ATM:

https://patchwork.kernel.org/project/tpmdd-devel/list/

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
