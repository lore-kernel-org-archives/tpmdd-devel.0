From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 0/9] tpm: cleanup/fixes in existing
	event log support
Date: Tue, 15 Nov 2016 11:05:42 +0530
Message-ID: <582A9EAE.5000505@linux.vnet.ibm.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20161114223322.5uzdc7sob2vukwrq@intel.com>
	<20161115002514.qhweuyzg5mgebusq@intel.com>
	<20161115021543.d4wgjqid7fut4y4c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161115021543.d4wgjqid7fut4y4c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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



On 11/15/2016 07:45 AM, Jarkko Sakkinen wrote:
> On Mon, Nov 14, 2016 at 04:25:14PM -0800, Jarkko Sakkinen wrote:
>> On Mon, Nov 14, 2016 at 02:33:23PM -0800, Jarkko Sakkinen wrote:
>>> On Mon, Nov 14, 2016 at 05:00:47AM -0500, Nayna Jain wrote:
>>>> This patch set includes the cleanup and bug fixes patches, previously
>>>> part of the "tpm: add the securityfs pseudo files support for TPM 2.0
>>>> firmware event log" patch set, in order to upstream them more quickly.
>>>
>>> I applied the patches. I'm not yet sure whether these are part of the
>>> 4.10 pull request or whether I postpone to 4.11 (my preference would be
>>> 4.10 but I do not want to close that right now). I'll do testing next
>>> week before doing pull request.
>>>
>>> I hope that the commits gets some reviews and testing now that they are
>>> easily testable in my master branch.
>>
>> Event log still works and they do not seem to break TPM 2.0 (tried both
>> machine with tpm_crb and tpm_tis).
>>
>> Stefan: would you mind check that these do not break your TPM 1.2
>> environment? I already tried wih TPM 1.2 machine but probably would
>> make sense to peer test.
>
> I'm dropping commits 8/9 and 9/9 from my tree and *will not* include
> them to my 4.10 pull request.

Will fix this and resend the patch 8/9 and 9/9 again.

Thanks & Regards,
    - Nayna

>
> /Jarkko
>


------------------------------------------------------------------------------
