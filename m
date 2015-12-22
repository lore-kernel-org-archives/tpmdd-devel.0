From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Tue, 22 Dec 2015 08:59:17 +0200
Message-ID: <20151222065917.GB7867@intel.com>
References: <201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com>
	<20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <n5144n$1ug$1@ger.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 18, 2015 at 09:10:35AM -0500, Ken Goldman wrote:
> On 12/18/2015 6:41 AM, Jarkko Sakkinen wrote:
> >
> > For me this discussion seems a bit paralyzed. If one wants to do
> > something for the issue, one should send a patch or patches and then we
> > can see how elegant the solution is and how much it does or does not
> > interfere the user space. That's why enumerated the technical
> > constraints for TPM2 in my previous responses and otherwise have been
> > quite passive. I'm not too interested on this "philosophical" side.
> 
> As a developer, the philosophical side is #1 in importance.
> 
> A resource manager isn't a little patch.  It's a large, complex project 
> which will take perhaps 6 months to code and test.  No one wants to 
> spend those months and then have the code rejected for philosophical 
> reasons.
> 
> If the community agrees that a RM in the kernel will be accepted if the 
> code is of good quality and well tested, we can do it.
> 
> If the community won't accept the code under any conditions, tell us 
> now.  We'll fall back on the user space resource manager, the limited 
> resource manager in the kernel, and all the hacks required to have them 
> work together.

I'm all for the idea but I'd like to discuss more about constraints and
corner cases and in the end of the day would rather read code than
email (even big pile of code).

One of the corner cases are vendor specific commands. I raised that but
it was ignored in this discussion.

Now that I looked at TCG document it does not give any recommendation how
they should be managed:

http://www.trustedcomputinggroup.org/resources/tss_tab_and_resource_manager

/Jarkko

------------------------------------------------------------------------------
