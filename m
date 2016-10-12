From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: enhance TPM 2.0 PCR extend to
 support multiple banks
Date: Wed, 12 Oct 2016 19:02:55 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F8CFF@hasmsx108.ger.corp.intel.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475979357-1167-3-git-send-email-nayna@linux.vnet.ibm.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F6C75@hasmsx108.ger.corp.intel.com>
	<57FE69D9.4070304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <57FE69D9.4070304-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> 
> 
> On 10/09/2016 11:58 AM, Winkler, Tomas wrote:
> >> Like TPM 1.2, the current device driver for TPM 2.0 supports
> >> extending only to the SHA1 PCR bank. But the TPM 2.0 supports
> >> multiple PCR banks and the specification recommends extending to all
> >> active PCR banks, this patch enhances the existing device driver
> >> support for TPM 2.0 extend function and its in-kernel interface to extend to
> all active PCR banks.
> >>
> >> The existing in-kernel interface expects only a SHA1 digest.
> >> Hence, to extend all active PCR banks with differing digest sizes for
> >> TPM 2.0, the SHA1 digest is padded with trailing 0's as needed.
> >>
> >> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> ---
> >>   drivers/char/tpm/tpm-interface.c | 17 ++++++++--
> >>   drivers/char/tpm/tpm2-cmd.c      | 71 ++++++++++++++++++++++++++-------
> -----
> >> --
> >>   drivers/char/tpm/tpm2.h          | 18 ++++++++++
> >>   3 files changed, 79 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-
> >> interface.c index 7743e8a..5dd5005 100644
> >> --- a/drivers/char/tpm/tpm-interface.c
> >> +++ b/drivers/char/tpm/tpm-interface.c
> >> @@ -7,6 +7,7 @@
> >>    * Dave Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> >>    * Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> >>    * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> + * Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >>    *
> >>    * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> >>    *
> >> @@ -32,6 +33,7 @@
> >>   #include <linux/pm_runtime.h>
> >>
> >>   #include "tpm.h"
> >> +#include "tpm2.h"
> >>   #include "tpm_eventlog.h"
> >>
> >>   #define TPM_MAX_ORDINAL 243
> >> @@ -752,7 +754,7 @@ static const struct tpm_input_header
> >> pcrextend_header = {  int tpm_pcr_extend(u32 chip_num, int pcr_idx,
> >> const u8
> >> *hash)  {
> >>   	struct tpm_cmd_t cmd;
> >> -	int rc;
> >> +	int i, rc;
> >>   	struct tpm_chip *chip;
> >>
> >>   	chip = tpm_chip_find_get(chip_num); @@ -760,7 +762,18 @@ int
> >> tpm_pcr_extend(u32 chip_num, int pcr_idx, const
> >> u8 *hash)
> >>   		return -ENODEV;
> >>
> >>   	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> >> -		rc = tpm2_pcr_extend(chip, pcr_idx, hash);
> >> +		struct tpml_digest_values d_values;
> >> +
> >> +		memset(&d_values, 0, sizeof(d_values));
> >> +
> >> +		for (i = 0; i < chip->no_of_active_banks; i++) {
> >> +			d_values.digests[i].alg_id =
> >> +				chip->active_banks[i];
> >> +			memcpy(d_values.digests[i].digest, hash,
> >> +			       TPM_DIGEST_SIZE);
> >> +			d_values.count++;
> >> +		}
> >
> > This is tpm2 only feature so  I suggest to create a function inside tpm2-chip.c
> instead of  open coding  it here.
> > This will probably also prevent all this code movement.
> 
> Thanks Tomas for reviewing, will look at this.
> And I think you meant inside tpm2-cmd.c ?

Right.
Tomas 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
