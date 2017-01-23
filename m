From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Mon, 23 Jan 2017 15:57:49 -0700
Message-ID: <20170123225749.GB21744@obsidianresearch.com>
References: <20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
	<20170117205933.GA9604@obsidianresearch.com>
	<20170117230053.GA16227@apronin>
	<20170117232207.GA12127@obsidianresearch.com>
	<20170123200246.GA63214@apronin>
	<20170123203901.GA13029@obsidianresearch.com>
	<20170123221929.GA75281@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170123221929.GA75281@apronin>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, semenzato-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 02:19:29PM -0800, Andrey Pronin wrote:

> Simplifying to class vs driver handlers, it checks class suspend
> first. And if it exists, calls it. Otherwise, it calls driver
> suspend. So, it's "either-or", not "first one, then another".
> Unless I'm missing something obvious, of course...

I belive the typical approach is that the class handler then chains to
the driver handler at the proper point in the shutdown flow. (ie this
way class code can execute before and after the driver power
management method)

> if it is needed. Even if we reverse the order and do "driver
> first, and iff it doesn't exist, then class", we'd still
> need to create and export 'tpm_shutdown' for drivers to use

The purpose of the driver shutdown would be to shutdown the bus, not
the chip. So it would be called with ops already disabled by the core
code, there is never a reason for a bus driver to call tpm_shutdown.

> We can go the register_reboot_notifier() route. Which already
> explicitly supports priorites for those notify handlers, so one

This is probably OK too, but it just feels weird to ignore the basic
core code pattern and fall back to notifiers, but I understand it can
be hard to make those changes.. But still worth at least one attempt,
IMHO.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
