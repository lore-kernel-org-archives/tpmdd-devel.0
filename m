From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/2] Documentation: tpm: add the Physical TPM device
 tree binding documentation
Date: Sun, 30 Oct 2016 23:02:45 -0500
Message-ID: <20161031040245.cwnt4kelrm7liaga@rob-hp-laptop>
References: <1477473705-12746-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1477473705-12746-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477473705-12746-2-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: devicetree@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, wsa@the-dreams.de, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-i2c@vger.kernel.org, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, hellerda@linux.vnet.ibm.com, ltcgcw@us.ibm.com, cclaudio@linux.vnet.ibm.com, honclo@linux.vnet.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 26, 2016 at 05:21:45AM -0400, Nayna Jain wrote:
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
> Changelog v3:
>  - Added documentation for "label" property.
> 
> Changelog v2:
> 
> - Include review feedbacks.
>   - Move the doc within bindings/security/tpm.
>   - Add example for compatible property in description.
>   - Delete implicit properties like status, label from description.
>   - Redefine linux,sml-base description.
> 
>  .../devicetree/bindings/security/tpm/tpm-i2c.txt    | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt

Acked-by: Rob Herring <robh@kernel.org>
