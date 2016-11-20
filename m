From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Sun, 20 Nov 2016 09:46:25 +0000
Message-ID: <20161120094625.k7knicwttdulouhe@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161119182228.GA22775@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Nayna <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Nov 19, 2016 at 11:22:28AM -0700, Jason Gunthorpe wrote:
> On Fri, Nov 18, 2016 at 07:52:49AM -0800, Jarkko Sakkinen wrote:
> > On Thu, Nov 17, 2016 at 07:30:04PM -0500, Stefan Berger wrote:
> > > tpm_bios_log_setup() may return -ENODEV in case no log was
> > > found. In this case we do not need to fail the device.
> > > 
> > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > >  drivers/char/tpm/tpm-chip.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > > index 3f27753..2d6530b 100644
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -346,7 +346,7 @@ int tpm_chip_register(struct tpm_chip *chip)
> > >  	tpm_sysfs_add_device(chip);
> > >  
> > >  	rc = tpm_bios_log_setup(chip);
> > > -	if (rc == -ENODEV)
> > > +	if (rc != -ENODEV)
> > >  		return rc;
> > >  
> > >  	tpm_add_ppi(chip);
> > 
> > CC to linux-security-module
> > 
> > LGTM
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Erm, what about rc == 0? And all the other problems?

Sorry my bad. I was not thinking clearly.

This whole situation looks like a mess. I gave a lot of thought on this
during my plane trips.

> Here, use this (untested) should take care of everything on this
> topic..
> 
> The two things I haven't seen explained are the sysfs unregister crash
> and the acpi iounmap crash :/

Yup. The reason I'm not weighting that yet so much is that I do not know
the environment.

> 
> From 8768bcb8cd2a5a17cc4d811a9298b20c3a2c0884 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Date: Sat, 19 Nov 2016 11:18:28 -0700
> Subject: [PATCH] tpm: Fix handling of missing event log
> 
> The event log is an optional firmware feature, if the firmware
> does not support it then the securityfs files should not be created
> and no other notification given.
> 
> - Uniformly return -ENODEV from the tpm_bios_log_setup cone if
>   no event log is detected.
> - Check in ACPI if this node was discovered via ACPI.
> - Improve the check in OF to make sure there is a parent and to
>   fail detection if the two log properties are not declared
> - Pass through all other error codes instead of filtering just some
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm-chip.c     |  2 +-
>  drivers/char/tpm/tpm_acpi.c     |  8 +++++++-
>  drivers/char/tpm/tpm_eventlog.c | 26 +++++++++++++-------------
>  drivers/char/tpm/tpm_of.c       | 11 +++++------
>  4 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 3f27753d96aab5..7a4869151d3b90 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -346,7 +346,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>  	tpm_sysfs_add_device(chip);
>  
>  	rc = tpm_bios_log_setup(chip);
> -	if (rc == -ENODEV)
> +	if (rc != 0 && rc != -ENODEV)
>  		return rc;
>  
>  	tpm_add_ppi(chip);
> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index 0cb43ef5f79a6e..99366bf64f3359 100644
> --- a/drivers/char/tpm/tpm_acpi.c
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -56,12 +56,18 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
>  
>  	log = &chip->log;
>  
> +	/* Unfortuntely ACPI does not associate the event log with a specific
> +	 * TPM, like PPI. Thus all ACPI TPMs will read the same log.
> +	 */
> +	if (!chip->acpi_dev_handle)
> +		return -ENODEV;
> +
>  	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
>  	status = acpi_get_table(ACPI_SIG_TCPA, 1,
>  				(struct acpi_table_header **)&buff);
>  
>  	if (ACPI_FAILURE(status))
> -		return -EIO;
> +		return -ENODEV;
>  
>  	switch(buff->platform_class) {
>  	case BIOS_SERVER:
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index fb603a74cbd29e..2a15b866ac257a 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -377,14 +377,21 @@ static int tpm_read_log(struct tpm_chip *chip)
>  	}
>  
>  	rc = tpm_read_log_acpi(chip);
> -	if ((rc == 0) || (rc == -ENOMEM))
> +	if (rc != -ENODEV)
>  		return rc;
>  
> -	rc = tpm_read_log_of(chip);
> -
> -	return rc;
> +	return tpm_read_log_of(chip);
>  }
>  
> +/*
> + * tpm_bios_log_setup() - Read the event log from the firmware
> + * @chip: TPM chip to use.
> + *
> + * If an event log is found then the securityfs files are setup to
> + * export it to userspace, otherwise nothing is done.
> + *
> + * Returns -ENODEV if the firmware has no event log.
> + */
>  int tpm_bios_log_setup(struct tpm_chip *chip)
>  {
>  	const char *name = dev_name(&chip->dev);
> @@ -395,15 +402,8 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>  		return 0;
>  
>  	rc = tpm_read_log(chip);
> -	/*
> -	 * read_log failure means event log is not supported except for ENOMEM.
> -	 */
> -	if (rc < 0) {
> -		if (rc == -ENOMEM)
> -			return -ENODEV;
> -		else
> -			return rc;
> -	}

WTF. I really have to be much more focused when I looked this. That
is more than wrong... Too much multitasking last couple of weeks. That's
my excuse...

I can consider putting the patch set to the next release but I really
would want yet another version with change log what fixes were done and
why.

/Jarkko

