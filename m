From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 01/10] tpm_tis: Introduce intermediate
 layer for TPM access
Date: Sun, 10 Apr 2016 17:45:25 -0600
Message-ID: <20160410234525.GC11226@obsidianresearch.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
	<1460323386-16892-2-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460323386-16892-2-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Apr 10, 2016 at 11:22:57PM +0200, Christophe Ricard wrote:
> This splits tpm_tis in a high-level protocol part and a low-level interface
> for the actual TPM communication. The low-level interface can then be
> implemented by additional drivers to provide access to TPMs using other
> mechanisms, for example native I2C or SPI transfers, while still reusing
> the same TIS protocol implementation.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
>  drivers/char/tpm/tpm.h     |  41 ++++++++++
>  drivers/char/tpm/tpm_tis.c | 188 ++++++++++++++++++++++++++-------------------
>  include/linux/tpm.h        |  11 +++
>  3 files changed, 160 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8bc6fb8..a8f48a2 100644
> +++ b/drivers/char/tpm/tpm.h
> @@ -149,6 +149,7 @@ struct tpm_chip {
>  	 * when the driver is unregistered, see tpm_try_get_ops.
>  	 */
>  	struct rw_semaphore ops_sem;
> +	const struct tpm_class_lowlevel *lowlevel;

Why? Put that stuff in the tis phy ops you already created

> +static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
> +				  u8 *result)

And these don't belong in a the common header either

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
