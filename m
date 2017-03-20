From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: mark PM functions as
	__maybe_unused
Date: Mon, 20 Mar 2017 23:01:36 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B543B0620@hasmsx108.ger.corp.intel.com>
References: <20170320091755.1043811-1-arnd@arndb.de>
	<5B8DA87D05A7694D9FA63FD143655C1B543B032E@hasmsx108.ger.corp.intel.com>
	<CAK8P3a25sh0U=N9E1pWACL_9h7VBseUBX50WZe5rXMpNHY=GbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAK8P3a25sh0U=N9E1pWACL_9h7VBseUBX50WZe5rXMpNHY=GbA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> On Mon, Mar 20, 2017 at 1:11 PM, Winkler, Tomas
> <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> When CONFIG_PM_SLEEP is disabled, we get a warning about unused
> >> functions:
> >>
> >> drivers/char/tpm/tpm_crb.c:551:12: error: 'crb_pm_resume' defined but
> >> not used [-Werror=unused-function]
> >> drivers/char/tpm/tpm_crb.c:540:12: error: 'crb_pm_suspend' defined
> >> but not used [-Werror=unused-function]
> >>
> > Note that the runtime_pm functions are not affected by this issue the
> > macro SET_RUNTIME_PM_OPS is under CONFIG_PM. This patch does more
> than described.
> 
> Well, the problem is that there is an #ifdef that is wrong here as I tried to
> indicate:

Yep, I've taken a bit easy path here and reused the runtime function inside pm callbacks, unaware of the change in the 'ifdefs'
If I use drictly go_idle/cmd_ready  functions this will unclutter it. 

> >> We could solve this with more sophistated #ifdefs, but a simpler and
> >> safer way is to just mark them as __maybe_unused.
> 
> >> @@ -547,7 +546,7 @@ static int crb_pm_suspend(struct device *dev)
> >>       return crb_pm_runtime_suspend(dev);  }
> >
> > It's enough to
> > #endif /* CONFIG_PM */
> > #ifdef CONFIG_PM_SLEEP
> >> -static int crb_pm_resume(struct device *dev)
> >> +static __maybe_unused int crb_pm_resume(struct device *dev)
> >>  {
> >>       int ret;
> >>
> >> @@ -558,8 +557,6 @@ static int crb_pm_resume(struct device *dev)
> >>       return tpm_pm_resume(dev);
> >>  }
> >>
> >> -#endif /* CONFIG_PM */
> > And
> > #endif CONFIG_PM_SLEEP
> 
> This tends to cause other warnings half of the time, when both the runtime-
> pm and pm-sleep variants call into another function that becomes unused
> when both are disabled.

Then usually such functions  should be also under 'ifdef', but I understand your point in
some cases it might be not so straight forward.
The only reason against marking the function __maybe_unsed is  maybe the binary size.

I believe that  in this case the #ifdefs can be done correctly quite easily, 
but now I'm not against your solution as well, just maybe put some of this info to the commit message. 

Thanks
Tomas



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
