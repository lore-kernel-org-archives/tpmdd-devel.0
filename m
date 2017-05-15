From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add "shutdown" to "struct class".
Date: Mon, 15 May 2017 16:17:36 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B641D8F02@hasmsx108.ger.corp.intel.com>
References: <20170512233203.23659-1-joshz@google.com>
	<5B8DA87D05A7694D9FA63FD143655C1B641D7A27@hasmsx108.ger.corp.intel.com>
	<20170515155110.GC3433@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170515155110.GC3433-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> 
> On Sat, May 13, 2017 at 12:43:11PM +0000, Winkler, Tomas wrote:
> > > The TPM class has some common shutdown code that must be executed
> > > for all drivers. This adds some needed functionality for that
> >
> > The issue with this is, that on some platforms the only storage can be
> > eMMC and TPM is using it,. It has to be ensured that the storage
> > device won't go down before TPM2_shutdown is called.  And there is no
> > direct device hierarchy to ensure an orderly shutdown.
> 
> Something will have to use the new device links stuff to define that
> dependency, but that seems unrelated to this patch?


Yep, it's not directly related to this specific patch, this is more relevant particularly to TPM2_shutdown. 

> Can the kernel really shut down the eMMC while the hidden platform stuff is
> still possibly using it? Goofy..

eMMC is single headed, so yes that can happen.

Tomas


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
