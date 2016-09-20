From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: fix bad constant expressions
Date: Tue, 20 Sep 2016 07:08:40 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542EB9D8@hasmsx108.ger.corp.intel.com>
References: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1474316530-17315-3-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1474316530-17315-3-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> Sent: Monday, September 19, 2016 23:22
> To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> Cc: moderated list:TPM DEVICE DRIVER <tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>; open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Subject: [tpmdd-devel] [PATCH 2/2] tpm: fix bad constant expressions
> 
> Sparse reports "bad constant expression" for the use of cpu_to_be32 inside
> enums tpm_capabilities and tpm_sub_capabilities. Even though it is probably
> expanded to a constant expression, it is probably cleaner not to use it there.


Swap macros were rewritten due to possible compiler bug https://lkml.org/lkml/2016/5/2/597
And the warning is actually a bug in sparse, it fails to detect constant expression now.


Tomas

> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 13 ++++++++-----
>  drivers/char/tpm/tpm-sysfs.c     |  4 ++--
>  drivers/char/tpm/tpm.h           | 23 +++++++++++------------
>  3 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-
> interface.c
> index ca6162e..db7359f 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -444,19 +444,22 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32
> subcap_id, cap_t *cap,
>  	int rc;
> 
>  	tpm_cmd.header.in = tpm_getcap_header;
> -	if (subcap_id == CAP_VERSION_1_1 || subcap_id ==
> CAP_VERSION_1_2) {
> -		tpm_cmd.params.getcap_in.cap = subcap_id;
> +	if (subcap_id == TPM_CAP_VERSION_1_1 ||
> +	    subcap_id == TPM_CAP_VERSION_1_2) {
> +		tpm_cmd.params.getcap_in.cap = cpu_to_be32(subcap_id);
>  		/*subcap field not necessary */
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
>  		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
>  	} else {
>  		if (subcap_id == TPM_CAP_FLAG_PERM ||
>  		    subcap_id == TPM_CAP_FLAG_VOL)
> -			tpm_cmd.params.getcap_in.cap = TPM_CAP_FLAG;
> +			tpm_cmd.params.getcap_in.cap =
> +				cpu_to_be32(TPM_CAP_FLAG);
>  		else
> -			tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> +			tpm_cmd.params.getcap_in.cap =
> +				cpu_to_be32(TPM_CAP_PROP);
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -		tpm_cmd.params.getcap_in.subcap = subcap_id;
> +		tpm_cmd.params.getcap_in.subcap =
> cpu_to_be32(subcap_id);
>  	}
>  	rc = tpm_transmit_cmd(chip, &tpm_cmd,
> TPM_INTERNAL_RESULT_SIZE, 0,
>  			      desc);
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index a76ab4a..59a1ead 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -193,7 +193,7 @@ static ssize_t caps_show(struct device *dev, struct
> device_attribute *attr,
>  		       be32_to_cpu(cap.manufacturer_id));
> 
>  	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
> -	rc = tpm_getcap(chip, CAP_VERSION_1_2, &cap,
> +	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
>  			"attempting to determine the 1.2 version");
>  	if (!rc) {
>  		str += sprintf(str,
> @@ -204,7 +204,7 @@ static ssize_t caps_show(struct device *dev, struct
> device_attribute *attr,
>  			       cap.tpm_version_1_2.revMinor);
>  	} else {
>  		/* Otherwise just use TPM_STRUCT_VER */
> -		rc = tpm_getcap(chip, CAP_VERSION_1_1, &cap,
> +		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
>  				"attempting to determine the 1.1 version");
>  		if (rc)
>  			return 0;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h index
> 4d183c9..edc6f75 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -282,21 +282,20 @@ typedef union {
>  } cap_t;
> 
>  enum tpm_capabilities {
> -	TPM_CAP_FLAG = cpu_to_be32(4),
> -	TPM_CAP_PROP = cpu_to_be32(5),
> -	CAP_VERSION_1_1 = cpu_to_be32(0x06),
> -	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
> +	TPM_CAP_FLAG = 4,
> +	TPM_CAP_PROP = 5,
> +	TPM_CAP_VERSION_1_1 = 0x06,
> +	TPM_CAP_VERSION_1_2 = 0x1A,
>  };
> 
>  enum tpm_sub_capabilities {
> -	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
> -	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
> -	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
> -	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
> -	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
> -	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
> -	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
> -
> +	TPM_CAP_PROP_PCR = 0x101,
> +	TPM_CAP_PROP_MANUFACTURER = 0x103,
> +	TPM_CAP_FLAG_PERM = 0x108,
> +	TPM_CAP_FLAG_VOL = 0x109,
> +	TPM_CAP_PROP_OWNER = 0x111,
> +	TPM_CAP_PROP_TIS_TIMEOUT = 0x115,
> +	TPM_CAP_PROP_TIS_DURATION = 0x120,
>  };
> 
>  struct	tpm_getcap_params_in {
> --
> 2.7.4
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
