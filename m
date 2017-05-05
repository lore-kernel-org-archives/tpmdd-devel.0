From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Fri, 5 May 2017 15:39:01 -0700
Message-ID: <CAHSjozCROVK=ca8tO+zNC+JD3a0+hQ-54AE7jGndrrs2nG1O1A@mail.gmail.com>
References: <20170427182659.403-1-joshz@google.com>
	<20170428121226.7xnpfbxcjszrnz5d@intel.com>
	<20170428152748.GA32017@obsidianresearch.com>
	<CAHSjozC=1GgKazv5m19X6Oe321+mkMUFCfFBQ=_c7kPQ-WESDA@mail.gmail.com>
	<20170428184325.GA15327@obsidianresearch.com>
	<CAHSjozDRHbuHD6dPfTGMnF4j66hPV-_WiD22y5WRpawPFMQmfQ@mail.gmail.com>
	<20170428213905.GA19326@obsidianresearch.com>
	<CAJZ5v0iFkLfmeQgZyQDoKF42=RQw6q_GdK3fLgwdC9_mDbJKjg@mail.gmail.com>
	<20170428221648.GA25935@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170428221648.GA25935-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Fri, Apr 28, 2017 at 3:16 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, Apr 28, 2017 at 11:45:53PM +0200, Rafael J. Wysocki wrote:
>
>> > The trouble is how to consistently get the machine shutdown callback
>> > from the driver core.
>>
>> It is not particularly clear what you mean here.  Care to elaborate?
>
> The request is to have a way for the generic tpm code to be called
> before struct device_driver -> shutdown()
>
> Presumably by adding shutdown() to struct class like the
> suspend/resume PM methods?

I've seen some reference to the existing `suspend` method as being
legacy. e.g., drivers/base/power/main.c:__device_suspend:

        if (dev->class) {
                if (dev->class->pm) {
                        info = "class ";
                        callback = pm_op(dev->class->pm, state);
                        goto Run;
                } else if (dev->class->suspend) {
                        pm_dev_dbg(dev, state, "legacy class ");
                        error = legacy_suspend(dev, state, dev->class->suspend,
                                                "legacy class ");
                        goto End;
                }
        }


In addition, it's not clear to me that the tpm codebase is using
class->suspend right now; it looks like for the most part each device
uses STATIC_DEV_PM_OPS and sets up the common suspend function to be
called independently. (this is based on grepping the tpm driver for
"suspend" so it's possible I'm missing some clever macro hacks, but I
did dig in somewhat thoroughly and don't believe I'm missing anything
like that)

Is there some reason a similar approach of having each driver type
register its own shutdown function pointer (that might just all be the
same function, much like tpm_pm_suspend) would not be acceptable?

Josh

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
