From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] tpm: vtpm_proxy: Suppresse error
 logging when in closed state
Date: Thu, 25 May 2017 14:53:05 -0700
Message-ID: <1495749185.29207.21.camel@perches.com>
References: <1495748360-26558-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1495748360-26558-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-05-25 at 17:39 -0400, Stefan Berger wrote:
> Suppress the error logging when the core TPM driver sends commands
> to the VTPM proxy driver and -EPIPE is returned in case the VTPM
> proxy driver is 'closed' (closed anonymous file descriptor).  This
> error code is only returned by the send function and by tpm_transmit
> when the VTPM proxy driver is being used.
> 
> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 4 ++--
>  drivers/char/tpm/tpm2-cmd.c      | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index d711186..4826fcf 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -429,11 +429,11 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  		goto out;
>  
>  	rc = chip->ops->send(chip, (u8 *) buf, count);
> -	if (rc < 0) {
> +	if (rc < 0 && rc != -EPIPE)
>  		dev_err(&chip->dev,
>  			"tpm_transmit: tpm_send: error %d\n", rc);
> +	if (rc < 0)
>  		goto out;

Perhaps this would read better as

	if (rc < 0) {
		if (rc != -EPIPE)
			dev_err(etc...);
		goto out;
	}

though for etc, perhaps
			dev_err(&chip->dev, "%s: %tpm_send: error %d\n",
				__func__, rc);

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
