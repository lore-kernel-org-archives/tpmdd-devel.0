From: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 12:09:02 +0100
Message-ID: <C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
References: <201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com> <20151218105323.GB12882@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20151218105323.GB12882-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fr, 2015-12-18 at 12:53 +0200, Jarkko Sakkinen wrote:
> On Fri, Dec 18, 2015 at 12:51:48PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Dec 18, 2015 at 11:06:54AM +0100, Wilck, Martin wrote:
> > > > That is the discussion to be held if the decision against RM inside
> > > > kernel remains as is.
> > > 
> > > Is there a decision? If yes, who made it? Where is it documented?
> > 
> > Yeah, I'd be interested too.
> 
> That was sarcasm. You really can't make such decisions for the kernel.
> It's always the code/patches that speaks.

Decisions are being made all the time, by maintainers, in mailing list
discussions, on kernel summits. If only a limited subsystem is affected,
they can be made based on coded quality alone. But it becomes difficult
when several communities are involved, like kernel & systemd or, in our
case, TPM device driver & user space TSS. In these cases it's important
to take a step back from the purely technical developer perspective and
try to figure out what the common goal is and how it can best be
reached.

The question whether resource management should be done in the kernel or
in user space can't be decided based on patches alone. Maybe we'll end
up with a situation where both ways are implemented and either distro
makers or even end users will have to make the choice. Is that
desirable?

Martin

> 
> /Jarkko
------------------------------------------------------------------------------
