From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v11 0/4] Multi-instance vTPM proxy driver
Date: Fri, 22 Apr 2016 19:54:27 +0300
Message-ID: <20160422165427.GA24090@intel.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461000376-2888-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 18, 2016 at 01:26:12PM -0400, Stefan Berger wrote:
> The following series of patches implements a multi-instance vTPM 
> proxy driver that can dynamically create TPM 'server' and client device
> pairs.
> 
> Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> and a server side file descriptor is created. The file descriptor must
> be passed to a TPM emulator. The device driver will initialize the
> emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> the command durations from the device in case of a TPM 1.2. The choice
> of emulated TPM device (1.2 or 2) must be provided with a flag in
> the ioctl.
> 
> The patches are based on the tip of a recent checkout of Jarkko's tree
> (master branch).

I've applied this series to my master branch. These patches have been
baking long enough in my opinion that they could be merged to next and
therefore find their way into Linux 4.7

Stefan, I would still require your Tested-by for the first patch before
merging because it is not as mature as other patches are.

/Jarkko

>    Stefan
> 
> v10->v11:
>  - patch 3: merge of v10 patches 3 and 4
>  - patch 3: removed unnecessary NULL pointer checks
>  - Added Jason's Reviewed-by's
> 
> v9->v10:
>  - add new patch 1 with sysfs related rework; reworked patch 2 as a consequence
>  - patch 3: fixed ioctl from using _IOW to using _IOWR (reinstall headers
>    and rebuild test tools)
>  - patch 3: do not use priv field anymore but uses dev_set_drvdata /
>    dev_get_drvdata instead now
> 
> v8->v9:
>  - move constant from public header into tpm_vtpm_proxy.c
>  - Replaced VTPM_PROXY_MAGIC in ioctl definition with its value (0xa1)
>  - Check for the STATE_OPEN_FLAG in wait_event_interruptable and after
>    returning from it
> 
> v7->v8:
>  - minor tweaks on the documentation
>  - Reordered function calls in the VTPM proxy driver's server side release
>    function so that a client holding the 'ops' lock releases it before the
>    driver tries to grab the lock when unregistering the device.
> 
> v6->v7:
>  - Adjusted name of driver to tpm_vtpm_proxy from tpm_vtpm. Adjust function
>    names, names of structures, and names of constants.
>  - Adjusted IOCTL to use magic 0xa1 rather than the completely used 0xa0.
>  - Extended driver documentation and added documentation of ioctl.
>  - Moved test program to own project (dropped patch 11).
> 
> v5->v6:
>  - Adapted errno's for unsupported flags and ioctls following Jason's
>    comments
> 
> v4->v5:
>  - Introduced different error codes for unsupported flags and ioctls
>  - Added documentation patch
> 
> 
> Jason Gunthorpe (1):
>   tpm: Remove all uses of drvdata from the TPM Core
> 
> Stefan Berger (3):
>   tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
>   tpm: Proxy driver for supporting multiple emulated TPMs
>   tpm: Add documentation for the tpm_vtpm_proxy device driver
> 
>  Documentation/ioctl/ioctl-number.txt |   1 +
>  Documentation/tpm/tpm_vtpm_proxy.txt |  71 ++++
>  drivers/char/tpm/Kconfig             |  10 +
>  drivers/char/tpm/Makefile            |   1 +
>  drivers/char/tpm/tpm-chip.c          |  76 +++--
>  drivers/char/tpm/tpm-interface.c     |   7 +-
>  drivers/char/tpm/tpm-sysfs.c         |  61 ++--
>  drivers/char/tpm/tpm.h               |  11 +-
>  drivers/char/tpm/tpm_vtpm_proxy.c    | 644 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild            |   1 +
>  include/uapi/linux/vtpm_proxy.h      |  36 ++
>  11 files changed, 852 insertions(+), 67 deletions(-)
>  create mode 100644 Documentation/tpm/tpm_vtpm_proxy.txt
>  create mode 100644 drivers/char/tpm/tpm_vtpm_proxy.c
>  create mode 100644 include/uapi/linux/vtpm_proxy.h
> 
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
