From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: implement TPM 2.0 capability to
 get active PCR banks
Date: Sun, 9 Oct 2016 12:05:02 +0300
Message-ID: <20161009090502.GA31891@intel.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475979357-1167-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475979357-1167-2-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 08, 2016 at 10:15:56PM -0400, Nayna Jain wrote:
> As per the TCG 2.0 spec, the extend operation should be done to
> all active PCR banks. However, current TPM 2.0 support doesn't
> have the capability implemented to get active PCR banks.
> 
> This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> retrieve active PCR banks from the TPM.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Why?

> ---
>  drivers/char/tpm/tpm-chip.c |  4 +++
>  drivers/char/tpm/tpm.h      |  8 ++++-
>  drivers/char/tpm/tpm2-cmd.c | 80 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm2.h     | 35 ++++++++++++++++++++
>  4 files changed, 126 insertions(+), 1 deletion(-)

tpm2.h does not exist.

Have you even checked that this applies to the upstream tree?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
