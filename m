From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm: transition tpm_vtpm_proxy
 documentation	to the Sphinx
Date: Wed, 2 Nov 2016 15:26:00 -0700
Message-ID: <OFBE09E513.5BEBB826-ON0025805F.007A7250-8725805F.007B3C69@notes.na.collabserv.com>
References: <20161102180207.16583-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6719433994499448320=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161102180207.16583-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6719433994499448320==
Content-Type: multipart/alternative;
	boundary="=_alternative 007B3C698725805F_="


--=_alternative 007B3C698725805F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 11/02/2016=20
12:01:56 PM:

>=20
> Transitioned the tpm=5Fvtpm=5Fproxy documentation to the Sphinx
> infrastructure and removed parts from the documentation that are easier
> to pull from the sources. Restructured vtpm=5Fproxy.h and tpm=5Fvtpm=5Fpr=
oxy.c
> to be compatible with this approach and wrote associated documentation
> comments.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  Documentation/index.rst                            |  1 +
>  Documentation/tpm/index.rst                        |  7 +++
>  .../tpm/{tpm=5Fvtpm=5Fproxy.txt =3D> tpm=5Fvtpm=5Fproxy.rst} | 53=20
+++++-----------
>  drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c                  | 72 +++++++++++
> +++--------
>  include/uapi/linux/vtpm=5Fproxy.h                    | 23 +++++--
>  5 files changed, 89 insertions(+), 67 deletions(-)
>  create mode 100644 Documentation/tpm/index.rst
>  rename Documentation/tpm/{tpm=5Fvtpm=5Fproxy.txt =3D> tpm=5Fvtpm=5Fproxy=
.rst}=20
(56%)
>=20
> diff --git a/Documentation/index.rst b/Documentation/index.rst
> index e0fc729..0058b65 100644
> --- a/Documentation/index.rst
> +++ b/Documentation/index.rst
> @@ -19,6 +19,7 @@ Contents:
>     media/dvb-drivers/index
>     media/v4l-drivers/index
>     gpu/index
> +   tpm/index
>=20
>  Indices and tables
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/tpm/index.rst b/Documentation/tpm/index.rst
> new file mode 100644
> index 0000000..316cdbb
> --- /dev/null
> +++ b/Documentation/tpm/index.rst
> @@ -0,0 +1,7 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +TPM documentation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. toctree::
> +
> +   tpm=5Fvtpm=5Fproxy
> diff --git a/Documentation/tpm/tpm=5Fvtpm=5Fproxy.txt b/Documentation/
> tpm/tpm=5Fvtpm=5Fproxy.rst
> similarity index 56%
> rename from Documentation/tpm/tpm=5Fvtpm=5Fproxy.txt
> rename to Documentation/tpm/tpm=5Fvtpm=5Fproxy.rst
> index 30d1902..f991aff 100644
> --- a/Documentation/tpm/tpm=5Fvtpm=5Fproxy.txt
> +++ b/Documentation/tpm/tpm=5Fvtpm=5Fproxy.rst

[...]

>  To make an emulated software TPM available to each container, the=20
container
>  management stack needs to create a device pair consisting of a client=20
TPM
> -character device /dev/tpmX (with X=3D0,1,2...) and a 'server side' file
> +character device ``/dev/tpmX`` (with X=3D0,1,2...) and a 'server side'=20
file
>  descriptor. The former is moved into the container by creating a=20
character
>  device with the appropriate major and minor numbers while the file=20
descriptor
>  is passed to the TPM emulator. Software inside the container can then=20
send
>  TPM commands using the character device and the emulator will receive=20
the
>  commands via the file descriptor and use it for sending back responses.
>=20
> -To support this, the virtual TPM proxy driver provides a device=20
/dev/vtpmx
> +To support this, the virtual TPM proxy driver provides a device ``/
> dev/vtpmx``
>  that is used to create device pairs using an ioctl. The ioctl takes as
>  an input flags for configuring the device. The flags  for example=20
indicate
>  whether TPM 1.2 or TPM 2 functionality is supported by the TPM=20
emulator.
>  The result of the ioctl are the file descriptor for the 'server side'
>  as well as the major and minor numbers of the character device that
> was created.
>  Besides that the number of the TPM character device is return. If for

Existing typo: return -> returned.

> -example /dev/tpm10 was created, the number (dev=5Fnum) 10 is returned.
> -
> -The following is the data structure of the TPM=5FPROXY=5FIOC=5FNEW=5FDEV=
 ioctl:
> -
> -struct vtpm=5Fproxy=5Fnew=5Fdev {
> -   =5F=5Fu32 flags;         /* input */
> -   =5F=5Fu32 tpm=5Fnum;       /* output */
> -   =5F=5Fu32 fd;            /* output */
> -   =5F=5Fu32 major;         /* output */
> -   =5F=5Fu32 minor;         /* output */
> -};
> -
> -Note that if unsupported flags are passed to the device driver,=20
theioctl will
> -fail and errno will be set to EOPNOTSUPP. Similarly, if an=20
> unsupported ioctl is
> -called on the device driver, the ioctl will fail and errno will be set=20
to
> -ENOTTY.


