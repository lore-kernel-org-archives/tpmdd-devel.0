From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Tue, 30 Aug 2016 09:36:31 +0300
Message-ID: <20160830063631.GA5336@intel.com>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532277-21933-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 12:44:37AM -0400, Nayna Jain wrote:
> This is documenting device tree binding for
> I2C based TPM, similar concept which being used
> for virtual TPM on POWER7 and POWER8 systems running PowerVM.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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
> +- label : represents device type
> +- linux,sml-base : base address of the Event Log. It is a physical address.
> +		   sml stands for shared memory log.
> +- linux,sml-size : size of the memory allocated for the Event Log.
> +
> +Optional properties:
> +
> +- status: indicates whether the device is enabled or disabled. "okay" for
> +          enabled and "disabled" for disabled.
> +
> +Example
> +-------
> +
> +tpm@57 {
> +	reg = <0x57>;
> +	label = "tpm";
> +	compatible = "nuvoton,npct650", "nuvoton,npct601";
> +	linux,sml-base = <0x7f 0xfd450000>;
> +	linux,sml-size = <0x10000>;
> +	status = "okay";
> +};

I would rather name the fields event-log-base and event-log-size. They
would be much more readable and obvious names.

Also, enabled should be "enabled", not "okay".

/Jarkko

------------------------------------------------------------------------------
