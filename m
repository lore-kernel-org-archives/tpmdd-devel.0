From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Extend the vTPM proxy driver to
 pass locality to emulator
Date: Sat, 29 Apr 2017 14:58:09 +0300
Message-ID: <20170429115809.udkbtxnu3xksodiu@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493384538-27883-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

I will get into this with detail after 4.12-rc1.

/Jarkko

On Fri, Apr 28, 2017 at 09:02:15AM -0400, Stefan Berger wrote:
> The purpose of this series of patches is to enable the passing of the locality
> a command is executing in to a TPM emulator. To enable this we introduce a new
> flag for the device creation ioctl that requests that the locality be prepended
> to every command. For applications to check which flags the driver supports, we
> add a new ioctl that returns a bitmask of supported flags.
> 
> v1->v2:
>   - fixed return value from function in patch 3/3
> 
> 
> Stefan Berger (3):
>   tpm: vtpm_proxy: Add ioctl to get supported flags
>   tpm: vtpm_proxy: Implement request_locality
>   tpm: vtpm_proxy: Add ioctl to request locality prepended to command
> 
>  drivers/char/tpm/tpm_vtpm_proxy.c | 53 +++++++++++++++++++++++++++++++++++----
>  include/uapi/linux/vtpm_proxy.h   | 15 ++++++++++-
>  2 files changed, 62 insertions(+), 6 deletions(-)
> 
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
