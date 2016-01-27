From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 16:33:58 -0700
Message-ID: <20160127233358.GA7608@obsidianresearch.com>
References: <201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<20160127031320.GC23863@intel.com>
	<201601271242.u0RCgM0E031875@d03av05.boulder.ibm.com>
	<20160127175839.GA31038@obsidianresearch.com>
	<201601272158.u0RLwvIK005533@d01av01.pok.ibm.com>
	<20160127222534.GB5520@obsidianresearch.com>
	<201601272255.u0RMtuqY014120@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601272255.u0RMtuqY014120-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Jan 27, 2016 at 05:55:50PM -0500, Stefan Berger wrote:
>    > be very strongly controlled, 'enough namespaces' is not a sufficient
>    > criteria!

>    Isolation should be a criteria and isolation becomes better with more
>    namespaces enabled.

Yes, but IMA needs complete isolation, not just 'better' isolation.

> That way one can run any program inside the set of namespaces and
> not harm the host or any other namespaces / containers.

No, that is not how namespaces work at the kernel level, they don't
provide isolation until after userspace configures the isolation
features.

Or said another way, it is not better than CAP_ADMIN, because anyone
with CAP_ADMIN could create namespaces and manipulate them from user
space in a way that can substantially defeat IMA.

Do not assume 'docker' is the thing doing this. Assume
'hostile-docker' is involved and make a scheme that doesn't totally
break IMAs security promise.

For instance I could use hostile-docker to create all the namespaces,
including IMA, then drop in eth0 and bind mount /, and run software
that does something hostile to eth0 - and I think that is totally
contry to the guarentee a system running IMA should
provide. Specifically that CAP_ADMIN should not be able to opt out of
IMA.

>    > Hmm, well, it certainly seems to be a lot of what is required,
>    > and like a much better direction than trying to use namespaces.

>    I don't agree. We want to allow users to run the own IMA appraisal
>    policy. For that files need to be signed and the user's key passed to
>    the IMA namespace. To enable that we need per-file file signatures, not
>    some single label that works across all files in a filesystem. IMA's
>    appraisal mode just doesn't work this way.

Isn't that exactly what SElinux is trying to do? The SElinux problem
is 'allow users to run their own SELinux policy'. Just like IMA,
SELinux has per-file attributes that have a user security label. IMA
has a per-file user signature in the attribute instead.

So, for IMA you'd do

 .. make mount namespace ..
 mount --bind /.../container/fs -o ima_namespace=foo /

After which all accesses to / would use the IMA policy namespace foo,
and read the signature from the attribute in the filesystem.

I'm not sure it is better than doing it at clone, but it doesn't seem
out of line.

>    I am not sure whether SELinux labeling alone provides enough
>    isolation.

Nor am I, but maybe there is a way forward like that.

While with namespaces I can tell you right now, there can be no easy
solution that would be better than testing CAP_ADMIN :|

>    And it's likely not just the label that's important but all the rules
>    that go with it to determine what a process can do and what not. How do
>    you even evaluate that from inside the kernel that it's worthy an IMA
>    namespace?

When IMA is turned on user space tells the kernel these details?

So the restriction kernel side becomes
 1) The user space has told the kernel something about SELinux
     security labels for use with IMA
 2) The mount option contains an IMA namespace and the SELinux label compatible
    with #1
Then allow the IMA namespace to be used for that mount

At least that way it something strong that can be reasoned about.. And
is opt-out by default.

Anyhow just brainstorming for you..

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
