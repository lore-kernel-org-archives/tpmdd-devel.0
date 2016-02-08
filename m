From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [GIT PULL] tpmdd fixes for Linux 4.5
Date: Mon, 8 Feb 2016 22:46:10 +0200
Message-ID: <20160208204610.GA14626@intel.com>
References: <20160119233903.GA12337@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160119233903.GA12337-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

James,

On Wed, Jan 20, 2016 at 01:39:03AM +0200, Jarkko Sakkinen wrote:
> Hi James,
> 
> This pull request contains three small cleanups, a bug fix for policy
> based sealing, a bug fix for attach/detach of the platform device for
> tpm_tis and resource locking for tpm_tis and tpm_crb.

I have 3-4 small scope fixes for the release that have been implemented
after this.

Since it's bee a while since this pull request should I create a new one
and include those or do you want to pull this first?

I could rebase that new pull request to -rc3 to which security/next is
now rebased.

Thanks.

/Jarkko

> /Jarkko
> 
> The following changes since commit 607259e17b37017e9ec0249a8b0a7d8b76b572aa:
> 
>   Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into ra-next (2016-01-10 21:52:17 +1100)
> 
> are available in the git repository at:
> 
>   https://github.com/jsakkine/linux-tpmdd.git tags/tpmdd-next-20160120
> 
> for you to fetch changes up to bb76f9ba498881ed57444fa2a7b5aafd66c207ba:
> 
>   tpm_crb: Use devm_ioremap_resource (2016-01-20 01:28:51 +0200)
> 
> ----------------------------------------------------------------
> tpmdd fixes for Linux 4.5
> 
> ----------------------------------------------------------------
> Jarkko Sakkinen (1):
>       tpm: fix checks for policy digest existence in tpm2_seal_trusted()
> 
> Jason Gunthorpe (7):
>       tpm_crb: Use the common ACPI definition of struct acpi_tpm2
>       tpm_tis: Disable interrupt auto probing on a per-device basis
>       tpm_tis: Do not fall back to a hardcoded address for TPM2
>       tpm_tis: Use devm_ioremap_resource
>       tpm_tis: Clean up the force=1 module parameter
>       tpm_crb: Drop le32_to_cpu(ioread32(..))
>       tpm_crb: Use devm_ioremap_resource
> 
> Jerry Snitselaar (1):
>       tpm: remove unneeded include of actbl2.h
> 
>  drivers/char/tpm/tpm.h      |   7 --
>  drivers/char/tpm/tpm2-cmd.c |  12 +--
>  drivers/char/tpm/tpm_crb.c  | 194 ++++++++++++++++++++-------------
>  drivers/char/tpm/tpm_tis.c  | 255 +++++++++++++++++++++++++-------------------
>  include/keys/trusted-type.h |   2 +-
>  security/keys/trusted.c     |  11 +-
>  6 files changed, 272 insertions(+), 209 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
