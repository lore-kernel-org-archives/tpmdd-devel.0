From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 2/2] Add "shutdown" to "struct class".
Date: Wed, 31 May 2017 16:18:11 -0600
Message-ID: <20170531221811.GA12603@obsidianresearch.com>
References: <CAHSjozD_NjH0Ta=ELCOqG6ezX=qgteumKBnN2ceqE4ty2FaAZQ@mail.gmail.com>
	<20170530075419.766mlyxomxrzbxz6@intel.com>
	<CAHSjozBDNX-bEQGjUtjqJzG_kuSWgxmrjPmdA=nfYhr1DFGgYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozBDNX-bEQGjUtjqJzG_kuSWgxmrjPmdA=nfYhr1DFGgYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 31, 2017 at 03:01:13PM -0700, Josh Zimmerman wrote:

> >> +               if (dev->class && dev->class->shutdown) {
> >> +                       if (initcall_debug)
> >> +                               dev_info(dev, "shutdown\n");
> >> +                       dev->class->shutdown(dev);
> >> +               }
> >>                 if (dev->bus && dev->bus->shutdown) {
> 
> I just looked again at this line, which I am suddenly skeptical of. Is there
> any reason to run _both_ the class and the bus or driver shutdown
> functions? In the code as-is, only the bus or the driver function will
> execute. Right now, this patch will change that behavior. I suspect I
> should just add the appropriate "else", but I'm not sure if there is
> some reason to prefer the behavior as implemented in this version of
> the patch.

Yes, I think the else should be there.

>From what I could tell, the intent is that the most generic will then
call the least generic in the proper order, eg tpm class shutdown full
should then call bus and driver shutdown, if they are defined.

This allows each step to inject some action both before and after
calling the lower level steps, and follows the same pattern used
elsewhere.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