Users would now have to look into the spec for this.


> -
> -See /usr/include/linux/vtpm=5Fproxy.h for definitions related to the=20
> public interface
> -of this vTPM device driver.
> +example ``/dev/tpm10`` was created, the number (``dev=5Fnum``) 10 is=20
returned.
>=20
>  Once the device has been created, the driver will immediately try to=20
talk
>  to the TPM. All commands from the driver can be read from the file=20
descriptor
>  returned by the ioctl. The commands should be responded to immediately.
>=20
> -Depending on the version of TPM the following commands will be sent by=20
the
> -driver:
> +UAPI
> +=3D=3D=3D=3D
>=20
> -- TPM 1.2:
> -  - the driver will send a TPM=5FStartup command to the TPM emulator
> -  - the driver will send commands to read the command durations and
> -    interface timeouts from the TPM emulator
> -- TPM 2:
> -  - the driver will send a TPM2=5FStartup command to the TPM emulator
> +.. kernel-doc:: include/uapi/linux/vtpm=5Fproxy.h
>=20
> -The TPM device /dev/tpmX will only appear if all of the relevant=20
commands
> -were responded to properly.
> +.. kernel-doc:: drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> +   :functions: vtpmx=5Fioc=5Fnew=5Fdev
> diff --git a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c b/drivers/char/tpm/
> tpm=5Fvtpm=5Fproxy.c
> index 9a94033..a85d258 100644
> --- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> +++ b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2015, 2016 IBM Corporation
> + * Copyright (C) 2016 Intel Corporation
>   *
>   * Author: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>   *
> @@ -524,6 +525,50 @@ static void vtpm=5Fproxy=5Fdelete=5Fdevice(struct=20
> proxy=5Fdev *proxy=5Fdev)
>   * Code related to the control device /dev/vtpmx
>   */
>=20
> +/**
> + * sgx=5Fioc=5Fnew=5Fdev - handler for the %SGX=5FIOC=5FNEW=5FDEV ioctl

This does not correspond to the actual filename.


> + * @file:   /dev/vtpmx
> + * @ioctl:   the ioctl number
> + * @arg:   pointer to the struct vtpmx=5Fproxy=5Fnew=5Fdev
> + *
> + * Creates an anonymous file that is used by the process acting as a=20
TPM to
> + * communicate with the client processes. The function will also=20
> add a new TPM
> + * device through which data is proxied to this TPM acting process.The=20
caller
> + * will be provided with a file descriptor to communicate with the=20
> clients and
> + * major and minor numbers for the TPM device.
> + */
> +static long vtpmx=5Fioc=5Fnew=5Fdev(struct file *file, unsigned int ioct=
l,
> +               unsigned long arg)
> +{
> +   void =5F=5Fuser *argp =3D (void =5F=5Fuser *)arg;
> +   struct vtpm=5Fproxy=5Fnew=5Fdev =5F=5Fuser *vtpm=5Fnew=5Fdev=5Fp;
> +   struct vtpm=5Fproxy=5Fnew=5Fdev vtpm=5Fnew=5Fdev;
> +   struct file *vtpm=5Ffile;
> +
> +   if (!capable(CAP=5FSYS=5FADMIN))
> +      return -EPERM;
> +
> +   vtpm=5Fnew=5Fdev=5Fp =3D argp;
> +
> +   if (copy=5Ffrom=5Fuser(&vtpm=5Fnew=5Fdev, vtpm=5Fnew=5Fdev=5Fp,
> +            sizeof(vtpm=5Fnew=5Fdev)))
> +      return -EFAULT;
> +
> +   vtpm=5Ffile =3D vtpm=5Fproxy=5Fcreate=5Fdevice(&vtpm=5Fnew=5Fdev);
> +   if (IS=5FERR(vtpm=5Ffile))
> +      return PTR=5FERR(vtpm=5Ffile);
> +
> +   if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fdev=5Fp, &vtpm=5Fnew=5Fdev,
> +          sizeof(vtpm=5Fnew=5Fdev))) {
> +      put=5Funused=5Ffd(vtpm=5Fnew=5Fdev.fd);
> +      fput(vtpm=5Ffile);
> +      return -EFAULT;
> +   }
> +
> +   fd=5Finstall(vtpm=5Fnew=5Fdev.fd, vtpm=5Ffile);
> +   return 0;
> +}
> +
>  /*
>   * vtpmx=5Ffops=5Fioctl: ioctl on /dev/vtpmx
>   *
> @@ -531,34 +576,11 @@ static void vtpm=5Fproxy=5Fdelete=5Fdevice(struct=20
> proxy=5Fdev *proxy=5Fdev)
>   *      Returns 0 on success, a negative error code otherwise.
>   */
>  static long vtpmx=5Ffops=5Fioctl(struct file *f, unsigned int ioctl,
> -               unsigned long arg)
> +              unsigned long arg)
>  {
> -   void =5F=5Fuser *argp =3D (void =5F=5Fuser *)arg;
> -   struct vtpm=5Fproxy=5Fnew=5Fdev =5F=5Fuser *vtpm=5Fnew=5Fdev=5Fp;
> -   struct vtpm=5Fproxy=5Fnew=5Fdev vtpm=5Fnew=5Fdev;
> -   struct file *file;
> -
>     switch (ioctl) {
>     case VTPM=5FPROXY=5FIOC=5FNEW=5FDEV:
> -      if (!capable(CAP=5FSYS=5FADMIN))
> -         return -EPERM;
> -      vtpm=5Fnew=5Fdev=5Fp =3D argp;
> -      if (copy=5Ffrom=5Fuser(&vtpm=5Fnew=5Fdev, vtpm=5Fnew=5Fdev=5Fp,
> -               sizeof(vtpm=5Fnew=5Fdev)))
> -         return -EFAULT;
> -      file =3D vtpm=5Fproxy=5Fcreate=5Fdevice(&vtpm=5Fnew=5Fdev);
> -      if (IS=5FERR(file))
> -         return PTR=5FERR(file);
> -      if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fdev=5Fp, &vtpm=5Fnew=5Fdev,
> -             sizeof(vtpm=5Fnew=5Fdev))) {
> -         put=5Funused=5Ffd(vtpm=5Fnew=5Fdev.fd);
> -         fput(file);
> -         return -EFAULT;
> -      }
> -
> -      fd=5Finstall(vtpm=5Fnew=5Fdev.fd, file);
> -      return 0;
> -
> +      return vtpmx=5Fioc=5Fnew=5Fdev(f, ioctl, arg);
>     default:
>        return -ENOIOCTLCMD;
>     }
> diff --git a/include/uapi/linux/vtpm=5Fproxy.h=20
b/include/uapi/linux/vtpm=5Fproxy.h
> index 41e8e22..84c1e0a 100644
> --- a/include/uapi/linux/vtpm=5Fproxy.h
> +++ b/include/uapi/linux/vtpm=5Fproxy.h
> @@ -1,6 +1,7 @@
>  /*
>   * Definitions for the VTPM proxy driver
>   * Copyright (c) 2015, 2016, IBM Corporation
> + * Copyright (C) 2016 Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify =

it
>   * under the terms and conditions of the GNU General Public License,
> @@ -18,8 +19,23 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>=20
> -/* ioctls */
> +/**
> + * enum mipi=5Fdsi=5Fdcs=5Ftear=5Fmode - flags for the proxy TPM

mipi=5Fdsi=5Ftcs=5Ftear=5Fmode ?


> + * @VTPM=5FPROXY=5FFLAG=5FTPM2:   the proxy TPM uses TPM 2.0 protocol
> + */
> +enum vtpm=5Fproxy=5Fflags {
> +   VTPM=5FPROXY=5FFLAG=5FTPM2   =3D 1,
> +};
>=20
> +/**
> + * struct vtpm=5Fproxy=5Fnew=5Fdev - parameter structure for the
> + *                             %VTPM=5FPROXY=5FIOC=5FNEW=5FDEV ioctl
> + * @flags:   flags for the proxy TPM
> + * @tpm=5Fnum:   index of the TPM device


The indentation for this one could be fixed.


> + * @fd:      the file descriptor used by the proxy TPM
> + * @major:   the major number of the TPM device
> + * @minor:   the minor number of the TPM device
> + */
>  struct vtpm=5Fproxy=5Fnew=5Fdev {
>     =5F=5Fu32 flags;         /* input */
>     =5F=5Fu32 tpm=5Fnum;       /* output */
> @@ -28,9 +44,6 @@ struct vtpm=5Fproxy=5Fnew=5Fdev {
>     =5F=5Fu32 minor;         /* output */
>  };
>=20
> -/* above flags */
> -#define VTPM=5FPROXY=5FFLAG=5FTPM2  1  /* emulator is TPM 2 */
> -
> -#define VTPM=5FPROXY=5FIOC=5FNEW=5FDEV   =5FIOWR(0xa1, 0x00, struct=20
vtpm=5Fproxy=5Fnew=5Fdev)
> +#define VTPM=5FPROXY=5FIOC=5FNEW=5FDEV   =5FIOWR(0xa1, 0x00, struct=20
vtpm=5Fproxy=5Fnew=5Fdev)
>=20
>  #endif /* =5FUAPI=5FLINUX=5FVTPM=5FPROXY=5FH */
> --=20
> 2.9.3
>=20
>=20
>=20
---------------------------------------------------------------------------=
---
> Developer Access Program for Intel Xeon Phi Processors
> Access to Intel Xeon Phi processor-based developer platforms.
> With one year of Intel Parallel Studio XE.
> Training and support from Colfax.
> Order your platform today. http://sdm.link/xeonphi
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 007B3C698725805F_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 11/02/2016 12:01:56 PM:<br><br>&gt; <br>&gt; Transitioned the tpm=
=5Fvtpm=5Fproxy documentation to the Sphinx<br>&gt; infrastructure and remo=
ved parts from the documentation that are easier<br>&gt; to pull from the s=
ources. Restructured vtpm=5Fproxy.h and tpm=5Fvtpm=5Fproxy.c<br>&gt; to be =
compatible with this approach and wrote associated documentation<br>&gt; co=
mments.<br>&gt; <br>&gt; Signed-off-by: Jarkko Sakkinen &lt;jarkko.sakkinen=
@linux.intel.com&gt;<br>&gt; ---<br>&gt; &nbsp;Documentation/index.rst &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp;1 +<br>&gt; =
&nbsp;Documentation/tpm/index.rst &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp;7 +++<br>&gt; &nbsp=
;.../tpm/{tpm=5Fvtpm=5Fproxy.txt =3D&gt; tpm=5Fvtpm=5Fproxy.rst} | 53 +++++=
-----------<br>&gt; &nbsp;drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c &nbsp; &nbs=
p; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| 72 +++++++++++<br>&gt; +++--------<br>&=
gt; &nbsp;include/uapi/linux/vtpm=5Fproxy.h &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| 23 +++++--<br>&gt; &nbsp;5 files=
 changed, 89 insertions(+), 67 deletions(-)<br>&gt; &nbsp;create mode 10064=
