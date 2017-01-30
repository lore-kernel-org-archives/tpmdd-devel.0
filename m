From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 2/2] tpm: enhance TPM 2.0 PCR extend to,
 support multiple banks
Date: Mon, 30 Jan 2017 15:31:21 +0530
Message-ID: <588F0EF1.1090300@linux.vnet.ibm.com>
References: <beaf57a6-67a1-dd26-6e45-243dd46eb3f0@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <beaf57a6-67a1-dd26-6e45-243dd46eb3f0-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 01/26/2017 03:41 AM, Ken Goldman wrote:
>> The current TPM 2.0 device driver extends only the SHA1 PCR bank
>> but the TCG Specification[1] recommends extending all active PCR
>> banks, to prevent malicious users from setting unused PCR banks with
>> fake measurements and quoting them.
>>
>> The existing in-kernel interface(tpm_pcr_extend()) expects only a
>> SHA1 digest.  To extend all active PCR banks with differing
>> digest sizes, the SHA1 digest is padded with trailing 0's as needed.
>>
>> This patch reuses the defined digest sizes from the crypto subsystem,
>> adding a dependency on CRYPTO_HASH_INFO module.
>>
>> [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
>> Platform Firmware Profile for TPM 2.0"
>
> Tested-by: Kenneth Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> I obtained an IMA event log from a Power platform, along with the PCR 10
> value from both the SHA-1 and SHA-256 banks of its Nuvoton TPM 2.0.  I
> independently validated that the event log matches the TPM PCR values.

Thank You Ken !!

Thanks & Regards,
    - Nayna

>
>
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
