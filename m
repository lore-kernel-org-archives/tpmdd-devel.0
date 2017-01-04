From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 14:58:10 +0200
Message-ID: <20170104125810.3qkkfe72cnb76ige@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<1483421218.19261.4.camel@linux.vnet.ibm.com>
	<20170103215445.GD29656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170103215445.GD29656-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 02:54:45PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 02, 2017 at 09:26:58PM -0800, James Bottomley wrote:
> 
> > OK, so I put a patch together that does this (see below). It all works
> > nicely (with a udev script that sets the resource manager device to
> > 0666):
> > 
> > jejb@jarvis:~> ls -l /dev/tpm*
> > crw------- 1 root root  10,   224 Jan  2 20:54 /dev/tpm0
> > crw-rw-rw- 1 root root 246, 65536 Jan  2 20:54 /dev/tpm0rm
> > 
> > I've modified the tss to connect to /dev/tpm0rm by default and it all
> > seems to work.
> > 
> > The patch applies on top of your tabrm branch, by the way.
> 
> If we are making a new /dev/ node we should think more carefully about
> the design.
> 
> - Do we need a cdev node for every chip? What about just '/dev/tpm' and
>   we encode the chip number in the message. Since the exclusive
>   locking is gone this is very doable.

What about backwards compatiblity? Or would this be just for /dev/tpms?
We can consider this.

> - Should we get rid of the read/write protocol and use ioctl instead?
>   As I understand it ioctl is more usable with seccomp and related
>   schemes? I could see passing a TPM FD into a sandbox and wanting the
>   sandbox only able to do do decrypt/encrypt operations, for instance.

Are you suggesting that command/response transaction would be handled
by ioctl instead of read/write pair. Would make sense looking at how
read/write is managed now (it is more or less of a hack because it
actually is a transction).

> - Something to identify tpm chips and help match key data with the
>   proper chip.

Hey, here's what I propose. I take some of the ideas (not all there
have been so many) and bake a v2 of the RFC. Lets see where we are
at then. I won't add any reviewed/tested-by's before we are in the
same line with "big ideas" nor do I create a non-RFC patch set.

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