4 Documentation/tpm/index.rst<br>&gt; &nbsp;rename Documentation/tpm/{tpm=
=5Fvtpm=5Fproxy.txt =3D&gt; tpm=5Fvtpm=5Fproxy.rst}
(56%)<br>&gt; <br>&gt; diff --git a/Documentation/index.rst b/Documentation=
/index.rst<br>&gt; index e0fc729..0058b65 100644<br>&gt; --- a/Documentatio=
n/index.rst<br>&gt; +++ b/Documentation/index.rst<br>&gt; @@ -19,6 +19,7 @@=
 Contents:<br>&gt; &nbsp; &nbsp; media/dvb-drivers/index<br>&gt; &nbsp; &nb=
sp; media/v4l-drivers/index<br>&gt; &nbsp; &nbsp; gpu/index<br>&gt; + &nbsp=
; tpm/index<br>&gt; &nbsp;<br>&gt; &nbsp;Indices and tables<br>&gt; &nbsp;=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>&gt; diff --git a=
/Documentation/tpm/index.rst b/Documentation/tpm/index.rst<br>&gt; new file=
 mode 100644<br>&gt; index 0000000..316cdbb<br>&gt; --- /dev/null<br>&gt; +=
++ b/Documentation/tpm/index.rst<br>&gt; @@ -0,0 +1,7 @@<br>&gt; +=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>&gt; +TPM documentation<br>&g=
t; +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>&gt; +<br>&gt; +=
.. toctree::<br>&gt; +<br>&gt; + &nbsp; tpm=5Fvtpm=5Fproxy<br>&gt; diff --g=
it a/Documentation/tpm/tpm=5Fvtpm=5Fproxy.txt b/Documentation/<br>&gt; tpm/=
tpm=5Fvtpm=5Fproxy.rst<br>&gt; similarity index 56%<br>&gt; rename from Doc=
umentation/tpm/tpm=5Fvtpm=5Fproxy.txt<br>&gt; rename to Documentation/tpm/t=
pm=5Fvtpm=5Fproxy.rst<br>&gt; index 30d1902..f991aff 100644<br>&gt; --- a/D=
ocumentation/tpm/tpm=5Fvtpm=5Fproxy.txt<br>&gt; +++ b/Documentation/tpm/tpm=
=5Fvtpm=5Fproxy.rst<br></font></tt><br><tt><font size=3D2>[...]</font></tt>=
<br><tt><font size=3D2><br>&gt; &nbsp;To make an emulated software TPM avai=
lable to each container,
the container<br>&gt; &nbsp;management stack needs to create a device pair =
consisting of
a client TPM<br>&gt; -character device /dev/tpmX (with X=3D0,1,2...) and a =
'server side'
file<br>&gt; +character device ``/dev/tpmX`` (with X=3D0,1,2...) and a 'ser=
ver side'
file<br>&gt; &nbsp;descriptor. The former is moved into the container by cr=
eating
a character<br>&gt; &nbsp;device with the appropriate major and minor numbe=
rs while the
file descriptor<br>&gt; &nbsp;is passed to the TPM emulator. Software insid=
e the container
can then send<br>&gt; &nbsp;TPM commands using the character device and the=
 emulator will
