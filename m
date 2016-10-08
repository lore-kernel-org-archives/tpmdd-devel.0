From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/2] Documentation: tpm: add the Physical TPM device
 tree binding documentation
Date: Sat, 8 Oct 2016 16:05:22 -0500
Message-ID: <20161008210522.GB22112@rob-hp-laptop>
References: <1475051441-23008-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1475051441-23008-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475051441-23008-2-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: devicetree@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, wsa@the-dreams.de, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-i2c@vger.kernel.org, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, hellerda@linux.vnet.ibm.com, ltcgcw@us.ibm.com, cclaudio@linux.vnet.ibm.com, honclo@linux.vnet.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 28, 2016 at 04:30:41AM -0400, Nayna Jain wrote:
> Newly added support of TPM 2.0 eventlog securityfs pseudo files in tpm
> device driver consumes device tree bindings representing I2C based
> Physical TPM. This patch adds the documentation for corresponding device
> tree bindings of I2C based Physical TPM. These bindings are similar to
> vtpm device tree bindings being used on IBM Power7+ and Power8 Systems
> running PowerVM.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> ---
> Changelog v2:
> 
> - Include review feedbacks.
>   - Move the doc within bindings/security/tpm.
>   - Add example for compatible property in description.
>   - Delete implicit properties like status, label from description.
>   - Redefine linux,sml-base description.
> 
>  .../devicetree/bindings/security/tpm/tpm-i2c.txt     | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> new file mode 100644
> index 0000000..16df8bb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> @@ -0,0 +1,20 @@
> +* Device Tree Bindings for I2C based Trusted Platform Module(TPM)
> +
> +Required properties:
> +
> +- compatible     : 'manufacturer,model', eg. nuvoton,npct650
> +- linux,sml-base : 64-bit base address of the reserved memory allocated for
> +                   the firmware event log
> +- linux,sml-size : size of the memory allocated for the firmware event log
> +
> +Example (for OpenPower Systems with Nuvoton TPM 2.0 on I2C)
> +----------------------------------------------------------
> +
> +tpm@57 {
> +	reg = <0x57>;
> +	label = "tpm";

Not documented, but why? label is really only useful when you have 
multiple items that humans need to identify like ports on ethernet 
switch or LEDs.

> +	compatible = "nuvoton,npct650", "nuvoton,npct601";
> +	linux,sml-base = <0x7f 0xfd450000>;
> +	linux,sml-size = <0x10000>;
> +	status = "okay";
> +};
> -- 
> 2.5.0
> 
