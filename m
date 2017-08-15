From: Haris Okanovic <haris.okanovic@ni.com>
Subject: Re: [PATCH] tpm_tis: fix stall after iowrite*()s
Date: Tue, 15 Aug 2017 15:10:33 -0500
Message-ID: <64235ce1-f554-ba54-12ab-a91dd77db2db@ni.com>
References: <20170804215651.29247-1-haris.okanovic@ni.com>
 <20170814225347.30670-1-haris.okanovic@ni.com> <1619753.FtnHesjV4E@ws-stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1619753.FtnHesjV4E@ws-stein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, harisokn@gmail.com, julia.cartwright@ni.com, gratian.crisan@ni.com, scott.hartman@ni.com, chris.graf@ni.com, brad.mouring@ni.com, jonathan.david@ni.com, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, eric.gardiner@ni.com
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/15/2017 01:11 AM, Alexander Stein wrote:
> On Monday 14 August 2017 17:53:47, Haris Okanovic wrote:
>> --- a/drivers/char/tpm/tpm_tis.c
>> +++ b/drivers/char/tpm/tpm_tis.c
>> @@ -52,6 +52,22 @@ static inline struct tpm_tis_tcg_phy
>> *to_tpm_tis_tcg_phy(struct tpm_tis_data *da return container_of(data,
>> struct tpm_tis_tcg_phy, priv);
>>   }
>>
>> +static inline void tpm_tis_iowrite8(u8 b, void __iomem *iobase, u32 addr)
>> +{
>> +	iowrite8(b, iobase + addr);
>> +#ifdef CONFIG_PREEMPT_RT_FULL
>> +	ioread8(iobase + TPM_ACCESS(0));
>> +#endif
>> +}
> 
> Maybe add some comment why an iorad8 is actually requried after each write on
> RT. Currently it is rather obvious why this additional read is necessary. But
> is this still the case in a year?
> 

Sure. I re-added the tpm_tis_flush() function with comments to explain 
what's going. Calling it from tpm_tis_iowrite8() and tpm_tis_iowrite32().

Will post a PATCH v2 shortly.

>> +static inline void tpm_tis_iowrite32(u32 b, void __iomem *iobase, u32 addr)
>> +{
>> +	iowrite32(b, iobase + addr);
>> +#ifdef CONFIG_PREEMPT_RT_FULL
>> +	ioread8(iobase + TPM_ACCESS(0));
>> +#endif
>> +}
> 
> Same applies here. Or add a comment above both functions describing their
> purpose.
> 
> Just my 2 cents
> 
> Best regards,
> Alexander
> 
