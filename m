From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 10:27:41 -0600
Message-ID: <20161005162741.GA18636@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
	<20161002101755.GA25844@intel.com>
	<20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<20161003124836.GE9990@intel.com>
	<20161004051946.GA10572@intel.com>
	<20161004164738.GA17149@obsidianresearch.com>
	<20161005100234.GA20851@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005100234.GA20851-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 05, 2016 at 01:02:34PM +0300, Jarkko Sakkinen wrote:

> I'll repeat my question: what worse can happen than returning -EPIPE?  I
> though the whole rw lock scheme was introduced just for this purpose.

I thought I explained this, if device_del is moved after ops = null
then if sysfs looses the race it will oops the kernel. device_del hard
fences sysfs.

> Why there's even that branch in tpm-dev.c if it's so bad to let it
> happen?

Because cdev_del and device_del do not guarentee that the cdev is
fenced. They just prevent new calls into open(). So the branch in
tpm-dev.c is necessary to avoid a kernel oops if user space holds the
fd open across unregister.

It is the same sitatuion you identified in the securityfs discussion -
user space holding the fd open across a driver unregister.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
