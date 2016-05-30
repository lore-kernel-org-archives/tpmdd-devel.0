From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Re: [PATCH v8 0/7] Rework of tpm_tis to share common logic
 across phy's (lpc/spi/-i2c-)
Date: Mon, 30 May 2016 21:36:14 +0300
Message-ID: <20160530183614.GA17850@intel.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
 <20160526122635.GA31557@intel.com>
 <trinity-dc78c674-69c6-4d45-b57b-a9bb890cf963-1464425950732@3capp-gmx-bs40>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-dc78c674-69c6-4d45-b57b-a9bb890cf963-1464425950732@3capp-gmx-bs40>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Christophe Ricard <christophe.ricard@gmail.com>, jgunthorpe@obsidianresearch.com, ashley@ashleylai.com, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, jean-luc.blanc@st.com, benoit.houyere@st.com, Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Thanks Peter! I'll add your and Stefans Reviewed/Tested-by's before
I merge these to next (will happen around rc5).

/Jarkko

On Sat, May 28, 2016 at 10:59:10AM +0200, Peter Huewe wrote:
> Thanks for all your efforts!!! I'm sorry I couldn't participate more. :(
> So thanks a lot to all of you for taking care of this.
> 
> 
> a quick testrun (x86) seemed okay and the patchset looks good to me
> reviewed-by: Peter Huewe <peterhuewe@gmx.de>
> tested-by: Peter Huewe <peterhuewe@gmx.de>
> 
> 
> I'll try to give it a more detailled testrun on the spi and i2c tpms I have and let you know if I find something.
> 
> 
> Since we are making a big change in the subsystem - does it make sense to deprecate, the old, vendor specific, mainly 1.1b, tpm drivers?
> Every time I check on a system, they initally are running on these old drivers instead of tpm_tis. :/
> For now I would probably group them under a new kconfig symbol (deprecated vendor specific drivers) so they are still available for users who really want to use them, but don't get selected by default in distro kernels.
> 
> 
> Thanks,
> Peter
> 
