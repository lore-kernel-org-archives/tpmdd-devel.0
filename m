From: Christophe Ricard <christophe.ricard@gmail.com>
Subject: Re: [PATCH 5/5] tpm_tis_spi: Add small delay after last transfer
Date: Thu, 16 Feb 2017 21:09:42 -0800
Message-ID: <d0723a12-9917-7357-e914-14fe8446afbe@gmail.com>
References: <1487261386-2641-5-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487261386-2641-5-git-send-email-peter.huewe@infineon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peter.huewe@infineon.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, Christophe Ricard <christophe-h.ricard@st.com>, stable@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Are you sure it is not better to introduce this delay directly in the 
rpi spi driver ?

Other than that i don't see any issue with it.


On 16/02/2017 08:09, Peter Huewe wrote:
> Testing the implementation with a Raspberry Pi 2 showed that under some
> circumstances its SPI master erroneously releases the CS line before the
> transfer is complete, i.e. before the end of the last clock. In this case
> the TPM ignores the transfer and misses for example the GO command. The
> driver is unable to detect this communication problem and will wait for a
> command response that is never going to arrive, timing out eventually.
>
> As a workaround, the small delay ensures that the CS line is held long
> enough, even with a faulty SPI master. Other SPI masters are not affected,
> except for a negligible performance penalty.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
> ---
>   drivers/char/tpm/tpm_tis_spi.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index b50c5b072df3..685c51bf5d7e 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -110,6 +110,7 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
>   
>   		spi_xfer.cs_change = 0;
>   		spi_xfer.len = transfer_len;
> +		spi_xfer.delay_usecs = 5;
>   
>   		if (direction) {
>   			spi_xfer.tx_buf = NULL;
