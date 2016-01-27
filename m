From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 27 Jan 2016 11:21:52 -0700
Message-ID: <20160127182152.GB31038@obsidianresearch.com>
References: <20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
	<20160126034632.GB24217@obsidianresearch.com>
	<201601261421.u0QELnI3002626@d01av02.pok.ibm.com>
	<20160126182248.GB17937@obsidianresearch.com>
	<201601262322.u0QNMo1r022303@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601262322.u0QNMo1r022303-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Tue, Jan 26, 2016 at 06:22:46PM -0500, Stefan Berger wrote:
>    > I don't have an answer to that, are there other virtualization devices
>    > you can reference as an example?
>    I don't have a virtual device example that doesn't have a parent. I had
>    looked at virtio_console for, but that one also has a parent.
>    [1]http://lxr.free-electrons.com/source/drivers/char/virtio_console.c#L1439

virtio console is really a 'hardware' device under a VM setting, so
it's parent make some sense.

Are you aware of any devices used directly with containers? I only
know of netdevices, and I'm not sure that is relevant.

>    > Also, I would probably drop the get_device in vtpm_fops_open, use the
>    > implicit get_device of device_initialize instead. Then drop the
>    > put_device in vtpm_destroy_vtpm_dev and use only one at the end of the
>    > fops release.
>    We have the implicit get_device in vtpm_create_vtpm_dev and would
>    therefore try to keep the put_device in vtpm_destroy_vtpm_dev.

No, go back and re-read my last message.

vtpm_destroy_vtpm_dev shouldn't even exist, evey call to it looks
kinda weird..

vtpm_create_device_pair creates a flip and deleting the flip should
delete everything else. The only time there are special cases are
within vtpm_create_vtpm_dev itself, which should be handled in-line
with goto-unwinds.

Return the struct file from vtpm_create_device_pair not the struct
vtpm_dev to make this clear.

'vtpm_delete_device_pair' should just put the flip, and all that clean
up should be in the flip release. Doing any clean up while the file is
still active just creates complex scenarios for no real reason.

I'd also drop vtpm_cleanup, it doesn't look right to me... Ie this
doesn't make any sense:

+		vtpm_dev->file->f_op = &null_fops;

null_fops is still a pointer within this module, so the module still
cannot be unloaded. If the module cannot be unloaded there is no
reason to have vtpm_cleanup. I don't know if there is a solution to
that, but generally speaking module detach is hard, racy, and best
avoided. In a case like this killing all the vtpm daemons will allow
module unload, so I'd just go with that much simpler solution.

Just ensure the module lock is held while any vtpms exist. I actually
thought the file code did this for the module, so I'm susprised that
vtpm_cleanup would even be callable at all?

Once all that is done then the flip alone controls the lifetime of the
rest of the objects and it is very easy to reason about.

>    True. I have not been able to undo fd_install so far and cannot find
>    any other code that does that. So, I pulled that out and put it after
>    the successful copy_to_user().

That looks much better, yes.

>    > For instance, get_timeouts is never called in vtpm, which is not
>    > correct. The soft tpm should have an opportunity to tell the kernel
>    > the timeout values.

>    That's seems a chick-and-egg problem. The vTPM can only be started once
>    the ioctl has provided the fd.

Hence the work queue suggestion.

Start a work queue task/kernel thread/something right before
fd_install that does tpm_get_timeouts and tpm_register.

The ioctl will return and immediately read() on the fd will be
available for get_timeouts. The user space side must process the read
and return a response within the default tpm timeout period.

So, userspace should not call the ioctl to register the tpm until it
is completely prepared to process tpm commands and it should
immediately process commands once the ioctl returns.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
