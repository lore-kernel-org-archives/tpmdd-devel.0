From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Thu, 21 Jan 2016 12:30:49 -0700
Message-ID: <20160121193049.GA31938@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601211902.u0LJ2LbL001130-Rn83F4s8Lwc+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Thu, Jan 21, 2016 at 02:02:17PM -0500, Stefan Berger wrote:
>    What is IMA namespace in relation to a device's name? The method is to
>    read the major/minor numbers on the host and created /dev/tpm0 with the
>    same major/minor numbers in the container's filesystem. The name
>    doesn't matter I guess, but major/minor are important.

Ostensibly we number the /dev/tpmX's in relation to the tpm index
number.

Internally to the kernel the TPM access is done by that tpm index.

Today, IMA hard codes that index value to 0 (IIRC). I could see a
future IMA allowing user space to specify the index. The index is also
how to associate the /dev/tpm node with the /sysfs files.

So the index is important, we'd want to control it for namespaces.

In any case the tpm index is part of the contract, and it would be
ideal if the IMA namespace made tpm index 0 be the right vtpm.

>    The problem I have run into in particular with Docker and golang is
>    that Docker invokes the golang function to run an external program. The
>    golang function does a clone(), a whole lot of other stuff after it,
>    and in the end the execve().

Well, ultimately that is a docker problem, as you describe IMA has a
special new requirement where the IMA NS has to be setup quickly.

>    The code is here:
>    [1]https://golang.org/src/syscall/exec_linux.go
>    Look at the function forkAndExecInChildon line 56++.

Well, that is just bad API design, sorry. The unix model of fork()/exec()
is that the app gets a chance to adjust the environment between
fork/exec, and this design, while easy to use, locks the app into the
hard wired customization that forkAndExecInChild does.

Maybe add a callback to SysProcAttr or something? Can't help you here.

You can't let this influence the kernel UAPI design.

>    available. So, the conclusion is, to accomodate golang (for example) we
>    can create the device pair, sit the vTPM on top of the master, and
>    reserve the device pair befor the next clone() so that IMA finds it and
>    can hook up to it.
>    What is wrong with this scheme? The ioctl for 'reservation' before the
>    clone()?

Yes, how does that sort of thing even make sense in a complex
multi-threaded world?

>    Should it work like this?

Sort of like this:

    controlfd = open("/dev/vtpmx", ...);
    ioctl(controlfd, CREATE_VTPM, &inargs, &outargs);
    serverfd = outargs.fd;
    // /dev/tpmX exists. X is returned in outargs.tpm_index, maybe  return major/minor too

    child = clone(...)
    ioctl(??? , ASSIGN_VTPM_TO_NS, .. child->ima_ns .., to index = 0,
          from index = outargs.tpm_index);

    /* tpm index X is destroyed, kernel prevents reuse of index X
       until the NS is destroyed too. /dev/tpmX is removed by udev */
    close(severfd);

So, you'd probably make a vtpm daemon that took as execv args a
reference to the IMA namespace to create the tpm in, and have docker
launch it after the clone, but before the exec in the parent
namespace.

That is fairly similar to how net ns works, with the wrinkle you have
to do this before the exec, I guess.

It also allows hw tpms to be routed to the ns.

The docker container just has the normal /dev/tpm0 

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
