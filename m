From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 0/7] Rework of tpm_tis to share common logic across
 phy's (lpc/spi/-i2c-)
Date: Tue, 24 May 2016 00:31:27 +0300
Message-ID: <20160523213127.GA31192@intel.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Christophe Ricard <christophe.ricard@gmail.com>
Cc: jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, jean-luc.blanc@st.com, benoit.houyere@st.com, Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 19, 2016 at 12:35:46AM +0200, Christophe Ricard wrote:
> Hi Jarkko,
> 
> This serie is including common work from Infineon (Peter Huewe & Alexander Steffen) and ST.
> We propose a common low level API used by a core TIS interface allowing to share
> some protocols behavior between physical layers (lpc, spi, i2c...) or drivers.
> 
> To easy the group review, i only send 10 patches showing how we rework the tpm_tis driver
> keeping existing proprietary logic (itpm workaround, irq for tpm_tis ("lpc")).
> Finally we are adding spi support based on TCG PTP specification. This additional driver
> support the SPI bit protocol including optional flow control.
> 
> Reworked tpm_tis got validated on a HP 8200 machine with an Infineon TPM
> tpm_tis_spi got validated using Minnowboard Max as well as Raspberry Pi.

I took away v7 patches from the master and applied this new series.

I didn't see anything horrific in this version but it still would be
nice to get some Tested-by's from someone besides me before considering
merging these to next. Luckily there is still time until 4.7-rc5 (I do
my feature merge after rc5).

/Jarkko
