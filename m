From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Mon, 15 May 2017 15:55:57 +0300
Message-ID: <20170515125557.se35ksqrzdotpib7@intel.com>
References: <20170512234058.25716-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170512234058.25716-1-joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, May 12, 2017 at 04:40:58PM -0700, Josh Zimmerman wrote:
> If a TPM2 loses power without a TPM2_Shutdown command being issued, it
> may lose some state that has yet to be persisted to NVRam, and will
> increment the DA counter (meaning that after too many disorderly
> reboots, the TPM will lock the user out).
> 
> This is a variant of https://patchwork.kernel.org/patch/9516631/.
> It differs in that:
>   * It only changes behavior on TPM2 devices, to avoid invoking the
>   unbounded-waiting sysfs codepath that was discussed on that patch, and
>   to avoid racing on chip->ops.
>   * It modifies tpm-chip rather than tpm_i2c_infineon, so that it can
>   change behavior for all TPM2 devices.
> 
> This patch is dependent on '[PATCH] Add "shutdown" to "struct class".'
> http://marc.info/?l=linux-kernel&m=149463235025420&w=2
> 
> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Split the core changes to a separate patch. Try to make a commit
message that can stand on its own. I understand what you are doing
below but after 6 months or so when I have to look at the commit
history for one reason or another this commit might become a pain
because of all these cross references. I hope you understand this.

Otherwise, thanks for doing all this effort!

/Jarkko

> ---
>  drivers/base/core.c          |  5 +++++
>  drivers/char/tpm/tpm-chip.c  | 19 +++++++++++++++++++
>  drivers/char/tpm/tpm-sysfs.c |  2 ++
>  include/linux/device.h       |  4 +++-
>  4 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 6bb60fb6a30b..687668d9afbe 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2667,6 +2667,11 @@ void device_shutdown(void)
>  		pm_runtime_get_noresume(dev);
>  		pm_runtime_barrier(dev);
>  
> +		if (dev->class && dev->class->shutdown) {
> +			if (initcall_debug)
> +				dev_info(dev, "shutdown\n");
> +			dev->class->shutdown(dev);
> +		}
>  		if (dev->bus && dev->bus->shutdown) {
>  			if (initcall_debug)
>  				dev_info(dev, "shutdown\n");
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 9dec9f551b83..024dadc0a829 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -142,6 +142,24 @@ static void tpm_devs_release(struct device *dev)
>  	put_device(&chip->dev);
>  }
>  
> +static void tpm_shutdown(struct device *dev)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	// TPM 2.0 requires that the TPM2_Shutdown() command be issued prior to
> +	// loss of power. If it is not, the DA counter will be incremented and,
> +	// eventually, the user will be locked out of their TPM.
> +	// XXX: This codepath relies on the fact that sysfs is not enabled for
> +	// TPM2: sysfs uses an implicit lock on chip->ops, so this use could
> +	// race if TPM2 has sysfs support enabled before TPM sysfs's implicit
> +	// locking is fixed.
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		down_read(&chip->ops_sem);
> +		tpm2_shutdown(chip, TPM_SU_CLEAR);
> +		chip->ops = NULL;
> +		up_read(&chip->ops_sem);
> +	}
> +}
> +
>  /**
>   * tpm_chip_alloc() - allocate a new struct tpm_chip instance
>   * @pdev: device to which the chip is associated
> @@ -181,6 +199,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	device_initialize(&chip->devs);
>  
>  	chip->dev.class = tpm_class;
> +	chip->dev.class.shutdown = tpm_shutdown;
>  	chip->dev.release = tpm_dev_release;
>  	chip->dev.parent = pdev;
>  	chip->dev.groups = chip->groups;
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 55405dbe43fa..6256f6e174b0 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -294,6 +294,8 @@ static const struct attribute_group tpm_dev_group = {
>  
>  void tpm_sysfs_add_device(struct tpm_chip *chip)
>  {
> +	// XXX: Before this restriction is removed, tpm_sysfs must be updated
> +	// to explicitly lock chip->ops.
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return;
>  
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 9ef518af5515..a150f8d3b3f1 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -378,6 +378,7 @@ int subsys_virtual_register(struct bus_type *subsys,
>   * @suspend:	Used to put the device to sleep mode, usually to a low power
>   *		state.
>   * @resume:	Used to bring the device from the sleep mode.
> + * @shutdown:	Called at shut-down time to quiesce the device.
>   * @ns_type:	Callbacks so sysfs can detemine namespaces.
>   * @namespace:	Namespace of the device belongs to this class.
>   * @pm:		The default device power management operations of this class.
> @@ -407,6 +408,7 @@ struct class {
>  
>  	int (*suspend)(struct device *dev, pm_message_t state);
>  	int (*resume)(struct device *dev);
> +	int (*shutdown)(struct device *dev);
>  
>  	const struct kobj_ns_type_operations *ns_type;
>  	const void *(*namespace)(struct device *dev);
> @@ -1228,7 +1230,7 @@ static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
>  static inline int devtmpfs_mount(const char *mountpoint) { return 0; }
>  #endif
>  
> -/* drivers/base/power/shutdown.c */
> +/* drivers/base/core.c */
>  extern void device_shutdown(void);
>  
>  /* debugging and troubleshooting/diagnostic helpers. */
> -- 
> 2.13.0.rc2.291.g57267f2277-goog
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
