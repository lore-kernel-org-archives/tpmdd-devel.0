From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Mon, 12 Sep 2016 20:26:34 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CDF84@hasmsx108.ger.corp.intel.com>
References: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
	<1473670501-29281-2-git-send-email-tomas.winkler@intel.com>
	<20160912173737.GB5843@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160912173737.GB5843-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

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
> > Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> oringal
> > patch:
> > 'tpm_crb: implement power tpm crb power management'
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > V2: do not export the functions via tpm ops
> 
> You need to restructure this series, do not implement functions that are not
> used in a patch.

It's perfectly fine to stage patches for easier review, even if it cause harmless warning.

> > +static int __maybe_unused crb_go_idle(struct device *dev, struct
> > +crb_priv *priv)
> 
> .. and then don't hide the warnings with maybe_unused :(

This is not hiding,   the issue is that when runtime pm is not compiled and the hw bug is fixed in next gen of the hardware this function will be unused. 

Tomas


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
