From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 00/12] Few minnor fixes,
 rework of tpm_tis to support tcg spi and i2c.
Date: Mon, 21 Mar 2016 13:13:39 +0200
Message-ID: <20160321111339.GA11651@intel.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458502483-16887-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 20, 2016 at 08:34:31PM +0100, Christophe Ricard wrote:
> Hi Jarkko,
> 
> Please find in this serie some few minnor fixes as well as some more work around the
> tpm_tis driver.
> 
> This work is based on Peter Huewe's proposal in October 30th 2015:
> https://patchwork.ozlabs.org/patch/538179/
> 
> I have tried to keep Peter's credits on related patches.
> 
> The idea is to have one main tpm_tis_core which would keep a common tpm_tis logic for
> all physical layers(i2c, spi, legacy/lpc).
> This tpm_tis_core can be reused by other drivers (such as st33zp24...) and would
> potentially easy the maintenance.
> 
> It offers support for LPC (tpm_tis), SPI (tpm_tis_spi) and I2C (tpm_tis_i2c) following
> ongoing or available TCG specifications
> 
> SPI layer is supporting wait state/Flow Control as describe in the TCG PTP specification
> (chapter 6.4.5 Flow Control).
> 
> I2C layer is following TCG on going and almost finalized specification.
> 
> Physical layer i2c and spi are tested using STMicro TPM's against Minnowboard, RaspberryPi
> and Beagleboard xM in both polling and interrupt mode.
> 
> For now, i haven't been able to test the LPC/legacy layer but assume it should work.
> 
> Any comment welcome :).

I still have a couple of patches to review and test for vTPM.
After that I can look into this.

/Jarkko


> Best Regards
> Christophe
> 
> Christophe Ricard (12):
>   tpm/st33zp24/i2c: Drop two useless checks in ACPI probe path
>   tpm/st33zp24/spi: Drop two useless checks in ACPI probe path
>   tpm: Add include guards in tpm.h
>   tpm/st33zp24: Remove unneeded tpm_reg in get_burstcount
>   tpm: Add tpm_set_vendordata and tpm_get_vendordata
>   devicetree: Add infineon to vendor-prefix.txt
>   devicetree: Add Trusted Computing Group to vendor-prefix.txt
>   tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant
>     phy
>   tpm/tpm_tis: Rework interrupt management for phy compatibility
>   tpm/tpm_tis_spi: Add support for spi phy
>   tpm: Add check_data handle to tpm_class_ops in order to check data
>     integrity
>   tpm/tpm_tis_i2c: Add support for i2c phy
> 
>  .../bindings/security/tpm/tpm_tis_i2c.txt          |  30 +
>  .../bindings/security/tpm/tpm_tis_spi.txt          |  28 +
>  .../devicetree/bindings/vendor-prefixes.txt        |   2 +
>  drivers/char/tpm/Kconfig                           |  24 +-
>  drivers/char/tpm/Makefile                          |   4 +-
>  drivers/char/tpm/st33zp24/i2c.c                    |  13 +-
>  drivers/char/tpm/st33zp24/spi.c                    |  13 +-
>  drivers/char/tpm/st33zp24/st33zp24.c               |  36 +-
>  drivers/char/tpm/tpm-interface.c                   |  11 +-
>  drivers/char/tpm/tpm.h                             |  20 +-
>  drivers/char/tpm/tpm_ibmvtpm.c                     |   8 +-
>  drivers/char/tpm/tpm_tis.c                         | 803 ++-------------------
>  drivers/char/tpm/tpm_tis_core.c                    | 763 ++++++++++++++++++++
>  drivers/char/tpm/tpm_tis_core.h                    | 166 +++++
>  drivers/char/tpm/tpm_tis_i2c.c                     | 499 +++++++++++++
>  drivers/char/tpm/tpm_tis_spi.c                     | 279 +++++++
>  drivers/char/tpm/xen-tpmfront.c                    |  14 +-
>  include/linux/tpm.h                                |   5 +
>  18 files changed, 1908 insertions(+), 810 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_i2c.txt
>  create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_spi.txt
>  create mode 100644 drivers/char/tpm/tpm_tis_core.c
>  create mode 100644 drivers/char/tpm/tpm_tis_core.h
>  create mode 100644 drivers/char/tpm/tpm_tis_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_tis_spi.c
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
