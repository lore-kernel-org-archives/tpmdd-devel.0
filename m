From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] tpm: introduce
	tpm_extend_pcr_digests()
Date: Mon, 10 Apr 2017 13:46:40 +0200
Message-ID: <5be4713f-d34b-f73f-15a4-7a215aeb7ee8@huawei.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-5-roberto.sassu@huawei.com>
	<20170405121416.2rly5pizs2hll56k@intel.com>
	<259b67e8-216b-ad91-52c3-c4b39a8f3d1c@huawei.com>
	<88284005-3a53-1b37-e1f2-bfa88987c989@huawei.com>
	<e6444fe7-5726-c763-0fd5-93b1c3ec47f6@huawei.com>
	<20170407193156.thwubykqqleaszrt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170407193156.thwubykqqleaszrt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 4/7/2017 9:31 PM, Jarkko Sakkinen wrote:
>> would you have any objection if the new functions work
>> regardless of the TPM version?
>
> Yes, you should not add multiple functions that do the same thing
> essentially. Please rework tpm_pcr_extend instead.

This means that callers of tpm_pcr_extend() (pcrlock()
in security/keys/trusted.c) should be modified too,
as the parameters will change.

Also, tpm2_algorithms and tpm2_digest, the new arguments of
tpm_pcr_extend(), should be renamed to tpm_*, since
that function will be used regardless of the TPM version.

Another problem is how to handle the general case when
not all digests for PCR banks are provided.

tpm_pcr_extend() pads the provided SHA1 digest to extend
remaining banks. If multiple digests can be passed to this
function, the digest to be used to extend remaining banks
would depend on the input passed by the caller. The general
rule could be that the first digest is used in all cases.

To avoid confusion, I wanted to introduce a new function
for providing multiple digests. If the caller does not provide
a digest for each bank, the function returns an error.


> And while you are doing it, please also rework it to use tpm_buf
> for everything.

tpm_buf_init() should be modified, to be used for TPM 1.2 commands.
tag and ordinal should be written to the buffer in little endian.

Roberto

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
