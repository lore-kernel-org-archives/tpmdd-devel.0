From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5] tpm: Check size of response before
	accessing data
Date: Mon, 16 Jan 2017 10:38:42 -0500
Message-ID: <f607b26c-eaf5-a1b0-ad8a-3191e1e74f5b@linux.vnet.ibm.com>
References: <1484361394-13581-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170116132409.i2y7ipchsohqfqxz@intel.com>
	<20170116132512.zyzt4gflticb6xz2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170116132512.zyzt4gflticb6xz2-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/16/2017 08:25 AM, Jarkko Sakkinen wrote:
> On Mon, Jan 16, 2017 at 03:24:09PM +0200, Jarkko Sakkinen wrote:
>> On Fri, Jan 13, 2017 at 09:36:34PM -0500, Stefan Berger wrote:
>>> Make sure that we have not received less bytes than what is indicated
>>> in the header of the TPM response. Also, check the number of bytes in
>>> the response before accessing its data.
>>>
>>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> There are some things that I want to comment after all but I can give
>> now
>>
>> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>
>> I also noticed that this patch is not CC'd to linux-kernel.
> Please go through the whole patch and remove arithmetic
> from every possible place where you only end up with a
> constant.

sizeof(cap.timeout) -- what do you want to do about that? Is that 
legitimate or do you want a number then??? What about offsetof's?



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
