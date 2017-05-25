From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Thu, 25 May 2017 10:06:16 -0700
Message-ID: <20170525170616.uvj2ql7faqnwzwoe@intel.com>
References: <20170515173438.13420-1-joshz@google.com>
	<20170525130930.GA16244@kroah.com>
	<CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 08:40:28AM -0700, Josh Zimmerman wrote:
> Thanks, Greg.
> 
> Greg, Jarkko: Do either of you you have any objections to me
> backporting these changes to 4.4 and 4.9? I'd like to make sure that
> at least the couple most recent LTS kernels have this patch. (I don't
> care so much about 4.1 as it'll be EOL'd this September, according to
> https://www.kernel.org/category/releases.html, but I can backport it
> to there as well if desired.)
> 
> Thanks,
> 
> Josh

Nope.

/Jarkko

> 
> On Thu, May 25, 2017 at 6:09 AM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> > On Mon, May 15, 2017 at 10:34:38AM -0700, Josh Zimmerman wrote:
> > > The TPM class has some common shutdown code that must be executed for
> > > all drivers. This adds some needed functionality for that.
> > >
> > > Usage example: 'tpm: Issue a TPM2_Shutdown for TPM2 devices.'
> > > (see https://patchwork.kernel.org/patch/9724919/ for v2).
> > >
> > > Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Given that the tpm code is going to need this, I recommend someone take
> > it through that tree:
> >
> > Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >
> > Otherwise, if you want me to take it, I can, but I doubt you want it in
> > my driver-core tree as that will not get merged to Linus until 4.13-rc1.
> >
> > thanks,
> >
> > greg k-h

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
