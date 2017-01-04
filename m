From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 2/2] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Wed, 4 Jan 2017 14:08:06 +0530
Message-ID: <586CB46E.8050207@linux.vnet.ibm.com>
References: <1481434533-3453-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1481434533-3453-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20170102221148.gy3mlubrgs4gm6ey@intel.com>
	<586B5526.9090703@linux.vnet.ibm.com>
	<20170103133309.lt5k4c37rjq5vcbq@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170103133309.lt5k4c37rjq5vcbq-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 01/03/2017 07:03 PM, Jarkko Sakkinen wrote:
> On Tue, Jan 03, 2017 at 01:09:18PM +0530, Nayna wrote:
>>
>>
>> On 01/03/2017 03:42 AM, Jarkko Sakkinen wrote:
>>> On Sun, Dec 11, 2016 at 12:35:33AM -0500, Nayna Jain wrote:
>>>> Unlike the device driver support for TPM 1.2, the TPM 2.0 does
>>>> not support the securityfs pseudo files for displaying the
>>>> firmware event log.
>>>>
>>>> This patch enables support for providing the TPM 2.0 event log in
>>>> binary form. TPM 2.0 event log supports a crypto agile format that
>>>> records multiple digests, which is different from TPM 1.2. This
>>>> patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
>>>> event log parser which understand the TPM 2.0 crypto agile format.
>>>>
>>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>> There is something fundamentally wrong in this commit.
>>>
>>> You must not allow this feature unless CONFIG_OF is set. It is the only
>>> interface where the supply path of the event log is well defined on
>>> platforms that include a TPM 2.0 chip.
>>
>> As per current implementation, if ACPI with TPM 2.0 doesn't support event
>> log, tpm_read_log_acpi() is expected to return rc and tpm_bios_log_setup
>> will not create securityfs. This is inline with our design for TPM 1.2 event
>> log.
>
> At minimum you must have a check for TPM_CHIP_FLAG_TPM2 in the beginning
> of tpm_read_log_acpi. It is wrong to even try to open TCPA in this case.

Sure, will add this check and return -ENODEV if check passes.

Thanks & Regards,
     - Nayna

>
> /Jarkko
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
