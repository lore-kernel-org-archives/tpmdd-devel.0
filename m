From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: enhance TPM 2.0 PCR extend to
 support multiple banks
Date: Sun, 9 Oct 2016 12:06:12 +0300
Message-ID: <20161009090612.GB31891@intel.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475979357-1167-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475979357-1167-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Sat, Oct 08, 2016 at 10:15:57PM -0400, Nayna Jain wrote:
> Like TPM 1.2, the current device driver for TPM 2.0 supports
> extending only to the SHA1 PCR bank. But the TPM 2.0 supports multiple
> PCR banks and the specification recommends extending to all active PCR
> banks, this patch enhances the existing device driver support for
> TPM 2.0 extend function and its in-kernel interface to extend to all
> active PCR banks.
> 
> The existing in-kernel interface expects only a SHA1 digest.
> Hence, to extend all active PCR banks with differing digest sizes
> for TPM 2.0, the SHA1 digest is padded with trailing 0's as needed.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 17 ++++++++--
>  drivers/char/tpm/tpm2-cmd.c      | 71 ++++++++++++++++++++++++++--------------
>  drivers/char/tpm/tpm2.h          | 18 ++++++++++
>  3 files changed, 79 insertions(+), 27 deletions(-)

I'll ignore this commit because:

1. This is not used anywhere.
2. Does not apply to upstream.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
