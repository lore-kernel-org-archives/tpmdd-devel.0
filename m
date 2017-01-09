From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 4/4] tpm: add the infrastructure for
 TPM    space for TPM 2.0
Date: Tue, 10 Jan 2017 00:11:16 +0200
Message-ID: <20170109221116.qe33dkfdhpx7dlck@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <20170102132213.22880-5-jarkko.sakkinen@linux.intel.com>
 <OF9C3EE9AE.65978870-ON0025809E.0061E7AF-8525809E.0061FFDA@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF9C3EE9AE.65978870-ON0025809E.0061E7AF-8525809E.0061FFDA@notes.na.collabserv.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@us.ibm.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 12:50:21PM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote on 01/02/2017
>    08:22:10 AM:
> 
>    >
>    > Added a ioctl for creating a TPM space. The space is isolated from the
>    > other users of the TPM. Only a process holding the file with the handle
>    > can access the objects and only objects that are created through that
>    > file handle can be accessed.
>    >
>    > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>    > ---
> 
>    > diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
>    > index 912ad30..139638b 100644
>    > --- a/drivers/char/tpm/tpm-dev.c
>    > +++ b/drivers/char/tpm/tpm-dev.c
>    > @@ -19,6 +19,7 @@
>    >   */
>    >  #include <linux/slab.h>
>    >  #include <linux/uaccess.h>
>    > +#include <uapi/linux/tpm.h>
>    >  #include "tpm.h"
>    >  
>    >  struct file_priv {
>    > @@ -32,6 +33,8 @@ struct file_priv {
>    >     struct work_struct work;
>    >  
>    >     u8 data_buffer[TPM_BUFSIZE];
>    > +   struct tpm_space space;
>    > +   bool has_space;
>    >  };
>    >  
>    >  static void user_reader_timeout(unsigned long ptr)
>    > @@ -115,6 +118,7 @@ static ssize_t tpm_write(struct file *file,
>    > const char __user *buf,
>    >            size_t size, loff_t *off)
>    >  {
>    >     struct file_priv *priv = file->private_data;
>    > +   struct tpm_space *space = NULL;
>    >     size_t in_size = size;
>    >     ssize_t out_size;
>    >  
>    > @@ -130,6 +134,9 @@ static ssize_t tpm_write(struct file *file,
>    > const char __user *buf,
>    >  
>    >     mutex_lock(&priv->buffer_mutex);
>    >  
>    > +   if (priv->has_space)
>    > +      space = &priv->space;
>    > +
>    >     if (copy_from_user
>    >         (priv->data_buffer, (void __user *) buf, in_size)) {
>    >        mutex_unlock(&priv->buffer_mutex);
>    > @@ -144,7 +151,7 @@ static ssize_t tpm_write(struct file *file,
>    > const char __user *buf,
>    >        mutex_unlock(&priv->buffer_mutex);
>    >        return -EPIPE;
>    >     }
>    > -   out_size = tpm_transmit(priv->chip, priv->data_buffer,
>    > +   out_size = tpm_transmit(priv->chip, space, priv->data_buffer,
>    >              sizeof(priv->data_buffer), 0);
>    >  
>    >     tpm_put_ops(priv->chip);
>    > @@ -162,6 +169,65 @@ static ssize_t tpm_write(struct file *file,
>    > const char __user *buf,
>    >     return in_size;
>    >  }
>    >  
>    > +/**
>    > + * tpm_ioc_new_space - handler for %SGX_IOC_NEW_SPACE ioctl
>    > + *
>    > + * Creates a new TPM space that can hold a set of transient
>    > objects. The space
>    > + * is isolated with virtual handles that are mapped into physical
>    > handles by the
>    > + * driver.
>    > + */
>    > +static long tpm_ioc_new_space(struct file *file, unsigned int ioctl,
>    > +               unsigned long arg)
>    > +{
>    > +   struct file_priv *priv = file->private_data;
>    > +   struct tpm_chip *chip = priv->chip;
>    > +   int rc = 0;
>    > +
>    > +   if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>    > +      return -EOPNOTSUPP;
>    > +
>    > +   mutex_lock(&priv->buffer_mutex);
>    > +
>    > +   if (priv->has_space) {
>    > +      rc = -EBUSY;
>    > +      goto out;
>    > +   }
>    > +
>    > +   priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>    > +   if (!priv->space.context_buf) {
>    > +      rc = -ENOMEM;
>    > +      goto out;
>    > +   }
>    > +
>    > +   /* The TPM device can be opened again as this file has been moved to
>    a
>    > +    * TPM handle space.
>    > +    */
>    > +   priv->has_space = true;
>    > +   clear_bit(0, &chip->is_open);
>    > +out:
>    > +   mutex_unlock(&priv->buffer_mutex);
>    > +   return rc;
>    > +}
>    > +
>    > +static long tpm_ioctl(struct file *file, unsigned int ioctl,
>    > +            unsigned long arg)
>    > +{
>    > +   switch (ioctl) {
>    > +   case TPM_IOC_NEW_SPACE:
>    > +      return tpm_ioc_new_space(file, ioctl, arg);
>    > +   default:
>    > +      return -ENOIOCTLCMD;
>    > +   }
>    > +}
>    > +
>    > +#ifdef CONFIG_COMPAT
>    > +static long tpm_compat_ioctl(struct file *file, unsigned int ioctl,
>    > +              unsigned long arg)
>    > +{
>    > +   return tpm_ioctl(file, ioctl, arg);
>    > +}
>    > +#endif
>    > +
>    >  /*
>    >   * Called on file close
>    >   */
>    > @@ -169,6 +235,14 @@ static int tpm_release(struct inode *inode,
>    > struct file *file)
>    >  {
>    >     struct file_priv *priv = file->private_data;
>    >  
>    > +   if (tpm_try_get_ops(priv->chip)) {
>    > +      mutex_unlock(&priv->buffer_mutex);
>    > +      return -EPIPE;
>    > +   }
> 
>    That mutex_unlock looks wrong.

Thanks.

This will be anyway gone with own device file.

>       Stefan

/Jarkko
