From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [Linux-ima-devel] [Question]: Question on the
 hash algorithm of evm and pcr_extend?
Date: Thu, 23 Feb 2017 10:54:30 -0500
Message-ID: <1487865270.3193.124.camel@linux.vnet.ibm.com>
References: <806EF96D8ABD354A89C18BBED3F86165B8B0D2CC@NKGEML515-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <806EF96D8ABD354A89C18BBED3F86165B8B0D2CC-DDyGIOodwTO05WiQPbXitQK1hpo4iccwjNknBlVQO8k@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Likun (Hw)" <hw.likun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "(tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org)" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-02-23 at 09:36 +0000, Likun (Hw) wrote:
> Hi,
> 
> *         Is there any plan to support other evm_hmac algorithms (like
> we done on  ima file data hash algorithm), the sha2 or other recent
> algorithms are more hardened than sha1 after all.

The EVM hmac values are system local, so adding support for other hash
algorithms  shouldn't be a problem.  Similarly adding signature support
larger hash algorithms should be fine.

Patches are welcome to add this support.

> *         We have supported arbitrary hash algorithms for ima file
> data measurement  since commit
> e7a2ad7eb6f48ad80c70a22dd8167fb34b409466, but the ima template hash
> algorithm is still sha1 due to the tpm1.2 pcr limitation.
> But as we all know ,the tpm2 has supported sha2/sm3 and other
> algorithms , is there any approach to use TPM2.0 better ? For
> example , could we use sha2 as default digest algorithm, and when we
> meet tpm1.2, we truncate the digest from 32 to 20 bytes ?

The two patches that Nayna Jain just upstreamed determine the active PCR
banks and extend those banks with zero padded SHA1 hash into the
multiple TPM banks.

a06c59d417fb tpm: enhance TPM 2.0 PCR extend to support multiple banks
104e5f664d3a tpm: implement TPM 2.0 capability to get active PCR banks

These patches were a stop gap measure until support is added for a "hash
agile" IMA measurement format.  It would be straight forward to replace
the TPM hash algorithm size used in the IMA measurement list with
something that is configurable(eg. Kconfig option), but that puts the
burden on the attestation servers to determine the hash size being used.

A better solution would be to add support for including multiple hashes
in the IMA measurement list.  Whether we will ever support multiple
hashes in the measurement list is irrelevant, but it provides the needed
flexibility.

Mimi


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
