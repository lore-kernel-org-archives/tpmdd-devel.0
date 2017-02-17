From: Christophe Ricard <christophe.ricard@gmail.com>
Subject: Re: [PATCH 2/5] tpm_tis_spi: Abort transfer when too many wait states
 are signaled
Date: Thu, 16 Feb 2017 21:04:40 -0800
Message-ID: <dc12ba0a-81fd-bef3-4e8a-fddebfd0d840@gmail.com>
References: <1487261306-2494-1-git-send-email-peter.huewe@infineon.com>
 <1487261306-2494-3-git-send-email-peter.huewe@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1487261306-2494-3-git-send-email-peter.huewe@infineon.com>
Sender: stable-owner@vger.kernel.org
To: Peter Huewe <peter.huewe@infineon.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, Christophe Ricard <christophe-h.ricard@st.com>, stable@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Nitpick: Are you sure this patch is necessary having #3 on top of it ?

On 16/02/2017 08:08, Peter Huewe wrote:
> Abort the transfer with ETIMEDOUT when the TPM signals more than
> TPM_RETRY wait states. Continuing with the transfer in this state
> will only lead to arbitrary failures in other parts of the code.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 0edbfea537d1 ("tpm/tpm_tis_spi: Add support for spi phy")
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
> ---
>   drivers/char/tpm/tpm_tis_spi.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index 6e1a3c43f621..d782b9974c14 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -101,6 +101,11 @@ static int tpm_tis_spi_transfer(struct tpm_tis_data *data, u32 addr, u8 len,
>   			goto exit;
>   	}
>   
> +	if (i == TPM_RETRY) {
> +		ret = -ETIMEDOUT;
> +		goto exit;
> +	}
> +
>   	spi_xfer.cs_change = 0;
>   	spi_xfer.len = len;
>   
