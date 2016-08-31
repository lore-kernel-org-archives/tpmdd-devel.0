From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 1/7] tpm: Define a generic open()
 method for ascii & bios measurements.
Date: Thu, 1 Sep 2016 00:39:22 +0530
Message-ID: <57C72B62.3060308@linux.vnet.ibm.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830170345.GA6373@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160830170345.GA6373-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Thanks Jason for review. I will address your comments in my next version 
of patches.

I also have some thoughts on one of your comment.. Responding inline in 
respective patch.

Thanks & Regards,
   - Nayna

On 08/30/2016 10:33 PM, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 12:50:13AM -0400, Nayna Jain wrote:
>> Open methods for eventlog ascii and binary bios measurements file
>> operations are very similar. This patch refactors the code into
>> single open() call by passing seq_operations as i_node->private data.
>>
>> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> Looks basically fine, with Jarkko's comment addressed. I recommend
> using clang-format when working with the kernel, it makes everything
> easy.
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> Jason
>


------------------------------------------------------------------------------