receive the<br>&gt; &nbsp;commands via the file descriptor and use it for s=
ending back
responses.<br>&gt; &nbsp;<br>&gt; -To support this, the virtual TPM proxy d=
river provides a device /dev/vtpmx<br>&gt; +To support this, the virtual TP=
M proxy driver provides a device ``/<br>&gt; dev/vtpmx``<br>&gt; &nbsp;that=
 is used to create device pairs using an ioctl. The ioctl
takes as<br>&gt; &nbsp;an input flags for configuring the device. The flags=
 &nbsp;for
example indicate<br>&gt; &nbsp;whether TPM 1.2 or TPM 2 functionality is su=
pported by the TPM
emulator.<br>&gt; &nbsp;The result of the ioctl are the file descriptor for=
 the 'server
side'<br>&gt; &nbsp;as well as the major and minor numbers of the character=
 device
that<br>&gt; was created.<br>&gt; &nbsp;Besides that the number of the TPM =
character device is return.
If for</font></tt><br><br><tt><font size=3D2>Existing typo: return -&gt; re=
turned.</font></tt><br><tt><font size=3D2><br>&gt; -example /dev/tpm10 was =
created, the number (dev=5Fnum) 10 is returned.<br>&gt; -<br>&gt; -The foll=
owing is the data structure of the TPM=5FPROXY=5FIOC=5FNEW=5FDEV
ioctl:<br>&gt; -<br>&gt; -struct vtpm=5Fproxy=5Fnew=5Fdev {<br>&gt; - &nbsp=
; =5F=5Fu32 flags; &nbsp; &nbsp; &nbsp; &nbsp; /* input */<br>&gt; - &nbsp;=
 =5F=5Fu32 tpm=5Fnum; &nbsp; &nbsp; &nbsp; /* output */<br>&gt; - &nbsp; =
=5F=5Fu32 fd; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/* output
*/<br>&gt; - &nbsp; =5F=5Fu32 major; &nbsp; &nbsp; &nbsp; &nbsp; /* output =
*/<br>&gt; - &nbsp; =5F=5Fu32 minor; &nbsp; &nbsp; &nbsp; &nbsp; /* output =
*/<br>&gt; -};<br>&gt; -<br>&gt; -Note that if unsupported flags are passed=
 to the device driver, theioctl
