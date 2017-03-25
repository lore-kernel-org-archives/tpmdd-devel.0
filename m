From: Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH v4] tpm_crb: request and relinquish locality 0
Date: Sat, 25 Mar 2017 05:21:30 -0700
Message-ID: <87fui17dit.fsf@redhat.com>
References: <20170324101032.13496-1-jarkko.sakkinen@iki.fi> <20170324101922.mw7vzgesckp26wro@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <20170324101922.mw7vzgesckp26wro@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, gang.wei@intel.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


Jarkko Sakkinen @ 2017-03-24 10:19 GMT:

> On Fri, Mar 24, 2017 at 12:10:30PM +0200, Jarkko Sakkinen wrote:
>> This commit adds support for requesting and relinquishing locality 0 in
>> tpm_crb for the course of command transmission.
>> 
>> In order to achieve this, two new callbacks are added to struct
>> tpm_class_ops:
>> 
>> - request_locality
>> - relinquish_locality
>> 
>> With CRB interface you first set either requestAccess or relinquish bit
>> from TPM_LOC_CTRL_x register and then wait for locAssigned and
>> tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.
>> 
>> The reason why were are doing this is to make sure that the driver
>> will work properly with Intel TXT that uses locality 2. There's no
>> explicit guarantee that it would relinquish this locality. In more
>> general sense this commit enables tpm_crb to be a well behaving
>> citizen in a multi locality environment.
>> 
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> ---
>> v2:
>> - TPM driver level calllbacks
>> v3:
>> - Call ops->relinquish_locality only if ops->request_locality has been
>>   successful.
>> - Do not reserve locality in nested tpm_transmit calls.
>> - Check for tpmRegValidSts to make sure that the value in TPM_LOC_STATE_x is
>>   stable.
>> v4:
>> - Removed tpm_tis_core changes. It needs to be done separately. It will be
>>   postponed to 4.13.
>> - Store locality to struct tpm_chip while active.
>>  drivers/char/tpm/tpm-chip.c      |  1 +
>>  drivers/char/tpm/tpm-interface.c | 13 +++++++++++++
>>  drivers/char/tpm/tpm.h           |  3 +++
>>  drivers/char/tpm/tpm_crb.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>>  include/linux/tpm.h              |  3 ++-
>>  5 files changed, 60 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index aade699..a321bd5 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -231,6 +231,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>  		goto out;
>>  	}
>>  
>> +	chip->locality = -1;
>>  	return chip;
>>  
>>  out:
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index 95c6f98..1815666 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -384,6 +384,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>>  	ssize_t len = 0;
>>  	u32 count, ordinal;
>>  	unsigned long stop;
>> +	bool need_locality = chip->locality == -1;
>
> This must be set *after* taking the mutex. Otherwise, I think this
> should be fine now.
>
> /Jarkko

Sorry, I missed this email earlier. Yeah, I ran into this while trying to get the
tpm_tis code working with this change tonight. Are you just going to move the
assignment to right before the if block for request_locality? I've
tested with the assignment moved inside the mutex on a kabylake
system.

I also tested with a patch for adding support to tpm_tis on a tpm_tis
system, but that is a work in progress.
