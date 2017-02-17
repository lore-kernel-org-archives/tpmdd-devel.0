From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 4/5] tpm_tis_spi: Remove limitation of
	transfers to MAX_SPI_FRAMESIZE bytes
Date: Fri, 17 Feb 2017 08:19:40 +0100
Message-ID: <0FCA4890-55E6-44E2-B88E-EA609A8B698F@gmx.de>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
	<1487261306-2494-5-git-send-email-peter.huewe@infineon.com>
	<43990139-3687-60b6-bf1f-77593c3bcd97@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <43990139-3687-60b6-bf1f-77593c3bcd97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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



Am 17. Februar 2017 06:11:53 MEZ schrieb Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>I am not sure i understand here, are you considering there could be 
>burstcount > 64 with "TCG" TPM ?
>
With the current upstream version, any command larger with a response of more than 64 byte is broken, since the splitting loop went missing during the merge.
At least with our tpms that's the case.
(I think we are signalling a higher burstcount value than 64, which is allowed)

>Or is this because of TIS vs PTP differences ?
>
>To be honest, this is a little behind me now :-)
>
>
>On 16/02/2017 08:08, Peter Huewe wrote:
>> Limiting transfers to MAX_SPI_FRAMESIZE was not expected by the upper
>> layers, as tpm_tis has no such limitation. Add a loop to hide that
>> limitation.
>>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
>> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/char/tpm/tpm_tis_spi.c | 108
>++++++++++++++++++++++-------------------
>>   1 file changed, 57 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis_spi.c
>b/drivers/char/tpm/tpm_tis_spi.c
>> index 16938e2253d2..b50c5b072df3 100644
>> --- a/drivers/char/tpm/tpm_tis_spi.c
>> +++ b/drivers/char/tpm/tpm_tis_spi.c
>> @@ -61,68 +61,74 @@ static int tpm_tis_spi_transfer(struct
>tpm_tis_data *data, u32 addr, u8 len,
>>   {
>>   	struct tpm_tis_spi_phy *phy = to_tpm_tis_spi_phy(data);
>>   	int ret;
>> -	struct spi_message m;
>> -	struct spi_transfer spi_xfer = {
>> -		.tx_buf = phy->tx_buf,
>> -		.rx_buf = phy->rx_buf,
>> -		.len = 4,
>> -		.cs_change = 1,
>> -	};
>> -
>> -	if (len > MAX_SPI_FRAMESIZE)
>> -		return -ENOMEM;
>>   
>> -	phy->tx_buf[0] = direction | (len - 1);
>> -	phy->tx_buf[1] = 0xd4;
>> -	phy->tx_buf[2] = addr >> 8;
>> -	phy->tx_buf[3] = addr;
>> +	spi_bus_lock(phy->spi_device->master);
>>   
>> -	spi_message_init(&m);
>> -	spi_message_add_tail(&spi_xfer, &m);
>> +	while (len) {
>> +		struct spi_message m;
>> +		struct spi_transfer spi_xfer = {
>> +			.tx_buf = phy->tx_buf,
>> +			.rx_buf = phy->rx_buf,
>> +			.len = 4,
>> +			.cs_change = 1,
>> +		};
>> +		u8 transfer_len = min_t(u16, len, MAX_SPI_FRAMESIZE);
>> +
>> +		phy->tx_buf[0] = direction | (transfer_len - 1);
>> +		phy->tx_buf[1] = 0xd4;
>> +		phy->tx_buf[2] = addr >> 8;
>> +		phy->tx_buf[3] = addr;
>> +
>> +		spi_message_init(&m);
>> +		spi_message_add_tail(&spi_xfer, &m);
>> +		ret = spi_sync_locked(phy->spi_device, &m);
>> +		if (ret < 0)
>> +			goto exit;
>>   
>> -	spi_bus_lock(phy->spi_device->master);
>> -	ret = spi_sync_locked(phy->spi_device, &m);
>> -	if (ret < 0)
>> -		goto exit;
>> -
>> -	if ((phy->rx_buf[3] & 0x01) == 0) {
>> -		// handle SPI wait states
>> -		int i;
>> -
>> -		phy->tx_buf[0] = 0;
>> -
>> -		for (i = 0; i < TPM_RETRY; i++) {
>> -			spi_xfer.len = 1;
>> -			spi_message_init(&m);
>> -			spi_message_add_tail(&spi_xfer, &m);
>> -			ret = spi_sync_locked(phy->spi_device, &m);
>> -			if (ret < 0)
>> +		if ((phy->rx_buf[3] & 0x01) == 0) {
>> +			// handle SPI wait states
>> +			int i;
>> +
>> +			phy->tx_buf[0] = 0;
>> +
>> +			for (i = 0; i < TPM_RETRY; i++) {
>> +				spi_xfer.len = 1;
>> +				spi_message_init(&m);
>> +				spi_message_add_tail(&spi_xfer, &m);
>> +				ret = spi_sync_locked(phy->spi_device, &m);
>> +				if (ret < 0)
>> +					goto exit;
>> +				if (phy->rx_buf[0] & 0x01)
>> +					break;
>> +			}
>> +
>> +			if (i == TPM_RETRY) {
>> +				ret = -ETIMEDOUT;
>>   				goto exit;
>> -			if (phy->rx_buf[0] & 0x01)
>> -				break;
>> +			}
>>   		}
>>   
>> -		if (i == TPM_RETRY) {
>> -			ret = -ETIMEDOUT;
>> -			goto exit;
>> +		spi_xfer.cs_change = 0;
>> +		spi_xfer.len = transfer_len;
>> +
>> +		if (direction) {
>> +			spi_xfer.tx_buf = NULL;
>> +			spi_xfer.rx_buf = buffer;
>> +		} else {
>> +			spi_xfer.tx_buf = buffer;
>> +			spi_xfer.rx_buf = NULL;
>>   		}
>> -	}
>>   
>> -	spi_xfer.cs_change = 0;
>> -	spi_xfer.len = len;
>> +		spi_message_init(&m);
>> +		spi_message_add_tail(&spi_xfer, &m);
>> +		ret = spi_sync_locked(phy->spi_device, &m);
>> +		if (ret < 0)
>> +			goto exit;
>>   
>> -	if (direction) {
>> -		spi_xfer.tx_buf = NULL;
>> -		spi_xfer.rx_buf = buffer;
>> -	} else {
>> -		spi_xfer.tx_buf = buffer;
>> -		spi_xfer.rx_buf = NULL;
>> +		len -= transfer_len;
>> +		buffer += transfer_len;
>>   	}
>>   
>> -	spi_message_init(&m);
>> -	spi_message_add_tail(&spi_xfer, &m);
>> -	ret = spi_sync_locked(phy->spi_device, &m);
>> -
>>   exit:
>>   	spi_bus_unlock(phy->spi_device->master);
>>   	return ret;

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
