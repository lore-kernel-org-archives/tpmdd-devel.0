From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: Re: [PATCH] tpm: fix duplicate inline declaration specifier
Date: Fri, 29 Sep 2017 17:46:41 -0700
Message-ID: <CAH7mPvhP7i=6AThzfzP1W4wXuywcjj+bn8Pu0kaBAVg7rx0fZw@mail.gmail.com>
References: <1506434337-15284-1-git-send-email-rubenroy2005@gmail.com> <20170929171704.azziyvlikbv5qnbd@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170929171704.azziyvlikbv5qnbd@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ruben Roy <rubenroy2005@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Thanks! This fixes a warning I was seeing with Clang:

drivers/char/tpm/tpm.h:560:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]

On Fri, Sep 29, 2017 at 10:17 AM, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> On Tue, Sep 26, 2017 at 01:58:57PM +0000, Ruben Roy wrote:
>> This commit fixes the duplicate inline declaration specifier in
>> tpm2_rc_value which caused a warning
>>
>> Signed-off-by: Ruben Roy <rubenroy2005@gmail.com>
>> ---
>>  drivers/char/tpm/tpm.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 04fbff2..f4d0272 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -550,7 +550,7 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
>>  }
>>  #endif
>>
>> -static inline inline u32 tpm2_rc_value(u32 rc)
>> +static inline u32 tpm2_rc_value(u32 rc)
>>  {
>>       return (rc & BIT(7)) ? rc & 0xff : rc;
>>  }
>> --
>> 1.8.3.1
>>
>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
> /Jarkko
