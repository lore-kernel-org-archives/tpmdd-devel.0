From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Use tpm_transmit_cmd() consistently
Date: Wed, 6 Jul 2016 17:21:43 +0300
Message-ID: <20160706142143.GA4442@intel.com>
References: <1466891093-27766-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466891093-27766-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Pending for reviews. These are quite trivial patches.

/Jarkko

On Sun, Jun 26, 2016 at 12:44:45AM +0300, Jarkko Sakkinen wrote:
> These commits update the subsystem consistently to use
> tpm_transmit_cmd() throughout the subsystem the exception being
> tpm_write() where it makes sense to use the raw interface because higher
> level command handling is delegated to user space.
> 
> v2: Added commit that drops externs from all function declarations in
> tpm.h as suggested by Jason Gunthorpe.
> 
> Jarkko Sakkinen (6):
>   tpm: remove unnecessary externs from tpm.h
>   tpm: unify tpm_gen_interrupt()
>   tpm: return error code from tpm_gen_interrupt()
>   tpm: use tpm_transmit_cmd() in tpm2_probe()
>   tpm: rename tpm_pcr_read_dev() to tpm1_pcr_read()
>   tpm: use tpm1_pcr_read() in tpm_do_selftest()
> 
>  drivers/char/tpm/tpm-interface.c | 36 ++++++++++++++++++----------------
>  drivers/char/tpm/tpm-sysfs.c     |  2 +-
>  drivers/char/tpm/tpm.h           | 42 +++++++++++++++++++---------------------
>  drivers/char/tpm/tpm2-cmd.c      | 21 +-------------------
>  drivers/char/tpm/tpm_tis_core.c  |  7 +++----
>  5 files changed, 44 insertions(+), 64 deletions(-)
> 
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
