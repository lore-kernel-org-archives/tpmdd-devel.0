From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 6/7] tpm/tpm_tis: Split tpm_tis driver into a core and
 TCG TIS compliant phy
Date: Tue, 24 May 2016 09:58:21 +0300
Message-ID: <20160524065821.GA4993@intel.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
 <1463610953-2766-7-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463610953-2766-7-git-send-email-christophe-h.ricard@st.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Christophe Ricard <christophe.ricard@gmail.com>
Cc: jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, jean-luc.blanc@st.com, benoit.houyere@st.com, Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org, Peter Huewe <peter.huewe@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 19, 2016 at 12:35:52AM +0200, Christophe Ricard wrote:
> From: Christophe Ricard <christophe.ricard@gmail.com>
> 
> To avoid code duplication between the old tpm_tis and the new and future
> native tcg tis driver(ie: spi, i2c...), the tpm_tis driver was reworked,
> so that all common logic is extracted and can be reused from all drivers.
> 
> The core methods can also be used from other TIS like drivers.
> 
> itpm workaround is now managed with a specific tis flag
> TPM_TIS_ITPM_POSSIBLE.
> 
> Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
> Signed-off-by: Christophe Ricard <christophe-h.ricard@st.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
