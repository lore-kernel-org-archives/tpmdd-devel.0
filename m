From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] Remove the tpm_vendor_specific
	structure
Date: Tue, 29 Mar 2016 17:10:29 +0300
Message-ID: <20160329141029.GB12764@intel.com>
References: <1458975615-8095-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458975615-8095-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Sat, Mar 26, 2016 at 08:00:08AM +0100, Christophe Ricard wrote:
> Hi Jarkko,
> 
> This is the latest steps to cleanup tpm_vendor_specific structure.
> 
> I have also included some few obvious cleanup inside the drivers.
> I have been able to test tpm_tis on a HP Desktop machine.
> 
> In v2 i have added a patch fixing:
> 'tpm: drop 'iobase' from struct tpm_vendor_specific' 691f211398bb93878b727be0c5c523e2371074f5

You give zero information here what you are fixing and why. For the next
version of the patch set just put a remark about fixing PPC64 builds and
include the full patch. I'll drop the current iobase patch from my
master branch.

/Jarkko

> It may be merged with the mention commit.
> 
> Best Regards
> Christophe
> 
> 
> Christophe Ricard (7):
>   tpm/tpm_atmel: drop remaining 'iobase' usage
>   tpm: Remove useless priv field in struct tpm_vendor_specific
>   tpm/tpm_i2c_atmel: simplify patch to get tpm_chip from an i2c_client
>   tpm/tpm_i2c_atmel: Few code style fixes
>   tpm: drop 'irq' from struct tpm_vendor_specific
>   tpm: Move remaining tpm_vendor_specific structure data to tpm_chip
>   tpm: drop 'read_queue' from struct tpm_vendor_specific
> 
>  drivers/char/tpm/st33zp24/i2c.c      |  15 ++-
>  drivers/char/tpm/st33zp24/spi.c      |  15 ++-
>  drivers/char/tpm/st33zp24/st33zp24.c | 113 ++++++++--------------
>  drivers/char/tpm/st33zp24/st33zp24.h |   9 ++
>  drivers/char/tpm/tpm-interface.c     |  52 +++++-----
>  drivers/char/tpm/tpm-sysfs.c         |  20 ++--
>  drivers/char/tpm/tpm.h               |  24 ++---
>  drivers/char/tpm/tpm2-cmd.c          |   2 +-
>  drivers/char/tpm/tpm_atmel.c         |  12 +--
>  drivers/char/tpm/tpm_atmel.h         |   9 +-
>  drivers/char/tpm/tpm_crb.c           |  12 +--
>  drivers/char/tpm/tpm_i2c_atmel.c     |  30 +++---
>  drivers/char/tpm/tpm_i2c_infineon.c  |  47 +++++----
>  drivers/char/tpm/tpm_i2c_nuvoton.c   |  73 ++++++++------
>  drivers/char/tpm/tpm_ibmvtpm.c       |  38 +++-----
>  drivers/char/tpm/tpm_nsc.c           |  48 ++++-----
>  drivers/char/tpm/tpm_tis.c           | 182 ++++++++++++++++++-----------------
>  drivers/char/tpm/xen-tpmfront.c      |  36 +++----
>  18 files changed, 356 insertions(+), 381 deletions(-)
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
