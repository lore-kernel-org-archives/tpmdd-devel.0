From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 0/6] Remove the tpm_vendor_specific
	structure
Date: Fri, 1 Apr 2016 15:05:14 +0300
Message-ID: <20160401120514.GA7858@intel.com>
References: <1459457820-30542-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459457820-30542-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Thu, Mar 31, 2016 at 10:56:54PM +0200, Christophe Ricard wrote:
> Hi Jarkko,
> 
> After our discussion, please find an updated v4 serie allowing to
> completely remove reference to the tpm_vendor_specific structure.
> 
> I have been able to test tpm_tis on a HP8200 Desktop machine.

I pushed these to my master branch so that they get easily testing
coverage.

/Jarkko

> 
> It applies cleanly on top of:
> tpm: cleanup tpm_tis_remove()
> 72e454274bc1a05d561ae5f6959c15a26604a25d
> 
> In v4:
> - Added Jarkko's Review in patch 2, 3, 4, 6
> - Fixed checkpatch Warning in patch 1
> macros should not use a trailing semicolon
> #165: FILE: drivers/char/tpm/tpm_atmel.h:41:
> +#define atmel_getb(priv, offset) readb(priv->iobase + offset);'
> Note: this warning is not directly linked with patch one.
> It was mention in v3 cover-letter.
> - Reduced patch 5 commit message and moved each timeout_X to a new line/declaration.
> 
> In v3:
> - Merged 'tpm/tpm_atmel: drop remaining 'iobase' usage' from v2 and
> 'tpm: drop 'iobase' from struct tpm_vendor_specific' sent in v1
> - Move patch tpm: Remove useless priv field in struct tpm_vendor_specific
> at the end of the serie,
> - Dropped codestyle/cleanup patches. May be send later...
> (e.g: tpm/tpm_i2c_atmel: simplify patch to get tpm_chip from an i2c_client,
> tpm/tpm_i2c_atmel: Few code style fixes)
> - In patch 'tpm: drop 'irq' from struct tpm_vendor_specific', Renamed
> TPM_CHIP_FLAG_USES_IRQ to TPM_CHIP_FLAG_IRQ
> - Added patch 'tpm: drop 'locality' from struct tpm_vendor_specific'.
> 
> v2 serie was dropped.
> 
> Best Regards
> Christophe
> 
> Christophe Ricard (6):
>   tpm: drop 'iobase' from struct tpm_vendor_specific
>   tpm: drop 'irq' from struct tpm_vendor_specific
>   tpm: drop 'read_queue' from struct tpm_vendor_specific
>   tpm: drop 'locality' from struct tpm_vendor_specific
>   tpm: Move tpm_vendor_specific data related with PTP specification to
>     tpm_chip
>   tpm: Remove useless priv field in struct tpm_vendor_specific
> 
>  drivers/char/tpm/st33zp24/i2c.c      |  15 ++-
>  drivers/char/tpm/st33zp24/spi.c      |  15 ++-
>  drivers/char/tpm/st33zp24/st33zp24.c | 113 +++++++-----------
>  drivers/char/tpm/st33zp24/st33zp24.h |  12 ++
>  drivers/char/tpm/tpm-interface.c     |  52 ++++----
>  drivers/char/tpm/tpm-sysfs.c         |  20 ++--
>  drivers/char/tpm/tpm.h               |  28 ++---
>  drivers/char/tpm/tpm2-cmd.c          |   2 +-
>  drivers/char/tpm/tpm_atmel.c         |  32 +++--
>  drivers/char/tpm/tpm_atmel.h         |  10 +-
>  drivers/char/tpm/tpm_crb.c           |  12 +-
>  drivers/char/tpm/tpm_i2c_atmel.c     |  23 ++--
>  drivers/char/tpm/tpm_i2c_infineon.c  |  48 ++++----
>  drivers/char/tpm/tpm_i2c_nuvoton.c   |  73 +++++++-----
>  drivers/char/tpm/tpm_ibmvtpm.c       |  38 ++----
>  drivers/char/tpm/tpm_nsc.c           |  48 ++++----
>  drivers/char/tpm/tpm_tis.c           | 225 +++++++++++++++++++----------------
>  drivers/char/tpm/xen-tpmfront.c      |  36 +++---
>  18 files changed, 402 insertions(+), 400 deletions(-)
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