will<br>&gt; -fail and errno will be set to EOPNOTSUPP. Similarly, if an <b=
r>&gt; unsupported ioctl is<br>&gt; -called on the device driver, the ioctl=
 will fail and errno will be
set to<br>&gt; -ENOTTY.</font></tt><br><br><br><tt><font size=3D2>Users wou=
ld now have to look into the spec for this.</font></tt><br><br><tt><font si=
ze=3D2><br>&gt; -<br>&gt; -See /usr/include/linux/vtpm=5Fproxy.h for defini=
tions related to the
<br>&gt; public interface<br>&gt; -of this vTPM device driver.<br>&gt; +exa=
mple ``/dev/tpm10`` was created, the number (``dev=5Fnum``) 10 is
returned.<br>&gt; &nbsp;<br>&gt; &nbsp;Once the device has been created, th=
e driver will immediately
try to talk<br>&gt; &nbsp;to the TPM. All commands from the driver can be r=
ead from the
file descriptor<br>&gt; &nbsp;returned by the ioctl. The commands should be=
 responded to immediately.<br>&gt; &nbsp;<br>&gt; -Depending on the version=
 of TPM the following commands will be sent
by the<br>&gt; -driver:<br>&gt; +UAPI<br>&gt; +=3D=3D=3D=3D<br>&gt; &nbsp;<=
br>&gt; -- TPM 1.2:<br>&gt; - &nbsp;- the driver will send a TPM=5FStartup =
command to the TPM emulator<br>&gt; - &nbsp;- the driver will send commands=
 to read the command durations
and<br>&gt; - &nbsp; &nbsp;interface timeouts from the TPM emulator<br>&gt;=
 -- TPM 2:<br>&gt; - &nbsp;- the driver will send a TPM2=5FStartup command =
