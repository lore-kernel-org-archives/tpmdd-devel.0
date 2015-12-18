From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 13:51:37 +0200
Message-ID: <20151218115137.GA4774@intel.com>
References: <C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET>
	<20151215233237.GA31965@obsidianresearch.com>
	<201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com>
	<20151216171633.GB32594@obsidianresearch.com>
	<201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<201512171533.tBHFXn35003792@d03av02.boulder.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754E@ABGEX74E.FSC.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C5A28EF7B98F574C85C70238C8E9ECC04E6940754E-bIoXcEM4pvRAuK1PVaBULA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 18, 2015 at 12:21:01PM +0100, Wilck, Martin wrote:
> > The only way to restrict this would be to only allow root access to
> > the keyctl commands affecting the TPM.
> 
> I'll leave it to Jarkko to comment on that. 
> Btw, wouldn't the "keys, trusted" API need some sort of resource
> management, too? And wouldn't it make sense to merge that all into a
> single TPM resource pool?

Well this should have been done when the syscall was originally
introduced. I think the right long term solution would be to do resource
swapping mechnaism (like the LRU mechanism that I described).

/Jarkko

------------------------------------------------------------------------------
