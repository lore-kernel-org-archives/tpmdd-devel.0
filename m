From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] tpm: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Thu, 18 May 2017 08:21:32 -0700
Message-ID: <CAHSjozBoysvjHh_4hKuE8v7Sq3L9LjmZEcpCb_SZ=g63GpS7Aw@mail.gmail.com>
References: <20170516000852.28400-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170516000852.28400-1-joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Are there any other changes I should make to this patch, or is it good
to go once the patch it depends on is in?

Thanks!
Josh


On Mon, May 15, 2017 at 5:08 PM, Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> If a TPM2 loses power without a TPM2_Shutdown command being issued (a
> "disorderly reboot"), it may lose some state that has yet to be
> persisted to NVRam, and will increment the DA counter (eventually, this
> will cause the TPM to lock the user out.)
>
> NOTE: This only changes behavior on TPM2 devices. Since TPM1 uses sysfs,
> and sysfs relies on implicit locking on chip->ops, it is not safe to
> allow this code to run in TPM1, or to add sysfs support to TPM2, until
> that locking is made explicit.
>
> This patch is dependent on '[PATCH] Add "shutdown" to "struct class".'
> http://marc.info/?l=linux-kernel&m=149463235025420&w=2
>
> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> ----
> v2:
>   - Properly split changes between this and another commit
>   - Use proper locking primitive.
>   - Fix commenting style
> v3:
>   - Re-fix commenting style
> ---
>  drivers/char/tpm/tpm-chip.c  | 20 ++++++++++++++++++++
>  drivers/char/tpm/tpm-sysfs.c |  3 +++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 9dec9f551b83..272a42e77574 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -142,6 +142,25 @@ static void tpm_devs_release(struct device *dev)
>         put_device(&chip->dev);
>  }
>
> +static void tpm_shutdown(struct device *dev)
> +{
> +       struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +       /* TPM 2.0 requires that the TPM2_Shutdown() command be issued prior to
> +        * loss of power. If it is not, the DA counter will be incremented and,
> +        * eventually, the user will be locked out of their TPM.
> +        * XXX: This codepath relies on the fact that sysfs is not enabled for
> +        * TPM2: sysfs uses an implicit lock on chip->ops, so this use could
> +        * race if TPM2 has sysfs support enabled before TPM sysfs's implicit
> +        * locking is fixed.
> +        */
> +       if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +               down_write(&chip->ops_sem);
> +               tpm2_shutdown(chip, TPM_SU_CLEAR);
> +               chip->ops = NULL;
> +               up_write(&chip->ops_sem);
> +       }
> +}
> +
>  /**
>   * tpm_chip_alloc() - allocate a new struct tpm_chip instance
>   * @pdev: device to which the chip is associated
> @@ -181,6 +200,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>         device_initialize(&chip->devs);
>
>         chip->dev.class = tpm_class;
> +       chip->dev.class.shutdown = tpm_shutdown;
>         chip->dev.release = tpm_dev_release;
>         chip->dev.parent = pdev;
>         chip->dev.groups = chip->groups;
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 55405dbe43fa..5e5ff7eb6f7e 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -294,6 +294,9 @@ static const struct attribute_group tpm_dev_group = {
>
>  void tpm_sysfs_add_device(struct tpm_chip *chip)
>  {
> +       /* XXX: Before this restriction is removed, tpm_sysfs must be updated
> +        * to explicitly lock chip->ops.
> +        */
>         if (chip->flags & TPM_CHIP_FLAG_TPM2)
>                 return;
>
> --
> 2.13.0.303.g4ebf302169-goog
>

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
