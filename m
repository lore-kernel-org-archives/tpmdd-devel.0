From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 2/3] TPM2.0: TPM Device Tree
 Documentation
Date: Tue, 9 Aug 2016 16:12:39 -0600
Message-ID: <20160809221239.GB5535@obsidianresearch.com>
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

You need to review

 Documentation/devicetree/bindings/submitting-patches.txt

And be sure to follow all the requirements, including CC'ing the
right maintainers

Also explain that this is a documenting a historical practice that IBM
has used in systems  X Y Z.

> Changelog v2:
>         * Added documentation in v2.

Do not include these lines in commit messages, put them after the
diff stat.

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

 What are these?

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
