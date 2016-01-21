From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 20 Jan 2016 18:17:01 -0700
Message-ID: <20160121011701.GA20361@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601201439.u0KEdFao027907-3MP/CPU4Muo+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016
>    06:51:07 PM:
>    >
>    > On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger wrote:
>    > > +   pdev = platform_device_register_simple("tpm_vtpm",  vtpm_dev->dev_num,
>    > > +                      NULL, 0);
>    >
>    > This seems strange, something like this should not be creating
>    > platform_devices.
>    Should it be a misc_device then ?

No. Check what other virtual devices are doing..

Generally speaking, the tpm core should not insist on a parent device
the way it does. That is an artifact of the clean up I did of the
drivers that was never fully compelted. To make the driver migration
easier the TPM core is using devm in places it probably shouldn't, but
unwinding that requires more difficult all-driver changes.

If you get stuck here you will have to fix the core code.

>    > > +   vtpm_dev->chip = tpmm_chip_alloc_pattern(vtpm_dev->pdev,
>    > > +            &vtpm_tpm_ops,
>    > > +            VTPM_DEV_PREFIX_CLIENT"%d");
>    >
>    > I agree with Jarkko I don't see why these deserve special names..
>    I did that because it becomes confusing when there are many /dev/tpm%d
>    type of devices. This way we can distinguish between a hardware
>    /dev/tpm%d and all these types of devices.

That isn't really consistent with how linux kernel naming works these
days. Use a udev rule in userspace if you really want this.

>    > Presumably some namespace magic can be used to make them show up as
>    > tpm0 in a container?
>    The magic is to have the container management stack create the device
>    pair. From the ioctl it learns the name of the devices that were
>    created and it then finds out about the major/minor number of the
>    created device and have /dev/tpm0 with that major/minor created in the
>    container's /dev directory.

Except that isn't good enough - the IMA kernel side doesn't know that this
tpm is now acting as the 'main' 'default' TPM.

>    The issue with sysfs is that sysfs is showing directory entries for all
>    vTPMs in all containers.

That is not a problem to solve here. The sysfs will also show entires
for hardware tpms too. You need somekind of namespace related solution
that works for all tpms.

I don't know what became of it, but there used to be 'device
namespaces' patch series that delt with this kind of problem.

Again, I suspect strongly this will need some kind of TPM/IMA
namespace to actually do what you want.

>    If we don't want users to see the PCRs of other containers we set
>    this flag. The side effect of setting this flag is that the
>    container will not be able to see its own TPM device, either, but
>    presumably the user has commands to reads PCRs etc.

Erm, sysfs is just an obvious symptom, the container could also just
create the dev node and access any tpm it likes, or use some future
(?) IMA API with a tpm device number.

>    VTPM_FLAG_NO_LOG: Container's boot/start without firmware that
>    would write an ACPI log. So in most cases one will choose the
>    VTPM_FLAG_NO_LOG flag since there is no log. Maybe that's a flag
>    the user shouldn't have control over.

? But there is no ACPI handle so this should already be naturally
defeated by the core code. Why a flag?

>    > Another way to handle this is to return the FD for the server side of
>    > the new TPM here and then route accesses from the /dev/tpmX side to
>    > that FD. Avoid the extra char device. There is some kernel
>    > infrasturcture that helpd do this (anon fd or something, IIRC)

>    Hm, I would prefer to keep the server-side char device since that way
>    one isn't tied to fd passing or so and the TPM could terminate and be
>    restarted later on on top of that server side device while keeping the
>    client side device usable beyond the server side shutting down.

Don't be afraid of FD passing.

vTPM daemon restart isn't really feasible anyhow as TPMs are
stateful. The kernel is not prepared to survive a HW TPM reboot.  If
that problem were to be solved somehow then a scheme like systemd's
FDSTORE=1 to keep the fd alive during a daemon crash could be used.

The huge downside to using a master side dev node is that these things
will leak. Killing the vtpm daemon will not clean up the slave
interface and another command and sysadmin interaction will be needed
to sort out the inevitable mess.

>    > Then del becomes close() on the special fd
>    And with that the client side device would *have* to close as well
>    because the backend now is inaccessible?

The client side would see failures on all TPM commands it tries to

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
