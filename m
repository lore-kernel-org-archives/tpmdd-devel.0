From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Fri, 7 Oct 2016 20:10:39 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F6305@hasmsx108.ger.corp.intel.com>
References: <20161004164738.GA17149@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
	<20161004231057.GA20062@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
	<20161005171132.GE18636@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F54E9@hasmsx108.ger.corp.intel.com>
	<20161005211656.GA20920@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F561B@hasmsx108.ger.corp.intel.com>
	<20161006020748.GA17479@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F625A@hasmsx108.ger.corp.intel.com>
	<20161007191724.GA28795@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161007191724.GA28795-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
> 
> On Fri, Oct 07, 2016 at 02:24:59PM +0000, Winkler, Tomas wrote:
> 
> > So here I'm to say I'm sorry for misleading this, after all the doubts
> > I got back to debugging and traces.  One thing for a reason moving the
> > device_del, had really made the problem go away, but the real problem
> > was unbalance runtime_pm PUT/GET from the tpm_crb probe function.
> 
> Oh this is very good news, I'm glad this was resolved in crb!
> 
> Presumably the unbalanced put made the ref count go negative and the
> balanced get caused it to go to zero, so pm locking was basically totally
> broken? That would explain how an idle callback could run concurrently with
> transmit_cmd.

This is not due to locking and refcount, but similar. The usage_count went negative  and the idle callback kicked in from the pm work queue, and suspended the device.

> 
> Though a bit of a mystery why device_del had any impact? I'm still very
> unclear exactly how the child device effects the parent - and that seems like
> pretty important information going forward..

Yes, there is some dependency as if device_del is not called the idle callback doesn't kick in between send and receive and that was misleading.  I'm not sure but this could be due to scheduling of the pm worker, but I'm not sure.   In any case we hit the issue even w/o device_del if the device is exercise enough.  I will dig into that later.

Thanks
Tomas




------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
