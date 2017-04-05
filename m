From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] tpm: introduce
	tpm_extend_pcr_digests()
Date: Wed, 5 Apr 2017 15:50:08 +0200
Message-ID: <259b67e8-216b-ad91-52c3-c4b39a8f3d1c@huawei.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-5-roberto.sassu@huawei.com>
	<20170405121416.2rly5pizs2hll56k@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170405121416.2rly5pizs2hll56k-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 4/5/2017 2:14 PM, Jarkko Sakkinen wrote:
> On Wed, Mar 29, 2017 at 12:24:52PM +0200, Roberto Sassu wrote:
>> Allow TPM users to provide a digest for each PCR bank,
>> for the extend operation.
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Not used for anything. Thus NAK.

As I mentioned earlier, it is used in this patch:

https://sourceforge.net/p/linux-ima/mailman/message/35757195/


tpm_pcr_algorithms() and tpm2_pcr_algo_to_crypto() are used
in this patch:

https://sourceforge.net/p/linux-ima/mailman/message/35757194/


tpm2_pcr_algo_from_crypto() is used here:

https://sourceforge.net/p/tpmdd/mailman/message/35756304/

Roberto

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
