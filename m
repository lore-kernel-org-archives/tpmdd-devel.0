From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND 1/3] tpm-chip: Move idr_replace
 calls to appropriate places
Date: Mon, 28 Aug 2017 17:18:21 +0000
Message-ID: <31c462c575634ce9ae0b2aaf53f6382b@MUCSE603.infineon.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-2-Alexander.Steffen@infineon.com>
 <20170825172546.f4bl2wh7tgbyjx2n@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170825172546.f4bl2wh7tgbyjx2n-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> On Thu, Aug 24, 2017 at 10:37:12AM +0200, Alexander Steffen wrote:
> > According to the comments, adding/removing the chip from the list
> > should be the first/last action in (un)register. But currently it is
> > done in a subfunction in the middle of the process. Moving the code
> > from the subfunctions to the appropriate places within (un)register
> > ensures that the code matches the comments.
> >
> > Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-chip.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index 67ec9d3..a353b7a 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -327,11 +327,6 @@ static int tpm_add_char_device(struct tpm_chip
> *chip)
> >  		}
> >  	}
> >
> > -	/* Make the chip available. */
> > -	mutex_lock(&idr_lock);
> > -	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> > -	mutex_unlock(&idr_lock);
> > -
> >  	return rc;
> >  }
> >
> > @@ -339,11 +334,6 @@ static void tpm_del_char_device(struct tpm_chip
> > *chip)  {
> >  	cdev_device_del(&chip->cdev, &chip->dev);
> >
> > -	/* Make the chip unavailable. */
> > -	mutex_lock(&idr_lock);
> > -	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> > -	mutex_unlock(&idr_lock);
> > -
> >  	/* Make the driver uncallable. */
> >  	down_write(&chip->ops_sem);
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2) @@ -438,6 +428,11 @@ int
> > tpm_chip_register(struct tpm_chip *chip)
> >  		return rc;
> >  	}
> >
> > +	/* Make the chip available. */
> > +	mutex_lock(&idr_lock);
> > +	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> > +	mutex_unlock(&idr_lock);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_chip_register);
> > @@ -457,6 +452,11 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
> >   */
> >  void tpm_chip_unregister(struct tpm_chip *chip)  {
> > +	/* Make the chip unavailable. */
> > +	mutex_lock(&idr_lock);
> > +	idr_replace(&dev_nums_idr, NULL, chip->dev_num);
> > +	mutex_unlock(&idr_lock);
> > +
> >  	tpm_del_legacy_sysfs(chip);
> >  	tpm_bios_log_teardown(chip);
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > --
> 
> This is unnecessary and questionable code shuffling in a very critical places of
> the driver code where race conditions are easily introduced.

Can you explain what race conditions you fear here?

My understanding of the code so far is this: There are two separate paths to the TPM (from kernel and user space), that share the common driver code (tpm_transmit and everything below), but that can (in theory) exist without the other, i.e. the kernel can use the TPM without ever exporting it to user space and user space applications can send commands to the TPM without the kernel using the TPM for anything.

If the kernel wants to use the TPM, it needs to go through tpm_chip_find_get at some point. Every request from user space passes through tpm_common_write (except for everything from tpm-sysfs.c, that also somehow lacks the serialization imposed by tpm_try_get_ops, but that is a different problem). By not placing the chip into dev_nums_idr, I prevent the kernel from using the TPM while leaving the user space path intact.

So, based on those assumptions, that the kernel and user space paths are independent, until they meet at tpm_transmit, which is serialized by tpm_try_get_ops, it should not matter in what order I make the device available for kernel or user space usage, or whether I do not make it available for one of them at all. What race conditions could there be?

> If you don't have a better reason to do this, I'm not going to take this.

The comments currently state that the idr_replace calls should be the first/last step in the process, so either the code or the comments are wrong and need to be changed. I opted for changing the code, since, as explained above, I cannot see how the kernel and user space paths in this place interact (i.e. as far as I understand the code, you can place the idr_replace call anywhere after the call to tpm*_auto_startup, without being able to detect a difference). Also, "somewhere in the middle, add the chip to the list" does not make for a very useful comment ;-)

> I also fail to see the connection to the patch set as whole.

PATCH 3/3 needs a way to skip the idr_replace call under some circumstances, and this seemed like a cleaner solution than passing around additional flags, that also fixed the comment/code mismatch.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
