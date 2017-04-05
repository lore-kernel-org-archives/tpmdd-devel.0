From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] tpm: introduce
 tpm2_pcr_algo_to_crypto() and tpm2_pcr_algo_from_crypto()
Date: Wed, 5 Apr 2017 16:24:51 +0200
Message-ID: <0c6b34bf-66d8-0072-7020-262be2206d02@huawei.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-3-roberto.sassu@huawei.com>
	<20170405121256.jyyj474dux5cb62m@intel.com>
	<96aeb2ef-5b0b-7c10-cbf1-7f51aeb902ae@huawei.com>
	<20170405134316.bnlaqqo2uz5lncau@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170405134316.bnlaqqo2uz5lncau-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 4/5/2017 3:43 PM, Jarkko Sakkinen wrote:
> Which one is needed for IMA? I mean for in-kernel API you should not add
> any extra flexibility. Please implement the patch set with the minimal
> flexibility in mind. Just enough to get IMA uses cases done and explain
> in the commit messages your rationale based on requirements of the IMA.

Currently IMA is using crypto IDs, but if a TPM algorithm
is not supported by the crypto subsystem, its TPM ID could
be used to perform the hash operation directly with the TPM.

I was thinking to send to TPM users crypto IDs. However,
tpm2_pcr_extend() accepts as input a tpm2_digest structure,
which includes a TPM ID. To use crypto IDs, TPM users could
provide concatenated digests in an array of unsigned chars.
But then, tpm_pcr_extend() would have to extract each digest
and place it in a tpm2_digest structure, before calling
tpm2_pcr_extend().

Roberto

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
