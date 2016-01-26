From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Tue, 26 Jan 2016 11:22:48 -0700
Message-ID: <20160126182248.GB17937@obsidianresearch.com>
References: <20160121174243.GD3064@obsidianresearch.com>
	<201601211902.u0LJ2LbL001130@d03av01.boulder.ibm.com>
	<20160121193049.GA31938@obsidianresearch.com>
	<201601212151.u0LLpC93021986@d03av03.boulder.ibm.com>
	<20160121221040.GA1630@obsidianresearch.com>
	<56A2461C.7030607@linux.vnet.ibm.com>
	<20160125181046.GB28108@obsidianresearch.com>
	<201601260105.u0Q15IWW028777@d03av04.boulder.ibm.com>
	<20160126034632.GB24217@obsidianresearch.com>
	<201601261421.u0QELnI3002626@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601261421.u0QELnI3002626-prK0F/7GlgzImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Tue, Jan 26, 2016 at 09:21:42AM -0500, Stefan Berger wrote:
>    > So, in an ideal world vtpms0 wouldn't even exist. The need for it is
>    > more tpm core breakage. You could avoid this by having the tpm core
>    > not create sysfs files on the parent for the vtpms. I think we are
>    > very close to being able to do that.

>    We're not explicitly registering the parent with sysfs, yet it appears
>    there. How do you prevent it from appearing there?

static struct kobject *get_device_parent(struct device *dev,
                                         struct device *parent)

                /*
                 * If we have no parent, we live in "virtual".
                 * Class-devices with a non class-device as parent, live
                 * in a "glue" directory to prevent namespace collisions.
                 */

The vtpm should be under virtual, the question is if we need vtpm and
and tpm devices, ie should the vtpm driver be calling class_create or
not.

I don't have an answer to that, are there other virtualization devices
you can reference as an example?

Ideally you'd get someone familiar with sysfs to confirm these details.

> The only other solution I could think of is being able to pass a
> NULL for 'dev' into the existing tpmm_chip_alloc() and avoid the
> parent device altogether.

This would drop the vtpm and put tpm directly under virtual, however I
think the tpm core currently will segfault if parent is null, that
could be fixed if that is the way this should go.

>> put_device should be last because it can kfree(vtpm_dev)
> Yes. Fixed.

Not on your github...

+static int vtpm_fops_release(struct inode *inode, struct file *filp)
+{
+	struct vtpm_dev *vtpm_dev = filp->private_data;
+
+	filp->private_data = NULL;
+
+	put_device(&vtpm_dev->dev);
+
+	vtpm_delete_device_pair(vtpm_dev);
+
+	return 0;
+}

Don't put something then continue to reference it after.

Also, I would probably drop the get_device in vtpm_fops_open, use the
implicit get_device of device_initialize instead. Then drop the
put_device in vtpm_destroy_vtpm_dev and use only one at the end of the
fops release.

So the flow is, device_initialize [...] create a flip, transfer the
kref from device_initialize to the flip [..]

Which makes the error flow very sane, once the flip is created,
deleting the flip will clean up everything.

>    I put the fixed version of the driver here:
>    https://github.com/stefanberger/linux/commits/vtpm-driver.v2

Please go through all the error handling, it still looks wrong:

+static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
+			    unsigned long arg)
+		vtpm_dev = vtpm_create_device_pair(&vtpm_new_pair);
[..]
+		if (copy_to_user(vtpm_new_pair_p, &vtpm_new_pair,
+				 sizeof(vtpm_new_pair)))
+			return -EFAULT;

Can't be right, that fails the ioctl but still creates the FD and TPM.

The goto unwind of vtpm_create_device_pair looks wrong too, double
calls vtpm_destroy_vtpm_dev and other. See above on how the flip
release should be relied upon to do that once the flip is created.

Also I'm wondering about the placement of tpm_chip_register, long
term we are going to be moving tpm setup commands under
tpm_chip_register, so the driver must be fully ready to handle
commands when it is called, so I think vtpm calls it too early.

For instance, get_timeouts is never called in vtpm, which is not
correct. The soft tpm should have an opportunity to tell the kernel
the timeout values.

I think you have to fix this by calling tpm_get_timeouts/chip_register
from a work queue thread created before the ioctl returns. That should
avoid deadlock..

This is also very wrong:

+struct vtpm_dev {
 +	struct kref kref;
 +
 +	struct device dev;

Structs should only ever have one kref. Get rid of 'kref' and use the
kref embedded in 'dev' via get_device/put_device.

Also, what is the point of 'vtpm_dev_get_by_chip' ? Just store the
vtpm_dev in the chip's private data pointer like every other driver.

No special locking is needed, tpm core guarentees no op is running or
will ever be called again once tpm_unregister returns.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
