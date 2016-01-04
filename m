From: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Mon, 4 Jan 2016 16:07:41 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724DA5877E69@EXCH2010B.sit.fraunhofer.de>
References: <201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com>	<20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com>
	<n5144n$1ug$1@ger.gmane.org>,<20151222065917.GB7867@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20151222065917.GB7867-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> >
> > If the community won't accept the code under any conditions, tell us
> > now.  We'll fall back on the user space resource manager, the limited
> > resource manager in the kernel, and all the hacks required to have them
> > work together.
> 
> I'm all for the idea but I'd like to discuss more about constraints and
> corner cases and in the end of the day would rather read code than
> email (even big pile of code).
> 
> One of the corner cases are vendor specific commands. I raised that but
> it was ignored in this discussion.
> 
> Now that I looked at TCG document it does not give any recommendation how
> they should be managed:
> 
> http://www.trustedcomputinggroup.org/resources/tss_tab_and_resource_manager

I'll try to remeber this point for the next iteration...

IMHO, it should check the number of handles in the handle-area via the
TPM2_GetCapability() call. If a vendor is ignorant enough to put a handle into
the parameter-section, there is nothing we can do besides some quirks once we
recognize them...
But this will be the same for all OSes...

Cheers,
Andreas
------------------------------------------------------------------------------
