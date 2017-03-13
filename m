From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM
 family version
Date: Mon, 13 Mar 2017 11:46:11 -0700
Message-ID: <1489430771.23810.5.camel@HansenPartnership.com>
References: <1489396817-24855-1-git-send-email-Meng.Li@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1489396817-24855-1-git-send-email-Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-03-13 at 17:20 +0800, Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
[...]
> +/**
> + * tpm_create_sysfs - Create tpm sysfs interface.
> + * @dev:	pointer to tpm chip device
> + *
> + * Create sysfs interface for checking current TPM hardware version.
> + */
> +static int tpm_create_sysfs(struct device *dev)
> +{
> +	int r, t;
> +
> +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> +		r = device_create_file(dev, &tpm_attrs[t]);
> +		if (r) {
> +			dev_err(dev, "failed to create sysfs
> file\n");
> +			return r;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * tpm_remove_sysfs - Remove tpm sysfs interface.
> + * @dev:	pointer to tpm chip device
> + *
> + * Remove sysfs interface for checking current TPM hardware version.
> + */
> +static void tpm_remove_sysfs(struct device *dev)
> +{
> +	int  t;
> +
> +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> +		device_remove_file(dev, &tpm_attrs[t]);
> +	}
> +}
> +

For non-dynamic attributes, use the attribute_group structure in the
device instead.  It will take care of creation and removal
automatically.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
