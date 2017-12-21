From: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Subject: RE: [PATCH] tpm: Fix the driver cleanup code
Date: Thu, 21 Dec 2017 20:31:14 +0000
Message-ID: <5FFFAD06ADE1CA4381B3F0F7C6AF5828989144@ORSMSX109.amr.corp.intel.com>
References: <1513887422-123222-1-git-send-email-azhar.shaikh@intel.com>
 <20171221202652.GH20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171221202652.GH20015@ziepe.ca>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "javierm@redhat.com" <javierm@redhat.com>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net



>-----Original Message-----
>From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
>Sent: Thursday, December 21, 2017 12:27 PM
>To: Shaikh, Azhar <azhar.shaikh@intel.com>
>Cc: jarkko.sakkinen@linux.intel.com; javierm@redhat.com;
>peterhuewe@gmx.de; linux-security-module@vger.kernel.org; linux-
>integrity@vger.kernel.org; linux-kernel@vger.kernel.org; tpmdd-
>devel@lists.sourceforge.net
>Subject: Re: [PATCH] tpm: Fix the driver cleanup code
>
>On Thu, Dec 21, 2017 at 12:17:02PM -0800, Azhar Shaikh wrote:
>> Commit 3c1701339284353c41 ("tpm: Keep CLKRUN enabled throughout the
>> duration of transmit_cmd()") added code which accessed
>> chip->ops, even after it was set to NULL in tpm_del_char_device(),
>> called from tpm_chip_unregister() in error / driver exit paths.
>> So fix this code.
>>
>> Fixes: 3c1701339284353c41 ("tpm: Keep CLKRUN enabled throughout the
>> duration of transmit_cmd()")
>>
>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
>> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
>>  drivers/char/tpm/tpm-chip.c     |  5 +++++
>>  drivers/char/tpm/tpm.h          |  1 +
>>  drivers/char/tpm/tpm_tis.c      |  8 ++------
>>  drivers/char/tpm/tpm_tis_core.c | 23 +++++++++++++++--------
>> drivers/char/tpm/tpm_tis_spi.c  |  1 +
>>  5 files changed, 24 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 0a62c19937b6..c88ec9a32a7e 100644
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -346,6 +346,10 @@ static void tpm_del_char_device(struct tpm_chip
>*chip)
>>  	down_write(&chip->ops_sem);
>>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>> +	if (chip->flags & TPM_CHIP_FLAG_DO_NOT_CLEAR_OPS) {
>> +		up_write(&chip->ops_sem);
>> +		return;
>> +	}
>
>Yikes, too ugly. Figure something else out.. ops->clk_enable is always
>tpm_tis_clkrun_enable at this point, so maybe call it directly in the removal
>path in tpm_tis_core?
>

Yes I thought about it too. But if some other chip->ops function in future, which *might* be in this same case, hence for that introduced this flag.
I can use ops->clk_enable instead of introducing the new flag.

>Jason

Regards,
Azhar Shaikh
