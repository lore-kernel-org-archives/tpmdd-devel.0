From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: (no subject)
Date: Wed, 10 Aug 2016 14:39:38 +0300
Message-ID: <20160810113938.GG13929@intel.com>
References: <1DC01DCD0F70AE4284AE3A5E8C726E2240106236@Ex2010.q-core.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1DC01DCD0F70AE4284AE3A5E8C726E2240106236-6dhP19T7b9reAA7jXO2vED4kX+cae0hd@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alex Gershgorin <Alex.Gershgorin-z19BhFikLL4AvxtiuMwx3w@public.gmane.org>
Cc: "christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 08:34:20AM +0000, Alex Gershgorin wrote:
>    Hi everyone,
> 
>    Our company use Atmel TPM AT97SC3205 - SPI interface.
>    Accordingly to datasheests it's compliant to Trusted Computing Group (TCG)
>    Trusted Platform Module TPM) Version 1.2 Specification. Compliant with TCG
>    PC Client-Specific TPM Interface Specification (TIS Version 1.3).
>    On my target board I'm running Kernel from
>    git://git.infradead.org/users/jjs/linux-tpmdd.git   next head.
>    I have made some additional changes on my Device Tree.


Are you sure that it uses SPI hardware protocol and not TCG MMIO?
On PC the tranport could be LPC or SPI but the interface is TCG
one.

/Jarkko


>    spi1: spi@fc000000 {
>                    pinctrl-names = "default";
>                    pinctrl-0 = <&pinctrl_spi1_default>;
>                    status = "okay";
> 
>                    tpm_tis@0 {
>                                compatible = "tcg,tpm_tis-spi";
>                        reg = <0>;
>                                spi-max-frequency = <10000000>;
>                        };
>                };
> 
>    This is part of my kernel boot messages:
>    atmel_spi fc000000.spi: version: 0x311
>    atmel_spi fc000000.spi: Using dma0chan2 (tx) and dma0chan3 (rx) for DMA
>    transfers
>    atmel_spi fc000000.spi: Using FIFO (16 data)
>    atmel_spi fc000000.spi: Atmel SPI Controller at 0xfc000000 (irq 36)
>    tpm tpm0: tpm_transmit: tpm_send: error -5
>    tpm_tis_spi: probe of spi32765.0 failed with error -5
> 
>    I verified with an oscilloscope that all SPI bus signals are in order.
> 
>    Following the above kernel boot messages - my question is :
>        Can I use tpm_tis_spi device driver for AT97SC3205 device ?
> 
>    Please advise and help with any directions.
> 
>    Thanks in advance,
>    Alex Gershgorin

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
