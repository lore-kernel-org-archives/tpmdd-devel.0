From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 3/5] tpm_tis_spi: Check correct byte for
	wait state indicator
Date: Fri, 17 Feb 2017 08:15:53 +0100
Message-ID: <9E032F7F-15FB-4912-B58A-AFA68D06ADE3@gmx.de>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
	<1487261306-2494-4-git-send-email-peter.huewe@infineon.com>
	<7aee3c3f-ea63-4dcc-1ed5-04c1b954cc7d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <7aee3c3f-ea63-4dcc-1ed5-04c1b954cc7d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



Am 17. Februar 2017 06:09:30 MEZ schrieb Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>That's is correct, this is a mistake on my side and never saw it :-(.
>
>I guess it was possibly leading to "waste" at least 1 wait state on
>some 
>TPMs.

Unfortunately the 1 for indicating end of waitstates does only appear once so it actually rendered the driver non-functional - atleast with our tpms.


>
>Wouldn't it be better to merge that with #1 and update the comment 
>consequently?

Yes, that's what I wanted to express in the cover letter, logically it makes sense to squash #1 and #3 - but reviewing it merged with #1 is quite hard since it "obfuscates" the problem - since too much stuff moves around.
That's why I decided to split it - for easier review.

Peter


>
>
>On 16/02/2017 08:08, Peter Huewe wrote:
>> Wait states are signaled in the last byte received from the TPM in
>> response to the header, not the first byte. Check rx_buf[3] instead
>of
>> rx_buf[0].
>>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
>> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/char/tpm/tpm_tis_spi.c | 40
>+++++++++++++++++++++-------------------
>>   1 file changed, 21 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis_spi.c
>b/drivers/char/tpm/tpm_tis_spi.c
>> index d782b9974c14..16938e2253d2 100644
>> --- a/drivers/char/tpm/tpm_tis_spi.c
>> +++ b/drivers/char/tpm/tpm_tis_spi.c
>> @@ -60,7 +60,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data
>*data, u32 addr, u8 len,
>>   				u8 *buffer, u8 direction)
>>   {
>>   	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
>> -	int ret, i;
>> +	int ret;
>>   	struct spi_message m;
>>   	struct spi_transfer spi_xfer = {
>>   		.tx_buf = phy->tx_buf,
>> @@ -85,25 +85,27 @@ static int tpm_tis_spi_transfer(struct
>tpm_tis_data *data, u32 addr, u8 len,
>>   	if (ret < 0)
>>   		goto exit;
>>   
>> -	phy->tx_buf[0] = 0;
>> -
>> -	/* According to TCG PTP specification, if there is no TPM present
>at
>> -	 * all, then the design has a weak pull-up on MISO. If a TPM is not
>> -	 * present, a pull-up on MISO means that the SB controller sees a
>1,
>> -	 * and will latch in 0xFF on the read.
>> -	 */
>> -	for (i = 0; (phy->rx_buf[0] & 0x01) == 0 && i < TPM_RETRY; i++) {
>> -		spi_xfer.len = 1;
>> -		spi_message_init(&m);
>> -		spi_message_add_tail(&spi_xfer, &m);
>> -		ret = spi_sync_locked(phy->spi_device, &m);
>> -		if (ret < 0)
>> +	if ((phy->rx_buf[3] & 0x01) == 0) {
>> +		// handle SPI wait states
>> +		int i;
>> +
>> +		phy->tx_buf[0] = 0;
>> +
>> +		for (i = 0; i < TPM_RETRY; i++) {
>> +			spi_xfer.len = 1;
>> +			spi_message_init(&m);
>> +			spi_message_add_tail(&spi_xfer, &m);
>> +			ret = spi_sync_locked(phy->spi_device, &m);
>> +			if (ret < 0)
>> +				goto exit;
>> +			if (phy->rx_buf[0] & 0x01)
>> +				break;
>> +		}
>> +
>> +		if (i == TPM_RETRY) {
>> +			ret = -ETIMEDOUT;
>>   			goto exit;
>> -	}
>> -
>> -	if (i == TPM_RETRY) {
>> -		ret = -ETIMEDOUT;
>> -		goto exit;
>> +		}
>>   	}
>>   
>>   	spi_xfer.cs_change = 0;

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
