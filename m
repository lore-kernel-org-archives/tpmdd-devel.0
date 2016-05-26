From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v8 0/7] Rework of tpm_tis to share common
 logic across phy's (lpc/spi/-i2c-)
Date: Thu, 26 May 2016 19:35:25 +0300
Message-ID: <20160526163525.GA6752@intel.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
 <20160526122635.GA31557@intel.com>
 <20160526131932.30F57112056@b01ledav004.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160526131932.30F57112056@b01ledav004.gho.pok.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@us.ibm.com>
Cc: Christophe Ricard <christophe.ricard@gmail.com>, jean-luc.blanc@st.com, ashley@ashleylai.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, benoit.houyere@st.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 26, 2016 at 09:19:23AM -0400, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote on 05/26/2016
>    08:26:35 AM:
> 
>    >
>    > Stefan, Peter,
>    >
>    > Would it be possible for you to smoke test this patch set?
> 
>    I tested ACPI S3 suspend/resume, running a test suite on /dev/tpm0
>    (TPM_TIS), and running the vTPM test suite. These tests were done on
>    today's master of your tree on infradead. All tests passed.
> 
>    Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Thanks!

>       Stefan

/Jarkko
