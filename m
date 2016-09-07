From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm/tpm_crb: implement tpm crb idle
 state
Date: Wed, 7 Sep 2016 10:15:48 -0600
Message-ID: <20160907161548.GA4791@obsidianresearch.com>
References: <1473247953-24617-1-git-send-email-tomas.winkler@intel.com>
	<1473247953-24617-2-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473247953-24617-2-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 07, 2016 at 02:32:31PM +0300, Tomas Winkler wrote:
> The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> SW to indicate that the device can enter or should exit the idle state.
> 
> The legacy ACPI-start (SMI + DMA) based devices do not support these
> bits and the idle state management is not exposed to the host SW.
> Thus, this functionality only is enabled only for a CRB start (MMIO)
> based devices.
> 
> We introduce two new callbacks for command ready and go idle for TPM CRB
> device which are called across TPM transactions.

Jarkko and I have been talking about higher level locking (eg to
sequence a series of operations) it might make more sense to move the
power management up to that layer. No sense in going to idle mode if
we know another command is about to come.

Are you sure this shouldn't be linked into some kind of core
kernel pm scheme? Why is this different from the existing pm stuff?

> +static int __crb_go_idle(struct device *dev, struct crb_priv *priv)
> +{
> +static int crb_go_idle(struct tpm_chip *chip)
> +{
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> +
> +	return __crb_go_idle(&chip->dev, priv);

Hurm, these ugly wrappers should probably be part of the next patch,
since that is what needs them.

Jason

------------------------------------------------------------------------------
