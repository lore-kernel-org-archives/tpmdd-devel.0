From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] TPM2.0: TPM Device Tree
 Documentation
Date: Wed, 10 Aug 2016 14:28:40 +0300
Message-ID: <20160810112816.GE13929@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470771295-15680-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 03:34:54PM -0400, Nayna Jain wrote:
> Added device tree binding documentation for I2C base TPM.

Where is this binding defined originally? Is it standardized?

/Jarkko

> Changelog v2:
>         * Added documentation in v2.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-tpm.txt | 31 +++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-tpm.txt b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> new file mode 100644
> index 0000000..1df05cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> @@ -0,0 +1,31 @@
> +Device Tree Bindings for I2C based Trusted Platform Module(TPM)
> +---------------------------------------------------------------
> +
> +This node describes a TPM device connected to Processor on i2c bus.
> +
> +Required properties:
> +
> +- compatible : 'manufacturer,model'
> +- label : "tpm" indicates master TPM; "tpm-backup" indicates backup TPM.
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
> +	phandle = <0x10000017>;
> +	linux,phandle = <0x10000017>;
> +};
> -- 
> 2.5.0
> 
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity 
> planning reports. http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
