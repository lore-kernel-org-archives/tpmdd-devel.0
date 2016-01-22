From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Fri, 22 Jan 2016 10:09:16 -0500
Message-ID: <56A2461C.7030607@linux.vnet.ibm.com>
References: <20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160121221040.GA1630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/21/2016 05:10 PM, Jason Gunthorpe wrote:
> On Thu, Jan 21, 2016 at 04:51:06PM -0500, Stefan Berger wrote:
>
>>     > You can't let this influence the kernel UAPI design.
>>     The choice is between getting this working 'today' (even if just
>>     locally) or discussing this with golang designers, which in the ideal
>>     case would cause me waiting for the next version, dealing with that
>>     version dependency etc., plus the delay. So, clearly, an additional
>>     ioctl() and ~50 lines of code make this work 'now'. Doesn't this seem
>>     worth it?
> Sorry, for mainline stuff like this reserve thing is not clean enough
> to be acceptable.
>
> Why can't you just open-code a modified forkAndExecInChild in docker?
>
> Seriously, the golang code you showed already has special stuff to do
> user namespaces before the exec, it is totally unreasonable insist
> that other namespace stuff can't be done the same way.

I have not 'insisted' that this cannot be done. I have merely shown a 
work-around.

It looks like the golan impl. would need some sort of (optional) 
synchronization between the child and the parent in order for the parent 
to hook the vTPM to the IMA namespace that the child just created if the 
parent is the only one allowed to do that. The hook-up would have to 
happen before the execve()...

>
>>     >     child = clone(...)
>>     >     ioctl(??? , ASSIGN_VTPM_TO_NS, .. child->ima_ns .., to index = 0,
>>     >           from index = outargs.tpm_index);
>>     after the clone() you are in that IMA namespace. So the only argument
>>     needed there is the index to the tpm_chip to hook up to the current IMA
>>     namespace.
> No, all of the above was in the parent namespace, the clone creates
> the child IMA namespace and launches the thread, but only the parent
> would have enough permissions to actually share the TPM to the child -
> ie the child cannot self-join.

Ok, so I guess the ioctl would take the PID of the created child as a 
parameter (how else to identify it?). The kernel would find that child, 
check that the calling parent is indeed the parent of the child, and if 
everything looks good do the hook-up.

The reservation works similar in so far as the 'reservation' would 
lookup the calling processe's PID and associate that with the vTPM 
device pair instance on which the ioctl was called. Once the child is 
created, IMA namspacing looks for a reserved vTPM device pair instance 
by matching up PIDs.

>
> You could also go the way of the mount namespace where the actions
> isn't an 'add to child namespace' but a 'remove from my namespace',
> but I don't think that makes as much sense for devices, the 'add'
> approach in line with the net ns seems cleaner. Others more familiar
> with namespaces may have other ideas, but I doubt you'd find anyone to
> support a reserve scheme.
>
>>     I got that part with the fd, major & minor number. It seems to work.
>>     I have one ioctl to reserve for before the clone and another ioctl to
>>     hook IMA-NS and vTPM together after the clone, but that patch is for
>>     later. So let's not just kill the ioctl for 'reservation' like that,
>>     please.
> No, kill it now. It doesn't make sense as part of this series, it
> should have been in the IMA namespace patch anyhow.
>
>>     > That is fairly similar to how net ns works, with the wrinkle you have
>>     > to do this before the exec, I guess.
>>     >
>>     > It also allows hw tpms to be routed to the ns.
>>     How many hardware TPMs are going to be there ? One? That is to be used
>>     for the host, right?
> No idea. It depends on the application. The HW tpm is alot better than
> this vtpm idea for many use cases. I could see applications where
> you'd want to use the host PCRS because they cover the bios and kernel
> the app is actually running under. I actually have a hard time
> understanding what value fake software PCRS are to containers <shrug>

I would just say that both use-cases exist, one with a hardware TPM and 
one with each container having a vTPM. The issue is that I don't see how 
well containers can share the single hardware TPM and its PCRs.

>
> I certainly wouldn't want to be forced to store keys in a software tpm
> just because I am using containers, for instance.

IMO, sharing the single hardware TPM between containers is an unsolved problem.


>
>>     TPMs. And sharing the single hardware TPM between multiple containers
>>     just isn't possible.
> Of course it is, it just hasn't been done yet, and won't be a 100%
> perfect emulation.

How do you handle access to PCRs? How do you handle sealing against PCRs?

>
>>     This will not be possible when going through the vTPM driver, but you
>>     have the ??? up there. I'd put the 'controlfd' in that place.
> No, it should not be controlfd, it should be what ever API the rest of
> the IMA namespace stuff is using, I think.
>
>>     The vTPM driver will only know about vtpm_dev->chip that it
>>     created and none of them is a hardware TPM.
> Right, controlfd implies that only vtpms could be shared to a IMA
> namespace, which is a terrible API. This is another reason why
> reserved is a terrible API.

Thanks for all feedback. I will eventually post v2. For now it's to be 
found here:

https://github.com/stefanberger/linux

The branch is easy to find.

      Stefan


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
