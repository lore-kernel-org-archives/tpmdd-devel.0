From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 10:58:39 -0700
Message-ID: <20160127175839.GA31038@obsidianresearch.com>
References: <201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
	<201601271242.u0RCgM0E031875@d03av05.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601271242.u0RCgM0E031875-3MP/CPU4Muo+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 27, 2016 at 07:42:17AM -0500, Stefan Berger wrote:
>    What we don't want from the IMA perspective is that someone creates an
>    IMA namespace on the host similar to how one can create a network
>    namespace (ip netns add ...), runs (malicious) programs under a
>    different IMA policy, and then closes that IMA namespace.

Presumably who ever is implementing IMA namespaces has some kind of
solution for this though?

That seems like a very difficult problem.

>    hand, what we want are containers having their own IMA namespace with
>    an independent policy. Since the argument is that containers are well
>    isolated from the host and programs running there don't influence the
>    host, their logs would be independent. The thing is that containers are
>    made up of multiple namespaces. So, we likely won't give direct control
>    over IMA namespace creation through tools like network namespacing does
>    or even a dedicate clone flag but connect it to one or multiple
>    existing clone flags that cause creation of a (mount, pid, etc.)
>    namespace. So that could mean that if someone creates a mount + pid
>    namespace, and thus is well isolated, he automatically gets an IMA
>    namespace.

That isn't nearly good enough, mount namespaces don't mean you are
isolated. It isn't until another tool like docker goes through and
alters the child's mount table that some degree of isolation is
achieved..

I don't think there is a generic kernel side point where it could tell
the child is isolated enough. Whatever that means.

Doesn't selinux have the exact same problem? How does selinux handle
namespaces?

>    IMA namespacing would then provide less control for users compared to
>    network namespacing and therefore an ioctl, issued from the clone()ing
>    process, for IMA+vTPM driver hook-up would be sufficient.

I agree IMA namespaces probably don't need the whole 'ip setns' type
interface, but realistically if an ioctl is provided to install a TPM
in a child namespace it should let anyone with privilege in the parent
namespaces install a TPM in a child IMA namespace, that is just how
the namespace APIs seem to work.

That said, maybe looking at selinux namespaces interaction will give a
different idea..

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
