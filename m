From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 04/10] tpm: Manage itpm workaround with
 tis specific data_expect bit
Date: Sun, 10 Apr 2016 17:42:55 -0600
Message-ID: <20160410234255.GA11226@obsidianresearch.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
	<1460323386-16892-5-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460323386-16892-5-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Sun, Apr 10, 2016 at 11:23:00PM +0200, Christophe Ricard wrote:
>  	itpm = true;
> +	priv->phy_ops->data_expect_mask = 0;
> +	priv->phy_ops->data_expect_val = 0;

> +static struct tpm_tis_phy_ops tis_phy_ops = {
> +	.data_expect_mask = TPM_STS_DATA_EXPECT,
> +	.data_expect_val = TPM_STS_DATA_EXPECT,
> +};
> +
>  static int tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
>  			      u8 *result)
>  {
> @@ -844,6 +864,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	chip->timeout_b = TIS_TIMEOUT_B_MAX;
>  	chip->timeout_c = TIS_TIMEOUT_C_MAX;
>  	chip->timeout_d = TIS_TIMEOUT_D_MAX;
> +	priv->phy_ops = &tis_phy_ops;

That writes to a global static, for all probes. Don't do that.

Why is something called 'ops' having variant data? Just stick it in priv.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
