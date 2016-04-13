From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix crash in tpm_tis deinitialization
Date: Wed, 13 Apr 2016 09:16:51 +0300
Message-ID: <20160413061651.GA6986@intel.com>
References: <1460390720-9509-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160411174037.GA371@obsidianresearch.com>
	<20160412042627.GA6608@intel.com>
	<20160412172655.GA5759@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160412172655.GA5759-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 12, 2016 at 11:26:55AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 12, 2016 at 07:26:27AM +0300, Jarkko Sakkinen wrote:
> > > This needs to be after ops is fenced, something like this.
> > 
> > I would appreciate a supporting argument.
> > 
> > I guess the argument here is that this will prevent user space from
> > issuing TPM commands after the shutdown command has been sent?
> 
> It prevents everything including the kernel from issuing a command
                         ^^^^^^^^^^^^^^^^^^^^

That lock is not used to exclude kernel access. Read lock is only taken
for the user space device in tpm-dev.c.

> after shutdown. The shutdown is sent as the last command and no other
> commands can follow it.
> 
> It doesn't make any sense to allow commands to follow shutdown.

I agree with this.

> Jason

/Jarkko

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
