From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Wed, 25 Jan 2017 15:11:36 -0700
Message-ID: <20170125221136.GA713@obsidianresearch.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
	<20170124001918.GA29735@obsidianresearch.com>
	<20170124143600.siyhblj67qaatewi@intel.com>
	<20170124190707.GA9899@obsidianresearch.com>
	<20170125202137.7bsv7lptvpzl2fjz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170125202137.7bsv7lptvpzl2fjz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 10:21:37PM +0200, Jarkko Sakkinen wrote:

> There should be anyway someway to limit what commands can be sent but
> I understand your point.

What is the filter for?

James and I talked about a filter to create a safer cdev for use by
users. However tpms0 cannot be that 'safer' cdev - it is now the 'all
access' path.

I also suggested a filter in the kernel to ensure that the RM is only
passing commands it actually knows it handles properly. eg you would
filter out list handles. That is hardwired into the kernel, and does
not ge to be configured by user space.

> Would it make more sense to have a sysfs file for configuring the
> global filter that would get the data in the same format (list of
> 16-bit words)?

Probably not, then there is no way to escape the filter in userspace,
so some command just become impossible even for root. (And no,
something like tpm should not test CAP_ flags, that is putting
too much policy into the kernel)

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
