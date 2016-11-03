From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: transition tpm_vtpm_proxy
 documentation  to the Sphinx
Date: Thu, 3 Nov 2016 06:55:24 -0600
Message-ID: <20161103125524.j5zjgjye52igdwh7@intel.com>
References: <20161102180207.16583-1-jarkko.sakkinen@linux.intel.com>
 <OFBE09E513.5BEBB826-ON0025805F.007A7250-8725805F.007B3C69@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFBE09E513.5BEBB826-ON0025805F.007A7250-8725805F.007B3C69@notes.na.collabserv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@us.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Thanks for the comments. I'll revise this.

/Jarkko

On Wed, Nov 02, 2016 at 03:26:00PM -0700, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote on 11/02/2016
>    12:01:56 PM:
> 
>    >
>    > Transitioned the tpm_vtpm_proxy documentation to the Sphinx
>    > infrastructure and removed parts from the documentation that are easier
>    > to pull from the sources. Restructured vtpm_proxy.h and tpm_vtpm_proxy.c
>    > to be compatible with this approach and wrote associated documentation
>    > comments.
>    >
>    > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>    > ---
>    >  Documentation/index.rst                            |  1 +
>    >  Documentation/tpm/index.rst                        |  7 +++
>    >  .../tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} | 53
>    +++++-----------
>    >  drivers/char/tpm/tpm_vtpm_proxy.c                  | 72 +++++++++++
>    > +++--------
>    >  include/uapi/linux/vtpm_proxy.h                    | 23 +++++--
>    >  5 files changed, 89 insertions(+), 67 deletions(-)
>    >  create mode 100644 Documentation/tpm/index.rst
>    >  rename Documentation/tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst}
>    (56%)
>    >
>    > diff --git a/Documentation/index.rst b/Documentation/index.rst
>    > index e0fc729..0058b65 100644
>    > --- a/Documentation/index.rst
>    > +++ b/Documentation/index.rst
>    > @@ -19,6 +19,7 @@ Contents:
>    >     media/dvb-drivers/index
>    >     media/v4l-drivers/index
>    >     gpu/index
>    > +   tpm/index
>    >  
>    >  Indices and tables
>    >  ==================
>    > diff --git a/Documentation/tpm/index.rst b/Documentation/tpm/index.rst
>    > new file mode 100644
>    > index 0000000..316cdbb
>    > --- /dev/null
>    > +++ b/Documentation/tpm/index.rst
>    > @@ -0,0 +1,7 @@
>    > +=================
>    > +TPM documentation
>    > +=================
>    > +
>    > +.. toctree::
>    > +
>    > +   tpm_vtpm_proxy
>    > diff --git a/Documentation/tpm/tpm_vtpm_proxy.txt b/Documentation/
>    > tpm/tpm_vtpm_proxy.rst
>    > similarity index 56%
>    > rename from Documentation/tpm/tpm_vtpm_proxy.txt
>    > rename to Documentation/tpm/tpm_vtpm_proxy.rst
>    > index 30d1902..f991aff 100644
>    > --- a/Documentation/tpm/tpm_vtpm_proxy.txt
>    > +++ b/Documentation/tpm/tpm_vtpm_proxy.rst
>    [...]
>    >  To make an emulated software TPM available to each container, the
>    container
>    >  management stack needs to create a device pair consisting of a client
>    TPM
>    > -character device /dev/tpmX (with X=0,1,2...) and a 'server side' file
>    > +character device ``/dev/tpmX`` (with X=0,1,2...) and a 'server side'
>    file
>    >  descriptor. The former is moved into the container by creating a
>    character
>    >  device with the appropriate major and minor numbers while the file
>    descriptor
>    >  is passed to the TPM emulator. Software inside the container can then
>    send
>    >  TPM commands using the character device and the emulator will receive
>    the
>    >  commands via the file descriptor and use it for sending back responses.
>    >  
>    > -To support this, the virtual TPM proxy driver provides a device
>    /dev/vtpmx
>    > +To support this, the virtual TPM proxy driver provides a device ``/
>    > dev/vtpmx``
>    >  that is used to create device pairs using an ioctl. The ioctl takes as
>    >  an input flags for configuring the device. The flags  for example
>    indicate
>    >  whether TPM 1.2 or TPM 2 functionality is supported by the TPM
>    emulator.
>    >  The result of the ioctl are the file descriptor for the 'server side'
>    >  as well as the major and minor numbers of the character device that
>    > was created.
>    >  Besides that the number of the TPM character device is return. If for
> 
>    Existing typo: return -> returned.
>    > -example /dev/tpm10 was created, the number (dev_num) 10 is returned.
>    > -
>    > -The following is the data structure of the TPM_PROXY_IOC_NEW_DEV ioctl:
>    > -
>    > -struct vtpm_proxy_new_dev {
>    > -   __u32 flags;         /* input */
>    > -   __u32 tpm_num;       /* output */
>    > -   __u32 fd;            /* output */
>    > -   __u32 major;         /* output */
>    > -   __u32 minor;         /* output */
>    > -};
>    > -
>    > -Note that if unsupported flags are passed to the device driver,
>    theioctl will
>    > -fail and errno will be set to EOPNOTSUPP. Similarly, if an
>    > unsupported ioctl is
>    > -called on the device driver, the ioctl will fail and errno will be set
>    to
>    > -ENOTTY.
> 
>    Users would now have to look into the spec for this.
> 
>    > -
>    > -See /usr/include/linux/vtpm_proxy.h for definitions related to the
>    > public interface
>    > -of this vTPM device driver.
>    > +example ``/dev/tpm10`` was created, the number (``dev_num``) 10 is
>    returned.
>    >  
>    >  Once the device has been created, the driver will immediately try to
>    talk
>    >  to the TPM. All commands from the driver can be read from the file
>    descriptor
>    >  returned by the ioctl. The commands should be responded to immediately.
>    >  
>    > -Depending on the version of TPM the following commands will be sent by
>    the
>    > -driver:
>    > +UAPI
>    > +====
>    >  
>    > -- TPM 1.2:
>    > -  - the driver will send a TPM_Startup command to the TPM emulator
>    > -  - the driver will send commands to read the command durations and
>    > -    interface timeouts from the TPM emulator
>    > -- TPM 2:
>    > -  - the driver will send a TPM2_Startup command to the TPM emulator
>    > +.. kernel-doc:: include/uapi/linux/vtpm_proxy.h
>    >  
>    > -The TPM device /dev/tpmX will only appear if all of the relevant
>    commands
>    > -were responded to properly.
>    > +.. kernel-doc:: drivers/char/tpm/tpm_vtpm_proxy.c
>    > +   :functions: vtpmx_ioc_new_dev
>    > diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/
>    > tpm_vtpm_proxy.c
>    > index 9a94033..a85d258 100644
>    > --- a/drivers/char/tpm/tpm_vtpm_proxy.c
>    > +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
>    > @@ -1,5 +1,6 @@
>    >  /*
>    >   * Copyright (C) 2015, 2016 IBM Corporation
>    > + * Copyright (C) 2016 Intel Corporation
>    >   *
>    >   * Author: Stefan Berger <stefanb@us.ibm.com>
>    >   *
>    > @@ -524,6 +525,50 @@ static void vtpm_proxy_delete_device(struct
>    > proxy_dev *proxy_dev)
>    >   * Code related to the control device /dev/vtpmx
>    >   */
>    >  
>    > +/**
>    > + * sgx_ioc_new_dev - handler for the %SGX_IOC_NEW_DEV ioctl
> 
>    This does not correspond to the actual filename.
> 
>    > + * @file:   /dev/vtpmx
>    > + * @ioctl:   the ioctl number
>    > + * @arg:   pointer to the struct vtpmx_proxy_new_dev
>    > + *
>    > + * Creates an anonymous file that is used by the process acting as a
>    TPM to
>    > + * communicate with the client processes. The function will also
>    > add a new TPM
>    > + * device through which data is proxied to this TPM acting process.The
>    caller
>    > + * will be provided with a file descriptor to communicate with the
>    > clients and
>    > + * major and minor numbers for the TPM device.
>    > + */
>    > +static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
>    > +               unsigned long arg)
>    > +{
>    > +   void __user *argp = (void __user *)arg;
>    > +   struct vtpm_proxy_new_dev __user *vtpm_new_dev_p;
>    > +   struct vtpm_proxy_new_dev vtpm_new_dev;
>    > +   struct file *vtpm_file;
>    > +
>    > +   if (!capable(CAP_SYS_ADMIN))
>    > +      return -EPERM;
>    > +
>    > +   vtpm_new_dev_p = argp;
>    > +
>    > +   if (copy_from_user(&vtpm_new_dev, vtpm_new_dev_p,
>    > +            sizeof(vtpm_new_dev)))
>    > +      return -EFAULT;
>    > +
>    > +   vtpm_file = vtpm_proxy_create_device(&vtpm_new_dev);
>    > +   if (IS_ERR(vtpm_file))
>    > +      return PTR_ERR(vtpm_file);
>    > +
>    > +   if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
>    > +          sizeof(vtpm_new_dev))) {
>    > +      put_unused_fd(vtpm_new_dev.fd);
>    > +      fput(vtpm_file);
>    > +      return -EFAULT;
>    > +   }
>    > +
>    > +   fd_install(vtpm_new_dev.fd, vtpm_file);
>    > +   return 0;
>    > +}
>    > +
>    >  /*
>    >   * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
>    >   *
>    > @@ -531,34 +576,11 @@ static void vtpm_proxy_delete_device(struct
>    > proxy_dev *proxy_dev)
>    >   *      Returns 0 on success, a negative error code otherwise.
>    >   */
>    >  static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
>    > -               unsigned long arg)
>    > +              unsigned long arg)
>    >  {
>    > -   void __user *argp = (void __user *)arg;
>    > -   struct vtpm_proxy_new_dev __user *vtpm_new_dev_p;
>    > -   struct vtpm_proxy_new_dev vtpm_new_dev;
>    > -   struct file *file;
>    > -
>    >     switch (ioctl) {
>    >     case VTPM_PROXY_IOC_NEW_DEV:
>    > -      if (!capable(CAP_SYS_ADMIN))
>    > -         return -EPERM;
>    > -      vtpm_new_dev_p = argp;
>    > -      if (copy_from_user(&vtpm_new_dev, vtpm_new_dev_p,
>    > -               sizeof(vtpm_new_dev)))
>    > -         return -EFAULT;
>    > -      file = vtpm_proxy_create_device(&vtpm_new_dev);
>    > -      if (IS_ERR(file))
>    > -         return PTR_ERR(file);
>    > -      if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
>    > -             sizeof(vtpm_new_dev))) {
>    > -         put_unused_fd(vtpm_new_dev.fd);
>    > -         fput(file);
>    > -         return -EFAULT;
>    > -      }
>    > -
>    > -      fd_install(vtpm_new_dev.fd, file);
>    > -      return 0;
>    > -
>    > +      return vtpmx_ioc_new_dev(f, ioctl, arg);
>    >     default:
>    >        return -ENOIOCTLCMD;
>    >     }
>    > diff --git a/include/uapi/linux/vtpm_proxy.h
>    b/include/uapi/linux/vtpm_proxy.h
>    > index 41e8e22..84c1e0a 100644
>    > --- a/include/uapi/linux/vtpm_proxy.h
>    > +++ b/include/uapi/linux/vtpm_proxy.h
>    > @@ -1,6 +1,7 @@
>    >  /*
>    >   * Definitions for the VTPM proxy driver
>    >   * Copyright (c) 2015, 2016, IBM Corporation
>    > + * Copyright (C) 2016 Intel Corporation
>    >   *
>    >   * This program is free software; you can redistribute it and/or modify
>    it
>    >   * under the terms and conditions of the GNU General Public License,
>    > @@ -18,8 +19,23 @@
>    >  #include <linux/types.h>
>    >  #include <linux/ioctl.h>
>    >  
>    > -/* ioctls */
>    > +/**
>    > + * enum mipi_dsi_dcs_tear_mode - flags for the proxy TPM
> 
>    mipi_dsi_tcs_tear_mode ?
> 
>    > + * @VTPM_PROXY_FLAG_TPM2:   the proxy TPM uses TPM 2.0 protocol
>    > + */
>    > +enum vtpm_proxy_flags {
>    > +   VTPM_PROXY_FLAG_TPM2   = 1,
>    > +};
>    >  
>    > +/**
>    > + * struct vtpm_proxy_new_dev - parameter structure for the
>    > + *                             %VTPM_PROXY_IOC_NEW_DEV ioctl
>    > + * @flags:   flags for the proxy TPM
>    > + * @tpm_num:   index of the TPM device
> 
>    The indentation for this one could be fixed.
> 
>    > + * @fd:      the file descriptor used by the proxy TPM
>    > + * @major:   the major number of the TPM device
>    > + * @minor:   the minor number of the TPM device
>    > + */
>    >  struct vtpm_proxy_new_dev {
>    >     __u32 flags;         /* input */
>    >     __u32 tpm_num;       /* output */
>    > @@ -28,9 +44,6 @@ struct vtpm_proxy_new_dev {
>    >     __u32 minor;         /* output */
>    >  };
>    >  
>    > -/* above flags */
>    > -#define VTPM_PROXY_FLAG_TPM2  1  /* emulator is TPM 2 */
>    > -
>    > -#define VTPM_PROXY_IOC_NEW_DEV   _IOWR(0xa1, 0x00, struct
>    vtpm_proxy_new_dev)
>    > +#define VTPM_PROXY_IOC_NEW_DEV   _IOWR(0xa1, 0x00, struct
>    vtpm_proxy_new_dev)
>    >  
>    >  #endif /* _UAPI_LINUX_VTPM_PROXY_H */
>    > --
>    > 2.9.3
>    >
>    >
>    >
>    ------------------------------------------------------------------------------
>    > Developer Access Program for Intel Xeon Phi Processors
>    > Access to Intel Xeon Phi processor-based developer platforms.
>    > With one year of Intel Parallel Studio XE.
>    > Training and support from Colfax.
>    > Order your platform today. http://sdm.link/xeonphi
>    > _______________________________________________
>    > tpmdd-devel mailing list
>    > tpmdd-devel@lists.sourceforge.net
>    > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>    >
