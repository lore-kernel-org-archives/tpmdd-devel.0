From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Wed, 22 Feb 2017 12:08:28 -0500
Message-ID: <9cd7c6b6-a532-ea67-9607-7ba6e4d04f4f@linux.vnet.ibm.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
	<58AC85F2.5000406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <58AC85F2.5000406-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/21/2017 1:24 PM, Nayna wrote:
>
> [snip]
>>
>> 1. Take locks.
>> 2. Load transient objects from the backing storage by using ContextLoad
>>     and map virtual handles to physical handles.
>> 3. Perform the transaction.
>> 4. Save transient objects to backing storage by using ContextSave and
>>     map resulting physical handle to virtual handle if there is such.
>>
>> This commit does not implement virtualization support for hmac and
>> policy sessions.
>>
>
> If I have understood discussions correctly, I assume, that kernel TPM
> operations will also be routed via RM. And I think that is not happening
> now with these patches.

There is one corner case that requires kernel operations to go through
the RM, and that's the session context regapping.  If the kernel did not 
go through the RM, it could not handle TPM_RC_CONTEXT_GAP.

I believe that kernel operations such as PCR extend, that don't require
sessions, do not have to go through the RM.

Kernel operations that use objects perhaps can bypass the RM as long as 
there is a lock and the kernel also context saves objects and returns 
the TPM to the empty state before it releases the lock.

Finally, I suspect that the RM should reserve 3 sessions for kernel
operations, so the kernel can't block because user space applications 
have filled all the session slots.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