to the TPM emulator<br>&gt; +.. kernel-doc:: include/uapi/linux/vtpm=5Fprox=
y.h<br>&gt; &nbsp;<br>&gt; -The TPM device /dev/tpmX will only appear if al=
l of the relevant
commands<br>&gt; -were responded to properly.<br>&gt; +.. kernel-doc:: driv=
ers/char/tpm/tpm=5Fvtpm=5Fproxy.c<br>&gt; + &nbsp; :functions: vtpmx=5Fioc=
=5Fnew=5Fdev<br>&gt; diff --git a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c b/d=
rivers/char/tpm/<br>&gt; tpm=5Fvtpm=5Fproxy.c<br>&gt; index 9a94033..a85d25=
8 100644<br>&gt; --- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c<br>&gt; +++ b/=
drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c<br>&gt; @@ -1,5 +1,6 @@<br>&gt; &nbsp=
;/*<br>&gt; &nbsp; * Copyright (C) 2015, 2016 IBM Corporation<br>&gt; + * C=
opyright (C) 2016 Intel Corporation<br>&gt; &nbsp; *<br>&gt; &nbsp; * Autho=
r: Stefan Berger &lt;stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org&gt;<br>&gt; &nbsp; *<br>&gt; @@ -52=
4,6 +525,50 @@ static void vtpm=5Fproxy=5Fdelete=5Fdevice(struct <br>&gt; p=
roxy=5Fdev *proxy=5Fdev)<br>&gt; &nbsp; * Code related to the control devic=
e /dev/vtpmx<br>&gt; &nbsp; */<br>&gt; &nbsp;<br>&gt; +/**<br>&gt; + * sgx=
=5Fioc=5Fnew=5Fdev - handler for the %SGX=5FIOC=5FNEW=5FDEV ioctl</font></t=
t><br><br><tt><font size=3D2>This does not correspond to the actual filenam=
e.</font></tt><br><br><tt><font size=3D2><br>&gt; + * @file: &nbsp; /dev/vt=
pmx<br>&gt; + * @ioctl: &nbsp; the ioctl number<br>&gt; + * @arg: &nbsp; po=
inter to the struct vtpmx=5Fproxy=5Fnew=5Fdev<br>&gt; + *<br>&gt; + * Creat=
es an anonymous file that is used by the process acting as
a TPM to<br>&gt; + * communicate with the client processes. The function wi=
ll also
<br>&gt; add a new TPM<br>&gt; + * device through which data is proxied to =
this TPM acting process.The
caller<br>&gt; + * will be provided with a file descriptor to communicate w=
ith the
<br>&gt; clients and<br>&gt; + * major and minor numbers for the TPM device=
.<br>&gt; + */<br>&gt; +static long vtpmx=5Fioc=5Fnew=5Fdev(struct file *fi=
le, unsigned int ioctl,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; unsigned long arg)<br>&gt; +{<br>&gt; + &nbsp; void =5F=5Fuser *arg=
p =3D (void =5F=5Fuser *)arg;<br>&gt; + &nbsp; struct vtpm=5Fproxy=5Fnew=5F=
dev =5F=5Fuser *vtpm=5Fnew=5Fdev=5Fp;<br>&gt; + &nbsp; struct vtpm=5Fproxy=
=5Fnew=5Fdev vtpm=5Fnew=5Fdev;<br>&gt; + &nbsp; struct file *vtpm=5Ffile;<b=
r>&gt; +<br>&gt; + &nbsp; if (!capable(CAP=5FSYS=5FADMIN))<br>&gt; + &nbsp;=
 &nbsp; &nbsp;return -EPERM;<br>&gt; +<br>&gt; + &nbsp; vtpm=5Fnew=5Fdev=5F=
p =3D argp;<br>&gt; +<br>&gt; + &nbsp; if (copy=5Ffrom=5Fuser(&amp;vtpm=5Fn=
ew=5Fdev, vtpm=5Fnew=5Fdev=5Fp,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp;sizeof(vtpm=5Fnew=5Fdev)))<br>&gt; + &nbsp; &nbsp; &nbsp;return -EF=
AULT;<br>&gt; +<br>&gt; + &nbsp; vtpm=5Ffile =3D vtpm=5Fproxy=5Fcreate=5Fde=
vice(&amp;vtpm=5Fnew=5Fdev);<br>&gt; + &nbsp; if (IS=5FERR(vtpm=5Ffile))<br=
>&gt; + &nbsp; &nbsp; &nbsp;return PTR=5FERR(vtpm=5Ffile);<br>&gt; +<br>&gt=
; + &nbsp; if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fdev=5Fp, &amp;vtpm=5Fnew=5Fdev=
,<br>&gt; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sizeof(vtpm=5Fnew=5Fdev))) {<=
br>&gt; + &nbsp; &nbsp; &nbsp;put=5Funused=5Ffd(vtpm=5Fnew=5Fdev.fd);<br>&g=
t; + &nbsp; &nbsp; &nbsp;fput(vtpm=5Ffile);<br>&gt; + &nbsp; &nbsp; &nbsp;r=
eturn -EFAULT;<br>&gt; + &nbsp; }<br>&gt; +<br>&gt; + &nbsp; fd=5Finstall(v=
tpm=5Fnew=5Fdev.fd, vtpm=5Ffile);<br>&gt; + &nbsp; return 0;<br>&gt; +}<br>=
&gt; +<br>&gt; &nbsp;/*<br>&gt; &nbsp; * vtpmx=5Ffops=5Fioctl: ioctl on /de=
v/vtpmx<br>&gt; &nbsp; *<br>&gt; @@ -531,34 +576,11 @@ static void vtpm=5Fp=
roxy=5Fdelete=5Fdevice(struct
<br>&gt; proxy=5Fdev *proxy=5Fdev)<br>&gt; &nbsp; * &nbsp; &nbsp; &nbsp;Ret=
urns 0 on success, a negative error
code otherwise.<br>&gt; &nbsp; */<br>&gt; &nbsp;static long vtpmx=5Ffops=5F=
ioctl(struct file *f, unsigned int ioctl,<br>&gt; - &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; unsigned long arg)<br>&gt; + &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;unsigned long arg)<br>&gt; &nbsp;{<br>&gt; - &n=
bsp; void =5F=5Fuser *argp =3D (void =5F=5Fuser *)arg;<br>&gt; - &nbsp; str=
uct vtpm=5Fproxy=5Fnew=5Fdev =5F=5Fuser *vtpm=5Fnew=5Fdev=5Fp;<br>&gt; - &n=
bsp; struct vtpm=5Fproxy=5Fnew=5Fdev vtpm=5Fnew=5Fdev;<br>&gt; - &nbsp; str=
uct file *file;<br>&gt; -<br>&gt; &nbsp; &nbsp; switch (ioctl) {<br>&gt; &n=
bsp; &nbsp; case VTPM=5FPROXY=5FIOC=5FNEW=5FDEV:<br>&gt; - &nbsp; &nbsp; &n=
bsp;if (!capable(CAP=5FSYS=5FADMIN))<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; =
return -EPERM;<br>&gt; - &nbsp; &nbsp; &nbsp;vtpm=5Fnew=5Fdev=5Fp =3D argp;=
<br>&gt; - &nbsp; &nbsp; &nbsp;if (copy=5Ffrom=5Fuser(&amp;vtpm=5Fnew=5Fdev=
, vtpm=5Fnew=5Fdev=5Fp,<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; sizeof(vtpm=5Fnew=5Fdev)))<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; re=
turn -EFAULT;<br>&gt; - &nbsp; &nbsp; &nbsp;file =3D vtpm=5Fproxy=5Fcreate=
=5Fdevice(&amp;vtpm=5Fnew=5Fdev);<br>&gt; - &nbsp; &nbsp; &nbsp;if (IS=5FER=
R(file))<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; return PTR=5FERR(file);<br>&=
gt; - &nbsp; &nbsp; &nbsp;if (copy=5Fto=5Fuser(vtpm=5Fnew=5Fdev=5Fp, &amp;v=
tpm=5Fnew=5Fdev,<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sizeof=
(vtpm=5Fnew=5Fdev)))
{<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; put=5Funused=5Ffd(vtpm=5Fnew=5Fdev.=
fd);<br>&gt; - &nbsp; &nbsp; &nbsp; &nbsp; fput(file);<br>&gt; - &nbsp; &nb=
sp; &nbsp; &nbsp; return -EFAULT;<br>&gt; - &nbsp; &nbsp; &nbsp;}<br>&gt; -=
<br>&gt; - &nbsp; &nbsp; &nbsp;fd=5Finstall(vtpm=5Fnew=5Fdev.fd, file);<br>=
&gt; - &nbsp; &nbsp; &nbsp;return 0;<br>&gt; -<br>&gt; + &nbsp; &nbsp; &nbs=
p;return vtpmx=5Fioc=5Fnew=5Fdev(f, ioctl, arg);<br>&gt; &nbsp; &nbsp; defa=
ult:<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;return -ENOIOCTLCMD;<br>&gt; &nbsp;=
 &nbsp; }<br>&gt; diff --git a/include/uapi/linux/vtpm=5Fproxy.h b/include/=
uapi/linux/vtpm=5Fproxy.h<br>&gt; index 41e8e22..84c1e0a 100644<br>&gt; ---=
 a/include/uapi/linux/vtpm=5Fproxy.h<br>&gt; +++ b/include/uapi/linux/vtpm=
=5Fproxy.h<br>&gt; @@ -1,6 +1,7 @@<br>&gt; &nbsp;/*<br>&gt; &nbsp; * Defini=
tions for the VTPM proxy driver<br>&gt; &nbsp; * Copyright (c) 2015, 2016, =
IBM Corporation<br>&gt; + * Copyright (C) 2016 Intel Corporation<br>&gt; &n=
bsp; *<br>&gt; &nbsp; * This program is free software; you can redistribute=
 it and/or
modify it<br>&gt; &nbsp; * under the terms and conditions of the GNU Genera=
l Public
License,<br>&gt; @@ -18,8 +19,23 @@<br>&gt; &nbsp;#include &lt;linux/types.=
h&gt;<br>&gt; &nbsp;#include &lt;linux/ioctl.h&gt;<br>&gt; &nbsp;<br>&gt; -=
/* ioctls */<br>&gt; +/**<br>&gt; + * enum mipi=5Fdsi=5Fdcs=5Ftear=5Fmode -=
 flags for the proxy TPM</font></tt><br><br><tt><font size=3D2>mipi=5Fdsi=
=5Ftcs=5Ftear=5Fmode ?</font></tt><br><br><tt><font size=3D2><br>&gt; + * @=
VTPM=5FPROXY=5FFLAG=5FTPM2: &nbsp; the proxy TPM uses TPM 2.0 protocol<br>&=
gt; + */<br>&gt; +enum vtpm=5Fproxy=5Fflags {<br>&gt; + &nbsp; VTPM=5FPROXY=
=5FFLAG=5FTPM2 &nbsp; =3D 1,<br>&gt; +};<br>&gt; &nbsp;<br>&gt; +/**<br>&gt=
; + * struct vtpm=5Fproxy=5Fnew=5Fdev - parameter structure for the<br>&gt;=
 + * &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; %VTPM=5FPROXY=5FIOC=5FNEW=5FDEV ioctl<br=
>&gt; + * @flags: &nbsp; flags for the proxy TPM<br>&gt; + * @tpm=5Fnum: &n=
bsp; index of the TPM device</font></tt><br><br><br><tt><font size=3D2>The =
indentation for this one could be fixed.</font></tt><br><br><tt><font size=
=3D2><br>&gt; + * @fd: &nbsp; &nbsp; &nbsp;the file descriptor used by the =
proxy
TPM<br>&gt; + * @major: &nbsp; the major number of the TPM device<br>&gt; +=
 * @minor: &nbsp; the minor number of the TPM device<br>&gt; + */<br>&gt; &=
nbsp;struct vtpm=5Fproxy=5Fnew=5Fdev {<br>&gt; &nbsp; &nbsp; =5F=5Fu32 flag=
s; &nbsp; &nbsp; &nbsp; &nbsp; /* input */<br>&gt; &nbsp; &nbsp; =5F=5Fu32 =
tpm=5Fnum; &nbsp; &nbsp; &nbsp; /* output */<br>&gt; @@ -28,9 +44,6 @@ stru=
ct vtpm=5Fproxy=5Fnew=5Fdev {<br>&gt; &nbsp; &nbsp; =5F=5Fu32 minor; &nbsp;=
 &nbsp; &nbsp; &nbsp; /* output */<br>&gt; &nbsp;};<br>&gt; &nbsp;<br>&gt; =
-/* above flags */<br>&gt; -#define VTPM=5FPROXY=5FFLAG=5FTPM2 &nbsp;1 &nbs=
p;/* emulator is TPM 2 */<br>&gt; -<br>&gt; -#define VTPM=5FPROXY=5FIOC=5FN=
EW=5FDEV &nbsp; =5FIOWR(0xa1, 0x00, struct vtpm=5Fproxy=5Fnew=5Fdev)<br>&gt=
; +#define VTPM=5FPROXY=5FIOC=5FNEW=5FDEV &nbsp; =5FIOWR(0xa1, 0x00, struct=
 vtpm=5Fproxy=5Fnew=5Fdev)<br>&gt; &nbsp;<br>&gt; &nbsp;#endif /* =5FUAPI=
=5FLINUX=5FVTPM=5FPROXY=5FH */<br>&gt; -- <br>&gt; 2.9.3<br>&gt; <br>&gt; <=
br>&gt; -------------------------------------------------------------------=
-----------<br>&gt; Developer Access Program for Intel Xeon Phi Processors<=
br>&gt; Access to Intel Xeon Phi processor-based developer platforms.<br>&g=
t; With one year of Intel Parallel Studio XE.<br>&gt; Training and support =
from Colfax.<br>&gt; Order your platform today. </font></tt><a href=3Dhttp:=
//sdm.link/xeonphi><tt><font size=3D2>http://sdm.link/xeonphi</font></tt></=
a><tt><font size=3D2><br>&gt; =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpmdd-devel mailing list<br>&gt; tpmdd-devel@=
lists.sourceforge.net<br>&gt; </font></tt><a href=3D"https://lists.sourcefo=
rge.net/lists/listinfo/tpmdd-devel"><tt><font size=3D2>https://lists.source=
forge.net/lists/listinfo/tpmdd-devel</font></tt></a><tt><font size=3D2><br>=
&gt; <br></font></tt><BR>
--=_alternative 007B3C698725805F_=--



--===============6719433994499448320==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
--===============6719433994499448320==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6719433994499448320==--
