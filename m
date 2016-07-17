From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: devicetree: document properties
	for cr50
Date: Sun, 17 Jul 2016 08:28:01 -0500
Message-ID: <20160717132801.GA5527@rob-hp-laptop>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
	<1468549218-19215-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468549218-19215-2-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: =?iso-8859-1?B?oKCgTWFyaw==?= Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, =?iso-8859-1?B?oKCgUGF3ZWw=?= Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, =?iso-8859-1?B?oKCgSWFu?= Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, =?iso-8859-1?B?oKCgS3VtYXI=?= Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 07:20:17PM -0700, Andrey Pronin wrote:
> Add TPM2.0-compatible interface to Cr50. Document its properties
> in devicetree.
> 
> Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
>  .../devicetree/bindings/security/tpm/cr50_spi.txt  | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> 
> diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> new file mode 100644
> index 0000000..1b05e51
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> @@ -0,0 +1,30 @@
> +* Cr50 Chip on SPI.
> +
> +TCG PTP FIFO Compliant Interface to Cr50 on SPI bus.
> +
> +Required properties:
> +- compatible: Should be "google,cr50_spi".

I agree with dropping '_spi'. The interface is defined by the parent 
device.

> +- spi-max-frequency: Maximum SPI frequency.
> +
> +Optional properties:
> +- access-delay-msec: Required delay between subsequent transactions on SPI.

There may be a standard property for this...

> +- sleep-delay-msec: Time after the last SPI activity, after which the chip
> +  may go to sleep.
> +- wake-start-delay-msec: Time after initiating wake up before the chip is
> +  ready to accept commands over SPI.

Use the standard unit '-ms' instead of '-msec'.

Do these times really vary much and need to be in DT?

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
