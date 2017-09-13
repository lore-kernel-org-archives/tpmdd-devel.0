From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm: ignore burstcount to improve
 tpm_tis send() performance.
Date: Wed, 13 Sep 2017 12:01:20 -0700
Message-ID: <5C86BF5C-76AA-47DB-B15B-DE524823CF9F@gmx.de>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-2-nayna@linux.vnet.ibm.com>
 <20170906161246.GA9747@obsidianresearch.com>
 <3c418974-a4c7-518e-b218-f6373c10209e@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <3c418974-a4c7-518e-b218-f6373c10209e-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 13. September 2017 11:52:12 GMT-07:00 schrieb Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>:
>On 9/6/2017 12:12 PM, Jason Gunthorpe wrote:
>> 
>> The problem with this approach is that the TPM could totally block
>> the CPU for very long periods of time.
>> 
>> It seems very risky to enable..
>> 
>
>How would you characterize "very long"?
>
>The TPM vendors confirm that they empty the FIFO at internal speeds
>that
>are comparable to the bus speed.  Thus, any stall will be sub-usec.  Is
>that an issue?

If the tpm does behave correctly, this is fine. 
If the tpm hangs for whatever reason, your machine is frozen and you will never figure out why.

That's my concern there.
However ddwg seems fine.

>
>In addition, new TPMs have ever larger FIFO's, making stalls less
>likely
>going forward.
But also reduced the polling loops that introduce the performance penalty ;)

>
>
>------------------------------------------------------------------------------
>Check out the vibrant tech community on one of the world's most
>engaging tech sites, Slashdot.org! http://sdm.link/slashdot
>_______________________________________________
>tpmdd-devel mailing list
>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
