From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Mon, 25 Jan 2016 20:46:32 -0700
Message-ID: <20160126034632.GB24217@obsidianresearch.com>
References: <20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
	<20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601260105.u0Q15IWW028777-2xHzGjyANq4+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Mon, Jan 25, 2016 at 08:05:14PM -0500, Stefan Berger wrote:

> > And confused why there is a miscdev and a alloc_chrdev_region ?
> 
> miscdev = /dev/vtpmx - that should be ok, no ?

Yes

> So, I just removed alloc_chrdev_region and with that the assignment of a
> major+minor to the virtual device. This works fine on device creation but on
> device destruction something odd happens in sysfs.

> With two 'vtpmctrl' test programs running sysfs looks like this:
> 
> # find /sys/devices/virtual/vtpm/
> /sys/devices/virtual/vtpm/
> /sys/devices/virtual/vtpm/vtpms0
> /sys/devices/virtual/vtpm/vtpms0/dev

Ugh.

So, in an ideal world vtpms0 wouldn't even exist. The need for it is
more tpm core breakage. You could avoid this by having the tpm core
not create sysfs files on the parent for the vtpms. I think we are
very close to being able to do that.

The it would just be /sys/devices/virtual/tpm0/dev

If vtpms0 is kept, then it shouldn't have a 'dev':

> /sys/devices/virtual/vtpm/vtpms0/dev

The plus side is that it should be able to act as the devm container
for the tpmm_ function.

This should be the only dev:

> /sys/devices/virtual/vtpm/vtpms0/tpm0/dev

That is a big clue something is very wrong if the above exists but
the alloc_chrdev_region was removed.

> That's all that is left now. .../vtpms1/tpm1/ has also already disappeared.
> Needless to say, the kernel is very unhappy once the other vtpmctrl terminates.
> 
> The virtual device needs a major/minor as well. Are there any other possible
> solutions?

This bad behavior is some secondary bug.. Just looking around I think
all the lifetime stuff needs a good go over. I noticed at least...

This looks wrong:

+static int vtpm_fops_release(struct inode *inode, struct file *filp)

+    put_device(&vtpm_dev->dev);
+
+	_vtpm_delete_device_pair(vtpm_dev);

put_device should be last because it can kfree(vtpm_dev)

This looks questionable too:

+   device_destroy(vtpm_class, vtpm_dev->dev.devt);

The driver never calls device_create, it shouldn't call
device_destroy.

The device_initialize transfers kref ownership to the caller, so
vtpm_dev->dev needs a matching device_put on all error paths, not
device_destroy

IMHO, the put_device in the fops->release should be the match to
device_initialize, and it should be the last thing. Audit eveything
else to make that true

This looks wrong too:

+    /* device is needed for core TPM driver */
+    device_initialize(&vtpm_dev->dev);
+    vtpm_dev->dev.devt = devt;
+    vtpm_dev->dev.class = vtpm_class;
+    vtpm_dev->dev.release = vtpm_dev_release;

I usualle like to put device_initialize last in that sequence, drop
the devt stuff so you don't get a 'dev'

The RCU stuff looks off too - where is the synchronize_rcu ?

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
