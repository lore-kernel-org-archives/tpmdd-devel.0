From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/12] tpm/tpm_tis: Split tpm_tis driver
 into a core and TCG TIS compliant phy
Date: Mon, 21 Mar 2016 23:35:59 +0100
Message-ID: <56F0774F.7040707@gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-9-git-send-email-christophe-h.ricard@st.com>
	<20160321013243.GA9417@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160321013243.GA9417-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

My answers/questions below.

Best Regards
Christophe

On 21/03/2016 02:32, Jason Gunthorpe wrote:
> On Sun, Mar 20, 2016 at 08:34:39PM +0100, Christophe Ricard wrote:
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -142,6 +142,7 @@ struct tpm_vendor_specific {
>>   
>>   	int region_size;
>>   	int have_region;
>> +	bool itpm;
>>   
>>   	struct list_head list;
>>   	int locality;
>> @@ -149,6 +150,7 @@ struct tpm_vendor_specific {
>>   	bool timeout_adjusted;
>>   	unsigned long duration[3]; /* jiffies */
>>   	bool duration_adjusted;
>> +	bool irq_tested;
>>   	void *priv;
> No adding driver specific stuff to this structure.
I suppose irq_tested is fine because it is common all drivers and 
related to irq management. I guess it can be moved below irq field.
I somewhat understand your mean for itpm.
I believe it is specific for the legacy/lpc/0xfed4xxxx addressing mode. 
Can you confirm ?

For itpm workaround, i would like to use 2 additional specific fields in 
tpm_class_ops called req_expected_val and req_expected_mask.
req_expected_val and req_expected_mask would be set in all phys with 
TPM_STS_DATA_EXPECT.
An additional tpm_class_ops ops called for example tpm_postprobe for 
additional phys specific operations handling in tpm_tis the itpm workaround.
req_expected_val and req_expected_mask would be set to 0 in tpm_tis in 
case itpm is set to true and probe_itpm set itpm to true.

This would remove the need of any itpm mention in the tpm_tis_core 
layer. What do you think ?
>
>>   	list_for_each_entry(id, &dev->pnp.ids, list)
>> -		if (!strcmp(hid, id->id))
>> -			return 1;
>> +	if (!strcmp(hid, id->id))
>> +		return 1;
> useless change
Ok
>> +static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
>> +	/* Atmel 3204 */
>> +	{ 0x32041114, { (TIS_SHORT_TIMEOUT * 1000), (TIS_LONG_TIMEOUT * 1000),
>> +			(TIS_SHORT_TIMEOUT * 1000), (TIS_SHORT_TIMEOUT * 1000) } },
>> +};
> This initializer should not be in a header file
I will move it in tpm_tis_core.c
>
>> +/* Helpers - read */
>> +static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr,
>> +				 size_t len, u8 *res)
>> +{
>> +	return chip->ops->read_bytes(chip, addr, len, 1, res);
>> +}
>> +static inline u8 tpm_read_byte(struct tpm_chip *chip, u32 addr)
> Are these all actually used? I would have thought only read32 would be
> needed. Please use better names, tpm_read32,
> read8, etc.
I did a quick check of the complete set and found all of them are used.
> Jason


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
