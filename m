From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] tpm: enhance TPM 2.0 extend
 function to support multiple PCR banks
Date: Tue, 3 Jan 2017 00:15:50 +0200
Message-ID: <20170102221550.pck4fwir77zss6lz@intel.com>
References: <1483124550-9529-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483124550-9529-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 30, 2016 at 02:02:28PM -0500, Nayna Jain wrote:
> IMA extends its hash measurements in the TPM PCRs, based on policy.
> The existing in-kernel TPM extend function extends only the SHA1
> PCR bank. TPM 2.0 defines multiple PCR banks, to support different
> hash algorithms. The TCG TPM 2.0 Specification[1] recommends
> extending all active PCR banks to prevent malicious users from
> setting unused PCR banks with fake measurements and quoting them.
> This patch set adds support for extending all active PCR banks,
> as recommended.
> 
> The first patch implements the TPM 2.0 capability to retrieve
> the list of active PCR banks.
> 
> The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
> interface to support extending multiple PCR banks. The existing
> tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
> extend all active PCR banks with differing digest sizes for TPM 2.0,
> the SHA1 digest is padded with 0's as needed.
> 
> This approach is taken to maintain backwards compatibility for IMA
> in order to continue working with both TPM 1.2 and TPM 2.0 without
> any changes and still comply with TCG TPM 2.0 Specification[1].

What is the plan to improve IMA so that it can use better hash
algorithms? For me this zero padding sounds like a hack.

> [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
> Platform Firmware Profile for TPM 2.0"
> 
> Changelog v2:
> 
> - Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
>   - defined structs definition in tpm2-cmd.c.
>   - no_of_active_banks field is removed. Instead, constant
>   TPM2_MAX_PCR_BANKS is defined.
>   - renamed tpm2_get_active_pcr_banks() to tpm2_get_pcr_allocation()
>   - removed generic function tpm2_get_capability().
> 
> - Patch "tpm: enchance TPM 2.0 PCR extend to support multiple banks"
>  - Removed tpm2.h, and defined structs common for extend and event log
>   in tpm_eventlog.h
>  - uses tpm_buf in tpm2_pcr_extend().
> 
> Nayna Jain (2):
>   tpm: implement TPM 2.0 capability to get active PCR banks
>   tpm: enhance TPM 2.0 PCR extend to support multiple banks
> 
>  drivers/char/tpm/tpm-interface.c |  16 ++++-
>  drivers/char/tpm/tpm.h           |   8 ++-
>  drivers/char/tpm/tpm2-cmd.c      | 146 +++++++++++++++++++++++++++++++--------
>  drivers/char/tpm/tpm_eventlog.h  |  15 ++++
>  4 files changed, 153 insertions(+), 32 deletions(-)
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
