From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v8 0/7] Rework of tpm_tis to share common
 logic across phy's (lpc/spi/-i2c-)
Date: Sat, 28 May 2016 10:59:10 +0200
Message-ID: <trinity-dc78c674-69c6-4d45-b57b-a9bb890cf963-1464425950732@3capp-gmx-bs40>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>,
	<20160526122635.GA31557@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160526122635.GA31557-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Thanks for all your efforts!!! I'm sorry I couldn't participate more. :(
So thanks a lot to all of you for taking care of this.


a quick testrun (x86) seemed okay and the patchset looks good to me
reviewed-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
tested-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>


I'll try to give it a more detailled testrun on the spi and i2c tpms I have and let you know if I find something.


Since we are making a big change in the subsystem - does it make sense to deprecate, the old, vendor specific, mainly 1.1b, tpm drivers?
Every time I check on a system, they initally are running on these old drivers instead of tpm_tis. :/
For now I would probably group them under a new kconfig symbol (deprecated vendor specific drivers) so they are still available for users who really want to use them, but don't get selected by default in distro kernels.


Thanks,
Peter


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
