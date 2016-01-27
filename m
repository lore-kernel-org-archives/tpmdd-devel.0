From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 15:25:34 -0700
Message-ID: <20160127222534.GB5520@obsidianresearch.com>
References: <201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
	<201601271242.u0RCgM0E031875@d03av05.boulder.ibm.com>
	<20160127175839.GA31038@obsidianresearch.com>
	<201601272158.u0RLwvIK005533@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601272158.u0RLwvIK005533-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Wed, Jan 27, 2016 at 04:58:51PM -0500, Stefan Berger wrote:

>    > I don't think there is a generic kernel side point where it could tell
>    > the child is isolated enough. Whatever that means.

>    I agree. Which set of namespaces is enough for running any program in
>    this set of namespaces (aka container) and being able to forget
>    about

It isn't just the presense of namespaces that matter, eg a net mount
namespace does not mean access is denied to the parent namespace, net
namespaces don't mean devices are isolated, etc.

This is not a good direction to go, access to an IMA namespace needs to
be very strongly controlled, 'enough namespaces' is not a sufficient
criteria!

Any flaw in the access criteria immediately destroys the security of
IMA in non-container contexts, so this needs to be done very
carefully.

>    > Doesn't selinux have the exact same problem? How does selinux handle
>    > namespaces?

>    They solve it by mounting with a context option, which enforces an
>    sVirt SELinux label across all files that the container user then
>    cannot change.

This sounds very sane.

>    > That said, maybe looking at selinux namespaces interaction will give a
>    > different idea..

>    See above. We cannot use the same trick.

Hmm, well, it certainly seems to be a lot of what is required, 
and like a much better direction than trying to use namespaces.

Arranging for an IMA namespace to only exists in association with a
SELinux label - and then rely on SELinux to provide the necessary
security isolation instead of trying to do the same thing with
namespaces sounds more likely to succeed..

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
