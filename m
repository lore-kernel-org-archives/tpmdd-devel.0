From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] tmp/tpm_crb: fix Intel PTT hw bug
	during idle state
Date: Sat, 8 Oct 2016 16:58:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F67DF@hasmsx108.ger.corp.intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
	<1475927979-23484-3-git-send-email-tomas.winkler@intel.com>
	<20161008125003.GB10317@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F6768@hasmsx108.ger.corp.intel.com>
	<20161008160006.GA25893@intel.com>
	<20161008164203.GB29734@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161008164203.GB29734-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> On Sat, Oct 08, 2016 at 07:00:06PM +0300, Jarkko Sakkinen wrote:
> 
> > Rather you it would be better not to use cmdReady/goIdle at all if
> > kernel is not compiled with CONFIG_PM.
> 
> It would be best practice to ensure the tpm is powered up no matter how the
> kernel is compiled.. The firmware may have left it in idle or something
> 
> FWIW, I broadly agree there is no need to put the device into idle on the error
> paths. It probably wasn't idle when the driver attached to it.

Actually, currently it is more common to have the device in the idle state, so in case a driver is not loaded for any reason  by the kernel, the platform won't leak power.
Thanks
Tomas


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
