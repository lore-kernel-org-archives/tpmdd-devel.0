From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] Documentation: tpm: Adds the TPM device tree node
 documentation
Date: Fri, 2 Sep 2016 09:51:21 -0500
Message-ID: <20160902145121.GA9636@rob-hp-laptop>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, devicetree@vger.kernel.org, wsa@the-dreams.de, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-i2c@vger.kernel.org, hellerda@linux.vnet.ibm.com, ltcgcw@us.ibm.com, gcwilson@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 12:44:37AM -0400, Nayna Jain wrote:
> This is documenting device tree binding for
> I2C based TPM, similar concept which being used
> for virtual TPM on POWER7 and POWER8 systems running PowerVM.
> 
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-tpm.txt | 29 +++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-tpm.txt b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> new file mode 100644
> index 0000000..8fdee14
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> @@ -0,0 +1,29 @@
> +Device Tree Bindings for I2C based Trusted Platform Module(TPM)
> +---------------------------------------------------------------
> +
> +This node describes a TPM device connected to Processor on i2c bus.
> +
> +Required properties:
> +
> +- compatible : 'manufacturer,model'

Needs specific compatible strings like your example has.

> +- label : represents device type

Why do you need this? label is human readable things like connectors on 
boards.

> +- linux,sml-base : base address of the Event Log. It is a physical address.
> +		   sml stands for shared memory log.

How is it a physical address on an i2c device? Why 2 cells (which needs 
to be documented also)?

Just 'log' would be more descriptive than sml.

> +- linux,sml-size : size of the memory allocated for the Event Log.
> +
> +Optional properties:
> +
> +- status: indicates whether the device is enabled or disabled. "okay" for
> +          enabled and "disabled" for disabled.

status is always valid, so you don't need to document it.
