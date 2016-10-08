From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Sat, 8 Oct 2016 19:30:38 +0300
Message-ID: <20161008163038.GA10489@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
	<1475927979-23484-2-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475927979-23484-2-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 08, 2016 at 02:59:36PM +0300, Tomas Winkler wrote:
> From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> SW to indicate that the device can enter or should exit the idle state.
> 
> The legacy ACPI-start (SMI + DMA) based devices do not support these
> bits and the idle state management is not exposed to the host SW.
> Thus, this functionality only is enabled only for a CRB start (MMIO)
> based devices.
> 
> Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> original patch:
> 'tpm_crb: implement power tpm crb power management'
> 
> To keep the implementation local to the hw we don't use wait_for_tpm_stat
> for polling the TPM_CRB_CTRL_REQ.

I just realized that the HW specific argument does not hold at all.  The
tpm_tis_core heavily uses wait_for_tpm_stat and return value of status
is synthetized.

It's upper layer for FIFO implemetations but still the arguement still
holds.

Lets keep it the way it is for now because this is fairly well test but
I might consider sending patch  that migrates to wait_for_tpm_stat unless
there is no real reason not to do so.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
