From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Mon, 12 Sep 2016 16:32:06 +0300
Message-ID: <20160912133206.GE957@intel.com>
References: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
	<1473670501-29281-2-git-send-email-tomas.winkler@intel.com>
	<20160912120109.GA957@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160912120109.GA957-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Mon, Sep 12, 2016 at 03:01:09PM +0300, Jarkko Sakkinen wrote:
> Could you also put this into linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org?
> 
> On Mon, Sep 12, 2016 at 11:54:58AM +0300, Tomas Winkler wrote:
> > The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> > SW to indicate that the device can enter or should exit the idle state.
> > 
> > The legacy ACPI-start (SMI + DMA) based devices do not support these
> > bits and the idle state management is not exposed to the host SW.
> > Thus, this functionality only is enabled only for a CRB start (MMIO)
> > based devices.
> > 
> > Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > oringal patch:
> > 'tpm_crb: implement power tpm crb power management'
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > V2: do not export the functions via tpm ops
> 
> I'm not sure about this. Even if callbacks are there tpm_crb and other
> device drivers can use runtime PM internally (if they want).

I give this some rethought. Using runtime PM is fine.

/Jarkko

------------------------------------------------------------------------------
