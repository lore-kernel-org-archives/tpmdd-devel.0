From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 3/5] tpm: Factor out reading of timeout
 and duration capabilities
Date: Sun, 19 Jun 2016 14:12:14 +0200
Message-ID: <20160619120157.GA29626@intel.com>
References: <1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
	<1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
	<1465610107-87762-4-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465610107-87762-4-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 10, 2016 at 06:55:05PM -0700, Ed Swierk wrote:
> Factor sending the TPM_GetCapability command and validating the result
> from tpm_get_timeouts() into a new function. Return all errors to the
> caller rather than swallowing them (e.g. when tpm_transmit_cmd()
> returns nonzero).
> 
> Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 96 ++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 44 deletions(-)

I'm sorry but just now that I started applying these patches this patch
started to bother me.

> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index cc1e5bc..4d1f62c 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -502,6 +502,52 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  				"attempting to start the TPM");
>  }
>  
> +static int tpm_get_cap_prop(struct tpm_chip *chip, __be32 type, int size,
> +			    cap_t *cap, char *desc)
> +{
> +	struct tpm_cmd_t tpm_cmd;
> +	ssize_t rc;
> +
> +	tpm_cmd.header.in = tpm_getcap_header;
> +	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> +	tpm_cmd.params.getcap_in.subcap = type;
> +	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
> +
> +	if (rc == TPM_ERR_INVALID_POSTINIT) {
> +		/* The TPM is not started, we are the first to talk to it.
> +		   Execute a startup command. */
> +		dev_info(chip->pdev, "Issuing TPM_STARTUP\n");
> +		if (tpm_startup(chip, TPM_ST_CLEAR))
> +			return rc;
> +
> +		tpm_cmd.header.in = tpm_getcap_header;
> +		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> +		tpm_cmd.params.getcap_in.subcap = type;
> +		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +				  NULL);
> +	}

I think inside tpm_get_timeouts() I'd rather something along the lines
(with error handling and such details taken away):

rc = tpm_getcap(...);

if (rc == TPM_ERR_INVALID_POSTINIT) {
	tpm_startup(...);
	tpm_getca(...);
}


> +	if (rc) {
> +		dev_err(chip->pdev,
> +			"Error %zd reading %s\n", rc, desc);
> +		return rc;
> +	}
> +
> +	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> +	    be32_to_cpu(tpm_cmd.header.out.length)
> +	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + size * sizeof(u32)) {
> +		dev_err(chip->pdev,
> +			"Bad return code or length reading %s\n", desc);
> +		return -EINVAL;
> +	}

This is bogus code. All this kind of checks should be contained in
tpm_transmit_cmd(). This is easily "fixed" by moving tpm_getcap() :)

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
