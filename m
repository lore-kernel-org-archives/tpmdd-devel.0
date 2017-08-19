From: =?UTF-8?B?6rmA64+Z7ZiE?= <austindh.kim@gmail.com>
Subject: Re: [PATCH 5/5] Use __func__ instead of function name
Date: Sat, 19 Aug 2017 16:58:09 +0900
Message-ID: <CADLLry4Cdbdy3+gOpHrDhqbHhUdhWgGgWLeN-1MnuurbhS=ZfA@mail.gmail.com>
References: <20170729072433.13194-1-sz.lin@moxa.com> <20170729072433.13194-6-sz.lin@moxa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-6-sz.lin@moxa.com>
Sender: linux-kernel-owner@vger.kernel.org
To: SZ Lin <sz.lin@moxa.com>
Cc: ashleydlai@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

I guess below code would be better idea to gather more debug information.
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 643bba7..0aae785 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -141,6 +141,11 @@ static int tpm_ibmvtpm_send(struct tpm_chip
*chip, u8 *buf, size_t count)
                return -EIO;
        }

+       if (!buf) {
+               dev_err(ibmvtpm->dev, "%s buf null at %d \n",__func__,
rc, __LINE__);
+               return 0;
+       }
+
        spin_lock(&ibmvtpm->rtce_lock);
        memcpy((void *)ibmvtpm->rtce_buf, (void *)buf, count);
        crq.valid = (u8)IBMVTPM_VALID_CMD;
@@ -150,8 +155,9 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip,
u8 *buf, size_t count)

        rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
                              be64_to_cpu(word[1]));
+
        if (rc != H_SUCCESS) {
-               dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
+               dev_err(ibmvtpm->dev, "%s failed rc=%d at %d
\n",__func__, rc, __LINE__);
                rc = 0;
        } else
                rc = count;

2017-07-29 16:24 GMT+09:00 SZ Lin <sz.lin@moxa.com>:
> Fix following checkpatch.pl warning:
> WARNING: Prefer using '"%s...", __func__' to using
> the function's name, in a string
>
> Signed-off-by: SZ Lin <sz.lin@moxa.com>
> ---
>  drivers/char/tpm/tpm_ibmvtpm.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index e75a674b44ac..2d33acc43e25 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -151,7 +151,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>         rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
>                               be64_to_cpu(word[1]));
>         if (rc != H_SUCCESS) {
> -               dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
> +               dev_err(ibmvtpm->dev, "%s failed rc=%d\n", __func__, rc);
>                 rc = 0;
>                 ibmvtpm->tpm_processing_cmd = false;
>         } else
> @@ -193,7 +193,7 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
>                               cpu_to_be64(buf[1]));
>         if (rc != H_SUCCESS)
>                 dev_err(ibmvtpm->dev,
> -                       "ibmvtpm_crq_get_rtce_size failed rc=%d\n", rc);
> +                       "%s failed rc=%d\n", __func__, rc);
>
>         return rc;
>  }
> @@ -221,7 +221,7 @@ static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
>                               cpu_to_be64(buf[1]));
>         if (rc != H_SUCCESS)
>                 dev_err(ibmvtpm->dev,
> -                       "ibmvtpm_crq_get_version failed rc=%d\n", rc);
> +                       "%s failed rc=%d\n", __func__, rc);
>
>         return rc;
>  }
> @@ -241,7 +241,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
>         rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_COMP_CMD, 0);
>         if (rc != H_SUCCESS)
>                 dev_err(ibmvtpm->dev,
> -                       "ibmvtpm_crq_send_init_complete failed rc=%d\n", rc);
> +                       "%s rc=%d\n", __func__, rc);
>
>         return rc;
>  }
> @@ -261,7 +261,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
>         rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_CMD, 0);
>         if (rc != H_SUCCESS)
>                 dev_err(ibmvtpm->dev,
> -                       "ibmvtpm_crq_send_init failed rc=%d\n", rc);
> +                       "%s failed rc=%d\n", __func__, rc);
>
>         return rc;
>  }
> @@ -351,7 +351,7 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
>                               cpu_to_be64(buf[1]));
>         if (rc != H_SUCCESS)
>                 dev_err(ibmvtpm->dev,
> -                       "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
> +                       "%s failed rc=%d\n", __func__, rc);
>
>         return rc;
>  }
> --
> 2.13.3
>
