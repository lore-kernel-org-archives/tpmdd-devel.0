From: "Li, Meng" <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM
	family version
Date: Mon, 13 Mar 2017 12:54:24 +0000
Message-ID: <529F9A9100AE8045A7A5B5A00A39FBB83DE9325F@ALA-MBC.corp.ad.wrs.com>
References: <1489396817-24855-1-git-send-email-Meng.Li@windriver.com>
	<20170313115415.2czyr4woaq4h3ncr@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170313115415.2czyr4woaq4h3ncr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> Sent: Monday, March 13, 2017 7:54 PM
> To: Li, Meng
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; peterhuewe-Mmb7MZpHnFY@public.gmane.org;
> tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; tpmdd-
> devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Subject: Re: [PATCH] tpm: Add sysfs interface to show TPM family version
> 
> On Mon, Mar 13, 2017 at 05:20:17PM +0800, Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> > From: Limeng <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> >
> > So far, there is not a sysfs interface for user space code to check
> > the TPM family version(TPM1.x or TPM2). So, add a file named
> > description in /sys/class/tpm/tpmX/ to show it.
> >
> > Signed-off-by: Meng Li <Meng.Li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> > ---
> 
> Is this the first or which version of the patch is this? Version number and
> changelog are missing :/

Hi Jarkko,

This is the second version of this patch. The first one is reviewed by Peter who give out some good advices.

It is my first time to submit patch to upstream(main line),  and I am not very clear with the submitting rule.
So, could you please give me a template to record the version and changing log?
In my previous experience, I will attach a patch-0000 to record version and describe the background of this patch.
But how to show the changing log when submit patch into mainline, I am not very  clear.

Regards,
Limeng

> 
> /Jarkko
> 
> >  drivers/char/tpm/tpm-chip.c |   70
> +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 70 insertions(+)
> >
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index c406343..b222421 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -36,6 +36,68 @@
> >  dev_t tpm_devt;
> >
> >  /**
> > + * show_description - sysfs interface for checking current TPM hardware
> version.
> > + * @dev:	pointer to tpm chip device
> > + * @attr:	unused
> > + * @buf:	char buffer to be filled with TPM hardware version info
> > + *
> > + * Provides sysfs interface for showing current TPM hardware version.
> > + */
> > +static ssize_t show_description(struct device *dev,
> > +		struct device_attribute *attr, char *buf) {
> > +	struct tpm_chip *chip = (struct tpm_chip *)container_of(dev,struct
> tpm_chip,dev);
> > +	int ret;
> > +
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		ret = sprintf(buf, "TPM 2.0");
> > +	else
> > +		ret = sprintf(buf, "TPM 1.x");
> > +
> > +	return ret;
> > +}
> > +
> > +static struct device_attribute tpm_attrs[] = {
> > +	__ATTR(description, S_IRUGO, show_description, NULL), };
> > +
> > +/**
> > + * tpm_create_sysfs - Create tpm sysfs interface.
> > + * @dev:	pointer to tpm chip device
> > + *
> > + * Create sysfs interface for checking current TPM hardware version.
> > + */
> > +static int tpm_create_sysfs(struct device *dev) {
> > +	int r, t;
> > +
> > +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> > +		r = device_create_file(dev, &tpm_attrs[t]);
> > +		if (r) {
> > +			dev_err(dev, "failed to create sysfs file\n");
> > +			return r;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * tpm_remove_sysfs - Remove tpm sysfs interface.
> > + * @dev:	pointer to tpm chip device
> > + *
> > + * Remove sysfs interface for checking current TPM hardware version.
> > + */
> > +static void tpm_remove_sysfs(struct device *dev) {
> > +	int  t;
> > +
> > +	for (t = 0; t < ARRAY_SIZE(tpm_attrs); t++) {
> > +		device_remove_file(dev, &tpm_attrs[t]);
> > +	}
> > +}
> > +
> > +/**
> >   * tpm_try_get_ops() - Get a ref to the tpm_chip
> >   * @chip: Chip to ref
> >   *
> > @@ -363,6 +425,13 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  		return rc;
> >  	}
> >
> > +	rc = tpm_create_sysfs(&chip->dev);
> > +	if (rc) {
> > +		tpm_del_legacy_sysfs(chip);
> > +		tpm_chip_unregister(chip);
> > +		return rc;
> > +	}
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_chip_register);
> > @@ -382,6 +451,7 @@ int tpm_chip_register(struct tpm_chip *chip)
> >   */
> >  void tpm_chip_unregister(struct tpm_chip *chip)  {
> > +	tpm_remove_sysfs(&chip->dev);
> >  	tpm_del_legacy_sysfs(chip);
> >  	tpm_bios_log_teardown(chip);
> >  	tpm_del_char_device(chip);
> > --
> > 1.7.9.5
> >

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
