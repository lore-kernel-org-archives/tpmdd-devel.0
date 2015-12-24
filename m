From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Thu, 24 Dec 2015 10:09:43 -0500
Message-ID: <n5h1rj$nkb$1@ger.gmane.org>
References: <9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com> <20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org> <20151224114241.GA5119@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20151224114241.GA5119-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 12/24/2015 6:42 AM, Jarkko Sakkinen wrote:
>
> Code is not rejected solely on its size as long as is broken up into
> reasonable size and otherwise sane patches.

I'm still at the prime question. If we present a ~5 loc resource 
manager, can it be accepted, or will it be rejected as "too big"?

~~

We already went through the failing process with TPM 1.2.  I had a 50 
kloc TPM, and they wanted me to release it as <100 loc patches.

1 - How do you release an entirely new function as a patch.  It's not 
patching anything?

2 - If you break it up, won't it be rejected because it doesn't work. 
It may not even compile?

3 - Breaking it up into small pieces that even compile can mean 
designing the code inefficiently.

4 - Or, are you saying that we code the entire RM, but just show it to 
you a function at a time?  Can anyone review a bunch of functions 
without seeing how it fits together into a program?

~~

I can understand small "patches" to fix bugs, but not for new code.






------------------------------------------------------------------------------
