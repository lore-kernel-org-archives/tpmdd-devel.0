From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v9 0/5] tpm: Command duration logging and
 chip-specific override
Date: Mon, 18 Jul 2016 21:07:36 +0300
Message-ID: <20160718180736.GB31463@intel.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
	<1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 09:19:31AM -0700, Ed Swierk wrote:
> v9: Include command duration in existing error messages rather than
> logging an extra debug message. Rebase onto Jarkko's tree.
> 
> v8: Fix v7 goof-up in tpm_getcap().
> 
> v7: Use tpm_getcap() instead of a redundant new function.
> 
> v6: Split tpm_get_cap_prop() out of tpm_get_timeouts(); always return
> error on TPM command failure.
> 
> v5: Use msecs_to_jiffies() instead of * HZ / 1000.
> 
> v4: Rework tpm_get_timeouts() to allow overriding both timeouts and
> durations via a single callback.
> 
> This series
> - improves TPM command error reporting
> - adds optional logging of TPM command durations
> - allows chip-specific override of command durations as well as protocol
>   timeouts
> - overrides ST19NP18 TPM command duration to avoid lockups

For the next version please write something more readable. Describe the
motivation and solution in big picture, why and how. This list does no
good because it just mimics the list of patches.

/Jarkko

> Ed Swierk (5):
>   tpm_tis: Improve reporting of IO errors
>   tpm: Add optional logging of TPM command durations
>   tpm: Clean up reading of timeout and duration capabilities
>   tpm: Allow TPM chip drivers to override reported command durations
>   tpm_tis: Increase ST19NP18 TPM command duration to avoid chip lockup
> 
>  drivers/char/tpm/tpm-interface.c | 219 ++++++++++++++++++++-------------------
>  drivers/char/tpm/tpm_tis_core.c  |  46 ++++----
>  include/linux/tpm.h              |   3 +-
>  3 files changed, 136 insertions(+), 132 deletions(-)
> 
> -- 
> 1.9.1
> 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
