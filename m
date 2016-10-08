From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Sat, 8 Oct 2016 13:47:38 +0300
Message-ID: <20161008104738.GA6825@intel.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F625A-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 07, 2016 at 02:24:59PM +0000, Winkler, Tomas wrote:
> So  here I'm to say I'm sorry for misleading this, after all the
> doubts I got back to debugging and traces.  One thing for a reason
> moving the device_del, had really made the problem go away,  but the
> real  problem was unbalance runtime_pm PUT/GET from the tpm_crb probe
> function.  I will post the fixed patch, of course, this one should be
> dropped.  In any case,  and this is not just to keep my ego up, that
> calling to the tom stack with unutilized dev is not healthy and we
> should look for that. 

Great. I'll test the fix once it's available.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
