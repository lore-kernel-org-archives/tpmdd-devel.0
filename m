From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Thu, 17 Dec 2015 17:57:56 -0700
Message-ID: <20151218005756.GA7060@obsidianresearch.com>
References: <20151214112501.GA26100@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET>
	<20151215233237.GA31965@obsidianresearch.com>
	<201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com>
	<20151216171633.GB32594@obsidianresearch.com>
	<201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<9F48E1A823B03B4790B7E6E69430724DA5864641@EXCH2010A.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA5864641-wI35/lLZEdT5yyJIIHUSGGSU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 17, 2015 at 11:44:41AM +0000, Fuchs, Andreas wrote:
> Jumping in real quick, since I'm going through some TPM2.0 RM
> design and implementation at the moment.
> 
> The big issue that I see with RMs in the kernel is none of the mentioned,
> but the issue of where to store the swap'ed (TPM2_ContextSave()'ed)
> blobs. These blobs are spec'ed with a size of up to 4kBytes.

This isn't a problem. As long as the context is located in swappable
memory that falls under the existing resource limit schemes for
userspace memory, then everything is fine.

Allocate the memory during open/write and fail those syscalls if the
process exceeds any of the standard memory limits.

It is no different than a process mmaping alot of memory and dirtying
it.

Jason

------------------------------------------------------------------------------
