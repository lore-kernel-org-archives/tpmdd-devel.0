From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/4] Implement driver for supporting
 multiple emulated TPMs
Date: Thu, 21 Jan 2016 10:42:43 -0700
Message-ID: <20160121174243.GD3064@obsidianresearch.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
	<1452787318-29610-4-git-send-email-stefanb@us.ibm.com>
	<20160119235107.GA4307@obsidianresearch.com>
	<201601201439.u0KEdFao027907@d03av05.boulder.ibm.com>
	<20160121011701.GA20361@obsidianresearch.com>
	<201601210301.u0L31h5r012187@d03av03.boulder.ibm.com>
	<20160121032115.GA26266@obsidianresearch.com>
	<201601210356.u0L3uP1n029818@d03av05.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201601210356.u0L3uP1n029818-3MP/CPU4Muo+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
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

On Wed, Jan 20, 2016 at 10:56:21PM -0500, Stefan Berger wrote:
> The IMA namespace is created as part of clone(). You cannot pass anything via
> clone(). So you either have to do it before or immediately after. If after is
> too later for whatever reason, you have to do it before.

Follow the pattern of something like the net ns.

clone creates an 'empty' IMA namespace. After clone the child waits
for the parent to complete its work.

The parent creates a new vtpm /dev/tpm1 in it's namespace

The parent does a kernel call to make tpm1 visiable in the child's
IMA namespace as tpm0. (eg look at the 'ip link set .. netns ..' kind
of scheme for inspiration)

Hook the tpm core's id to struct tpm_chip code into the IMA namespace
so that /dev/tpm0 and all other places actually access tpm1 when used
in the child's IMA namespace

The parent signals the child to continue to run. The child has a
/dev/tpm0 that is actually routed to /dev/tpm1. The child is prevented
from accessing other tpms.

> > I think what you are missing is that nobody uses mainline containers
> > for the kind of strong isolation you are thinking about. Out-of-tree
> > patches are used by those people and, as I understand it, they cover
> > all these issues.
> 
> ?? Out-of-tree patches?

Sorry, I don't recall the names of al lthe involved parties. lxr, and
there is a notable company whose name eludes me right now. I had a
very interesting discussion on this with James Bottomley at a
conference once. Maybe look up device namespaces and look at the
threads/etc on that for a clue what the status is?

> Basically you suggest to ignore the potential leaking between containers. Just
> register with sysfs ?

Ignore in the sense that mainline doesn't have the tools to address
the issue. If it is important to you then build out general capability
in mainline, don't hack it like this :)

Another approach would be to try and copy what netns does and link tpm
visibility through a IMA namespace (as described above) directly to
sysfs visibility - I have never looked at how that is done though :|

> > Then just return the fd like I said.
> 
> Any driver that can be used as an example ?

The stuff in include/linux/anon_inodes.h is used to do this, eg
a sequence of anon_inode_getfile, get_unused_fd_flags, fd_install
will create a file descriptor in the calling process associated with a
struct file_operations

> > auto-delete a master char dev on close is a very strange API, don't do
> > that.
> 
> What I called cleanup can be trigger by the vTPM closing /dev/vtpms%d, so the
> server-side. What is the master for you? /dev/vtpmx where we run the ioctls on?

Sorry, master/slave is the ptx nomenclature for this scheme. Master
would be your server side I think. 

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
