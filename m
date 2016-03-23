From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/3] Remaining fixes for v4.5 (post
	tpmdd-next-20160120)
Date: Wed, 23 Mar 2016 07:11:45 +0200
Message-ID: <20160323051145.GA6776@intel.com>
References: <1458709767-6428-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458709767-6428-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Wed, Mar 23, 2016 at 07:09:24AM +0200, Jarkko Sakkinen wrote:
> Fixes remaining after tpmdd-next-20160120 has been pulled and API change
> so that session object stays intact after a successful unseal operation.

Oops. Please ignore this, did a mistake with git send-email. Sorry about
this.

/Jarkko

> Harald Hoyer (1):
>   tpm_eventlog.c: fix binary_bios_measurements
> 
> Jarkko Sakkinen (2):
>   tpm: fix: keep auth session intact after unseal operation
>   tpm: fix: return rc when devm_add_action() fails
> 
>  drivers/char/tpm/tpm-chip.c     |  7 ++++++-
>  drivers/char/tpm/tpm2-cmd.c     | 10 +++++++---
>  drivers/char/tpm/tpm_eventlog.c | 10 ++++++++--
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> -- 
> 2.7.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
