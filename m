From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Mon, 8 May 2017 11:16:56 -0700
Message-ID: <CAHSjozCaWoQuQiWJ59_UyXnrnq=eh4sucLGgJ=0me6A0NHYsBA@mail.gmail.com>
References: <20170427182659.403-1-joshz@google.com>
	<20170428121226.7xnpfbxcjszrnz5d@intel.com>
	<20170428152748.GA32017@obsidianresearch.com>
	<CAHSjozC=1GgKazv5m19X6Oe321+mkMUFCfFBQ=_c7kPQ-WESDA@mail.gmail.com>
	<20170428184325.GA15327@obsidianresearch.com>
	<CAHSjozDRHbuHD6dPfTGMnF4j66hPV-_WiD22y5WRpawPFMQmfQ@mail.gmail.com>
	<20170428213905.GA19326@obsidianresearch.com>
	<CAJZ5v0iFkLfmeQgZyQDoKF42=RQw6q_GdK3fLgwdC9_mDbJKjg@mail.gmail.com>
	<20170428221648.GA25935@obsidianresearch.com>
	<CAHSjozCROVK=ca8tO+zNC+JD3a0+hQ-54AE7jGndrrs2nG1O1A@mail.gmail.com>
	<20170505224629.GA15229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170505224629.GA15229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hm, according to include/linux/pm.h,

    * It is allowed to unregister devices while the above callbacks are being
    * executed.  However, a callback routine MUST NOT try to
unregister the device
    * it was called for, although it may unregister children of that device (for
    * example, if it detects that a child was unplugged while the system was
    * asleep).

So, it seems if we want to add shutdown to class->pm, we'll need to do
the refactoring for sysfs now to avoid the implicit lock in order to
safely NULL out chip->ops. (Otherwise, I believe we'd need to
unregister.)\\

I'll start work on that, but I wanted to send this email first to
double-check that my understanding was correct and I wasn't missing an
easier path.

Thanks,
Josh


On Fri, May 5, 2017 at 3:46 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, May 05, 2017 at 03:39:01PM -0700, Josh Zimmerman wrote:
>
>> I've seen some reference to the existing `suspend` method as being
>> legacy. e.g., drivers/base/power/main.c:__device_suspend:
>
> I think this is because class->pm is the modern way to do
> class->suspend, not because class methods are legacy.
>
>> In addition, it's not clear to me that the tpm codebase is using
>> class->suspend right now; it looks like for the most part each
>> device
>
> Yes, but that doesn't mean this is the right way to do things, it just
> means this old code hasn't really been updated. The tpm subsystem was
> a total mess just a few years ago, not everything is cleaned up yet..
>
> eg it would probably make much more sense to hook class->pm to do
> tpm_pm_suspend rather than have each driver include the same
> STATIC_DEV_PM_OPS.
>
>> Is there some reason a similar approach of having each driver type
>> register its own shutdown function pointer (that might just all be the
>> same function, much like tpm_pm_suspend) would not be acceptable?
>
> Now that we have so many tpm drivers it is a very good idea not to
> introduce boilerplate into every driver, we should be going the other
> way :)
>
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
