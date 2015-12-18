From: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 11:06:54 +0100
Message-ID: <C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
References: <1450021353-8775-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20151214095830.GA21291@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF197@ABGEX74E.FSC.NET>
	<20151214112501.GA26100@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET>
	<20151215233237.GA31965@obsidianresearch.com>
	<201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com>
	<20151216171633.GB32594@obsidianresearch.com>
	<201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	,<201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	,<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA586493C-wI35/lLZEdT5yyJIIHUSGGSU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
Content-Language: en-US
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



> That is the discussion to be held if the decision against RM inside
> kernel remains as is.

Is there a decision? If yes, who made it? Where is it documented?

Martin

------------------------------------------------------------------------------
