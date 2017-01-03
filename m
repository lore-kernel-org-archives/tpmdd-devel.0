From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 14:54:45 -0700
Message-ID: <20170103215445.GD29656@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<1483421218.19261.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483421218.19261.4.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 09:26:58PM -0800, James Bottomley wrote:

> OK, so I put a patch together that does this (see below). It all works
> nicely (with a udev script that sets the resource manager device to
> 0666):
> 
> jejb@jarvis:~> ls -l /dev/tpm*
> crw------- 1 root root  10,   224 Jan  2 20:54 /dev/tpm0
> crw-rw-rw- 1 root root 246, 65536 Jan  2 20:54 /dev/tpm0rm
> 
> I've modified the tss to connect to /dev/tpm0rm by default and it all
> seems to work.
> 
> The patch applies on top of your tabrm branch, by the way.

If we are making a new /dev/ node we should think more carefully about
the design.

- Do we need a cdev node for every chip? What about just '/dev/tpm' and
  we encode the chip number in the message. Since the exclusive
  locking is gone this is very doable.
- Should we get rid of the read/write protocol and use ioctl instead?
  As I understand it ioctl is more usable with seccomp and related
  schemes? I could see passing a TPM FD into a sandbox and wanting the
  sandbox only able to do do decrypt/encrypt operations, for instance.
- Something to identify tpm chips and help match key data with the
  proper chip.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
