From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 4/5] tpm: Move irqs field from
 tpm_vendor_specific to tpm_chip structure
Date: Wed, 23 Mar 2016 16:52:18 -0600
Message-ID: <20160323225218.GC17397@obsidianresearch.com>
References: <1458764240-24185-1-git-send-email-christophe-h.ricard@st.com>
	<1458764240-24185-5-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458764240-24185-5-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Mar 23, 2016 at 09:17:19PM +0100, Christophe Ricard wrote:
> In order to complete the tpm_vendor_specific cleanup structure move irqs
> specific fields to tpm_chip. It make sense to be in this place as those
> fields are part of the tpm properties.

No, sprinkle these two fields into the drivers.

> @@ -359,7 +359,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
>  		goto out;
>  	}
>  
> -	if (chip->vendor.irq)
> +	if (chip->irq)
>  		goto out_recv;
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> @@ -890,7 +890,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  
>  	stop = jiffies + timeout;
>  
> -	if (chip->vendor.irq) {
> +	if (chip->irq) {

This should be something smarter, a chip->flags or something is a
little better than this.

Ideally, the driver facing API would be fixed and this behavior would
be in a utility function the driver can call in the standard recv
path, not weird like this.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
