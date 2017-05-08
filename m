From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Mon, 8 May 2017 12:24:15 -0600
Message-ID: <20170508182415.GA32332@obsidianresearch.com>
References: <20170428152748.GA32017@obsidianresearch.com>
	<CAHSjozC=1GgKazv5m19X6Oe321+mkMUFCfFBQ=_c7kPQ-WESDA@mail.gmail.com>
	<20170428184325.GA15327@obsidianresearch.com>
	<CAHSjozDRHbuHD6dPfTGMnF4j66hPV-_WiD22y5WRpawPFMQmfQ@mail.gmail.com>
	<20170428213905.GA19326@obsidianresearch.com>
	<CAJZ5v0iFkLfmeQgZyQDoKF42=RQw6q_GdK3fLgwdC9_mDbJKjg@mail.gmail.com>
	<20170428221648.GA25935@obsidianresearch.com>
	<CAHSjozCROVK=ca8tO+zNC+JD3a0+hQ-54AE7jGndrrs2nG1O1A@mail.gmail.com>
	<20170505224629.GA15229@obsidianresearch.com>
	<CAHSjozCaWoQuQiWJ59_UyXnrnq=eh4sucLGgJ=0me6A0NHYsBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozCaWoQuQiWJ59_UyXnrnq=eh4sucLGgJ=0me6A0NHYsBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, May 08, 2017 at 11:16:56AM -0700, Josh Zimmerman wrote:
> Hm, according to include/linux/pm.h,
> 
>     * It is allowed to unregister devices while the above callbacks are being
>     * executed.  However, a callback routine MUST NOT try to
> unregister the device
>     * it was called for, although it may unregister children of that device (for
>     * example, if it detects that a child was unplugged while the system was
>     * asleep).
> 
> So, it seems if we want to add shutdown to class->pm, we'll need to do
> the refactoring for sysfs now to avoid the implicit lock in order to
> safely NULL out chip->ops. (Otherwise, I believe we'd need to
> unregister.)\\
> 
> I'll start work on that, but I wanted to send this email first to
> double-check that my understanding was correct and I wasn't missing an
> easier path.

Like I said, if you guard shutdown with a 'if TPM2' then the sysfs
case cannot occur..

It eventually needs to be fixed for TPM1, but a TPM2 only first step
would be OK too.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
