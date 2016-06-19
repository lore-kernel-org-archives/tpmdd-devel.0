From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Runtime PM for TPM2 CRB chips
Date: Sun, 19 Jun 2016 19:15:31 +0200
Message-ID: <20160619171531.GA25349@intel.com>
References: <1466262628-25530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466262628-25530-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jun 18, 2016 at 05:10:25PM +0200, Jarkko Sakkinen wrote:
> These patches implement support for runtime PM with TPM2 CRB chips such
> as PTT in Skylake.
> 
> This is very naive implementation since the TPM is resumed and supended
> for every transaction thus causing total 40 ms latency for each
> transaction but for the existing use cases this shouldn't be an issue.
> 
> Jarkko Sakkinen (3):
>   tpm_crb: fix crb_req_canceled behavior
>   tpm, tpm_crb: remove wmb()'s
>   tpm, tpm_crb: runtime power management
> 
>  drivers/char/tpm/tpm-interface.c |  3 ++
>  drivers/char/tpm/tpm_crb.c       | 60 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 56 insertions(+), 7 deletions(-)

Reviewing myself:

* I fsckd the description. The latency is whopping 400 ms, not 4 ms.
  Sorry about that. Thus it's better to use autosuspend.
* Callbacks should take tpm_mutex before doing anything.

I guess that tpm_tis could later on also take advantage of this work?

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
