From: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Subject: RE: [PATCH] tpm: Fix the driver cleanup code
Date: Thu, 21 Dec 2017 21:54:26 +0000
Message-ID: <5FFFAD06ADE1CA4381B3F0F7C6AF582898918B@ORSMSX109.amr.corp.intel.com>
References: <1513887422-123222-1-git-send-email-azhar.shaikh@intel.com>
 <20171221202652.GH20015@ziepe.ca>
 <5FFFAD06ADE1CA4381B3F0F7C6AF5828989144@ORSMSX109.amr.corp.intel.com>
 <20171221203853.GI20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171221203853.GI20015@ziepe.ca>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "javierm@redhat.com" <javierm@redhat.com>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net



>-----Original Message-----
>From: linux-integrity-owner@vger.kernel.org [mailto:linux-integrity-
>owner@vger.kernel.org] On Behalf Of Jason Gunthorpe
>Sent: Thursday, December 21, 2017 12:39 PM
>To: Shaikh, Azhar <azhar.shaikh@intel.com>
>Cc: jarkko.sakkinen@linux.intel.com; javierm@redhat.com;
>peterhuewe@gmx.de; linux-security-module@vger.kernel.org; linux-
>integrity@vger.kernel.org; linux-kernel@vger.kernel.org; tpmdd-
>devel@lists.sourceforge.net
>Subject: Re: [PATCH] tpm: Fix the driver cleanup code
>
>On Thu, Dec 21, 2017 at 08:31:14PM +0000, Shaikh, Azhar wrote:
>
>> Yes I thought about it too. But if some other chip->ops function in
>> future, which *might* be in this same case, hence for that introduced
>> this flag.
>
>It can't be - the ops struct is constant, can't be modified, and tpm_tis_core
>controls what is set. If someone future person meddles in this then they can
>fix here to.
>
Yes, I checked this part. What I was referring to is any other callback function similar to clk_enable if gets added in future and then needs to
Access ops even after it is set to NULL...

>Recommend a short comment in the ops clk_enale initializer and call direct?
>

But yes I get your point now.

So do you mean something like this?

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index d9099281fc2e..1187e72483f2 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -716,8 +716,7 @@ void tpm_tis_remove(struct tpm_chip *chip)
        u32 interrupt;
        int rc;

-       if (chip->ops->clk_enable != NULL)
-               chip->ops->clk_enable(chip, true);
+       tpm_tis_clkrun_enable(chip, true);

        rc = tpm_tis_read32(priv, reg, &interrupt);
        if (rc < 0)
@@ -725,14 +724,8 @@ void tpm_tis_remove(struct tpm_chip *chip)

        tpm_tis_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);

-       if (chip->ops->clk_enable != NULL)
-               chip->ops->clk_enable(chip, false);
+       tpm_tis_clkrun_enable(chip, false);

-       if (chip->flags & TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS) {
-               down_write(&chip->ops_sem);
-               chip->ops = NULL;
-               up_write(&chip->ops_sem);
-       }
        if (priv->ilb_base_addr)
                iounmap(priv->ilb_base_addr);
 }

>Jason

Regards,
Azhar Shaikh
