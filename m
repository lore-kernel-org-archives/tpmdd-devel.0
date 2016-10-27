From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] tpm_tis: Check return values
	from	get_burstcount.
Date: Thu, 27 Oct 2016 20:31:19 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B5430F484@hasmsx108.ger.corp.intel.com>
References: <20161027174000.GA4432@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161027174000.GA4432-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> 
> If the TPM we're connecting to uses a static burst count, it will report a burst
> count of zero throughout the response read. However, get_burstcount assumes
> that a response of zero indicates that the TPM is not ready to receive more
> data. In this case, it returns a negative error code, which is passed on to
> tpm_tis_{write,read}_bytes as a u16, causing them to read/write far too many
> bytes.
> 
> This patch checks for negative return codes and bails out from recv_data and
> tpm_tis_send_data.
> 
> Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> Changelog v4:
>  - Add short description to Fixes tag line.
>  - Remove some unnecessary information in dev_err statements.
> Changelog v3:
>  - Add signed-off-by.
> Changelog v2:
>  - Fix typo (rc->burstcnt)
> 
> ---
>  drivers/char/tpm/tpm_tis_core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index e3bf31b..0f2c233 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -186,6 +186,10 @@ static int recv_data(struct tpm_chip *chip, u8 *buf,
> size_t count)
>  				 chip->timeout_c,
>  				 &priv->read_queue, true) == 0) {
>  		burstcnt = min_t(int, get_burstcount(chip), count - size);
> +		if (burstcnt < 0) {

It is much more readable to directly check get_burstcount return value, 'count - size' is protected be above condition to not reach negative value. 
                             burstcnt = get_burstcount(chip)
                             if (brustcnt < 0) ... 

                             
> +			dev_err(&chip->dev, "Unable to read burstcount\n");
> +			return burstcnt;
> +		}
> 
>  		rc = tpm_tis_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
>  					burstcnt, buf + size);
> @@ -272,6 +276,11 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8
> *buf, size_t len)
> 
>  	while (count < len - 1) {
>  		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
> +		if (burstcnt < 0) {
Same here 
> +			dev_err(&chip->dev, "Unable to read burstcount\n");
> +			rc = burstcnt;
> +			goto out_err;
> +		}
>  		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
>  					 burstcnt, buf + count);
>  		if (rc < 0)
> --
> 2.8.0.rc3.226.g39d4020

Thanks 
Tomas

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
