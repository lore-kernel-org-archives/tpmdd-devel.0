From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Wed, 20 Jan 2016 20:21:15 -0700
Message-ID: <20160121032115.GA26266@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601210301.u0L31h5r012187-MijUUJkLaQs+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Jan 20, 2016 at 10:01:38PM -0500, Stefan Berger wrote:
> > On Wed, Jan 20, 2016 at 09:39:09AM -0500, Stefan Berger wrote:
> > >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/19/2016
> > >    06:51:07 PM:
> > >    >
> > >    > On Thu, Jan 14, 2016 at 11:01:57AM -0500, Stefan Berger wrote:
> > >    > > +   pdev = platform_device_register_simple("tpm_vtpm",  
> > vtpm_dev->dev_num,
> > >    > > +                      NULL, 0);
> > >    >
> > >    > This seems strange, something like this should not be creating
> > >    > platform_devices.
> > >    Should it be a misc_device then ?
> >
> > No. Check what other virtual devices are doing..
> 
> register_chrdev maybe?

?? that doesn't replace a platform_device

> > Except that isn't good enough - the IMA kernel side doesn't know that this
> > tpm is now acting as the 'main' 'default' TPM.
> 
> Hooking the vTPM to IMA requires another patch that I haven't shown since IMA
> namespacing isn't public yet. Basically we implement another ioctl() that is to
> be called before the clone() in order to 'reserve' a vtpm device pair for the
> calling process. During the clone() call IMA namespacing code can query the
> vTPM driver for a 'reserved' device pair. Hooking IMA up after the clone() may
> also work but in case of docker/golang it's better to do this before since the
> language libraries do a lot after the clone automatically.

That sounds very complicated, wouldn't you just specify the TPM index to use
in the IMA namespace when it is created?

> So here things aren't so clear to me, either. Sysfs should really only show the
> devices that are relevant to a container, but it seems to show a lot
> more than

I think what you are missing is that nobody uses mainline containers
for the kind of strong isolation you are thinking about. Out-of-tree
patches are used by those people and, as I understand it, they cover
all these issues.

So, in mainline, the correct thing to do is nothing, and realize that
people who would care about pcr isolation between containers won't run
mainline anyhow. Work with the out-of-tree people to make sure things
work properly until they get the other bits in mainline.

At least that is my impression of the state of affairs, someone more
involved may know better.

> > The huge downside to using a master side dev node is that these things
> > will leak. Killing the vtpm daemon will not clean up the slave
> > interface and another command and sysadmin interaction will be needed
> > to sort out the inevitable mess.
> 
> This is a scenario that works, though.

So you already implemented the same semantics as I talked about, a clean
up on close?

Then just return the fd like I said.

auto-delete a master char dev on close is a very strange API, don't do
that.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
