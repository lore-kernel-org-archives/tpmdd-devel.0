From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 1/2] Documentation: tpm: add the IBM Virtual TPM
 device tree binding documentation
Date: Thu, 29 Sep 2016 14:04:13 +0300
Message-ID: <20160929110413.GA14359@intel.com>
References: <1475051441-23008-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475051441-23008-1-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: devicetree@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, robh@kernel.org, wsa@the-dreams.de, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-i2c@vger.kernel.org, peterhuewe@gmx.de, tpmdd@selhorst.net, hellerda@linux.vnet.ibm.com, ltcgcw@us.ibm.com, cclaudio@linux.vnet.ibm.com, honclo@linux.vnet.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 28, 2016 at 04:30:40AM -0400, Nayna Jain wrote:
> Virtual TPM, which is being used on IBM POWER7+ and POWER8 systems running
> POWERVM, is currently supported by tpm device driver but lacks the
> documentation. This patch adds the missing documentation for the existing
> support.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> ---
> Changelog v2:
> 
> - New Patch
> 
>  .../devicetree/bindings/security/tpm/ibmvtpm.txt   | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
> new file mode 100644
> index 0000000..d89f999
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
> @@ -0,0 +1,41 @@
> +* Device Tree Bindings for IBM Virtual Trusted Platform Module(vtpm)
> +
> +Required properties:
> +
> +- compatible            : property name that conveys the platform architecture
> +                          identifiers, as 'IBM,vtpm'
> +- device_type           : specifies type of virtual device

A generic device tree question. What is the difference between
these fields? Why the I2C one does have 'device_type'?

/Jarkko
