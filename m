From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 01/12] tpm: tpm_tis: Share common data
	between phys
Date: Wed, 13 Apr 2016 14:34:11 -0600
Message-ID: <20160413203411.GA3836@obsidianresearch.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
	<1460577351-24632-2-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460577351-24632-2-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Apr 13, 2016 at 09:55:40PM +0200, Christophe Ricard wrote:
> As preliminary, split priv_data structure in common and phy specific
> structures.
> iobase field is specific to lpc bus.
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
>  drivers/char/tpm/tpm_tis.c      | 30 +++++++++++++++++++++++-------
>  drivers/char/tpm/tpm_tis_core.h | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 61 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_tis_core.h
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 1e45e73..cc64edb 100644
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -93,14 +93,8 @@ struct tpm_info {
>  #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
>  #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
>  
> -struct priv_data {
> +struct tpm_tis_phy {
>  	void __iomem *iobase;

The common idiom for this sort of structure is to go like this:

struct tpm_tis_lpc_phy {
        struct tpm_tis_priv priv;
 	void __iomem *iobase;
}

And drop phy_id from the 'priv'.

Instead have the actual phy driver allocate the combined structure and
set it to drvdata. When the common code accesses it, you get a
tpm_tis_priv, and the tpm_tis_priv can be container_of casted to
tpm_tis_lpc_phy/etc for phy code.

>  #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
> @@ -133,6 +127,7 @@ static inline int is_itpm(struct acpi_device *dev)
>  static int wait_startup(struct tpm_chip *chip, int l)
>  {
>  	struct priv_data *priv = dev_get_drvdata(&chip->dev);
> +	struct tpm_tis_phy *phy = priv->phy_id;
>  	unsigned long stop = jiffies + chip->timeout_a;
>  	do {
>  		if (ioread8(priv->iobase + TPM_ACCESS(l)) &

Something went wrong here, does this patch compile? Should be

  		if (ioread8(phy->iobase + TPM_ACCESS(l)) &

Please do compile test all your patches.

Otherwise this seems like the right idea

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
