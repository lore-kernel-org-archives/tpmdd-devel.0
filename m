From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 00/12] tpm/st33zp24: Few code style and
 sanity fixes + acpi device probing support
Date: Thu, 25 Feb 2016 09:51:31 +0200
Message-ID: <20160225075131.GA23077@intel.com>
References: <1456262751-12096-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456262751-12096-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Tue, Feb 23, 2016 at 10:25:39PM +0100, Christophe Ricard wrote:
> Hi Jarkko,
> 
> kbuild robot feedbacks few issues with patch 10 & 12. I am sending back the whole series again.
> 
> - a set of code style or sanity cleanup
> - acpi device probing support for i2c and spi phys.
> 
> In v2, i have:
> - Added Jarkko review
> - Fixed a warning on patch 12
> 
> In v3, i have fixed few errors reported by kbuild robot on patch 10 & 12.
> Those are coming from mistakes on side. Sorry :(.
> I have rebased this work using patches already present in your master branch.
> 
> This patch serie applies on top of:
> tpm_tis: fix build warning with tpm_tis_resume 6386544ad7bceb3d0248b85da29d4d99eebe9161

NP, I reapplied patches 10-12 from this series.

/Jarkko


> Best Regards
> Christophe
> 
> Christophe Ricard (12):
>   tpm/st33zp24/spi: Remove nbr_dummy_bytes variable usage
>   tpm/st33zp24/spi: Use functions name with st33zp24_spi_ prefix
>   tpm/st33zp24/spi: Remove useless use of memcpy.
>   tpm/st33zp24/spi: Remove field spi_xfer from st33zp24_spi_phy
>     structure
>   tpm/st33zp24: Remove unneeded CONFIG_OF switches
>   tpm/st33zp24: Auto-select core module
>   tpm/st33zp24/spi: Improve st33zp24_spi_evaluate_latency
>   tpm/st33zp24: Extend Copyright headers
>   tpm/st33zp24: Add support for acpi probing for i2c device.
>   tpm: st33zp24: Add support for acpi probing for spi device.
>   tpm/st33zp24/i2c: Change xxx_request_resources header
>   tpm/st33zp24/spi: Change xxx_request_resources header
> 
>  drivers/char/tpm/st33zp24/Kconfig      |  11 +-
>  drivers/char/tpm/st33zp24/i2c.c        |  76 ++++++++++---
>  drivers/char/tpm/st33zp24/spi.c        | 190 ++++++++++++++++++++-------------
>  drivers/char/tpm/st33zp24/st33zp24.c   |   2 +-
>  drivers/char/tpm/st33zp24/st33zp24.h   |   2 +-
>  include/linux/platform_data/st33zp24.h |   2 +-
>  6 files changed, 182 insertions(+), 101 deletions(-)
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
