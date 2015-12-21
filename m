From: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Mon, 21 Dec 2015 13:22:04 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
References: <201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com> <20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com>,<n5144n$1ug$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <n5144n$1ug$1@ger.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Let me emphasise this even more. It would be greate to have a kernel-space TPM
Resource Manager (everybody thinks to agree), but it would also bit a big module
and a big programming investment.

I ask the tpmdd-maintainers to check (reconcile with parent subsystem
maintainers) if a 3-5 kLoC module would be generally acceptable for a 
TPM-ResourceManager?

The advantages would be to have some actual full access to all of TPM from
within the kernel (including access to sessions without hacks); e.g.
TrustedKeyrings and ecryptfs come to mind.
With a userspace-RM we need some hacks to have sessions run because of the
ungaping-problem (see earlier mail). It's also way cleaner.

Also we wind up with a light-RM inside the kernel anyways, so it might be worth
going full instead. Going with the hacked approach we are assuming some
limitations on kernel accesses to the TPM.  With the full RM inside the kernel
there are no limitations, i.e. the RM is future proof as more kernel and app
level uses of the TPM are added.


In case there was a positive signal, I'd be willing to contribute to the RM development.

Proposed roadmap:
- Gather interested developers (both from Kernel as well as TSSes)
- Prepare a feature-architecture (to be added to kernel-doc)
   Includes behavior of e.g. fd-fork, fd-passing, etc
   Also see the TCG-Draft on RMs: 
   http://www.trustedcomputinggroup.org/resources/tss_tab_and_resource_manager
   New in-Kernel tpm-interface
- Sketch out software architecture
   includes layered system, hook-based, ....
- Do the patches coordinated (to prevent having multiple implementation efforts)

So please, Jarkko, Peter, Marcel, James, Greg K-H (I think that's the list),
would there be the chance for a signal / tendency by one of you ?

Many interessted parties need this before proceeding because of the significant
amount of work involved.

________________________________________
From: Ken Goldman [kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org]
Sent: Friday, December 18, 2015 15:10
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: Re: [tpmdd-devel] Question on Linux TSS architecture design (kernel vs. user space access)

On 12/18/2015 6:41 AM, Jarkko Sakkinen wrote:
>
> For me this discussion seems a bit paralyzed. If one wants to do
> something for the issue, one should send a patch or patches and then we
> can see how elegant the solution is and how much it does or does not
> interfere the user space. That's why enumerated the technical
> constraints for TPM2 in my previous responses and otherwise have been
> quite passive. I'm not too interested on this "philosophical" side.

As a developer, the philosophical side is #1 in importance.

A resource manager isn't a little patch.  It's a large, complex project
which will take perhaps 6 months to code and test.  No one wants to
spend those months and then have the code rejected for philosophical
reasons.

If the community agrees that a RM in the kernel will be accepted if the
code is of good quality and well tested, we can do it.

If the community won't accept the code under any conditions, tell us
now.  We'll fall back on the user space resource manager, the limited
resource manager in the kernel, and all the hacks required to have them
work together.


------------------------------------------------------------------------------
_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
