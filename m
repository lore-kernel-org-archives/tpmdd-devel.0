From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] Add "shutdown" to "struct class".
Date: Thu, 1 Jun 2017 20:07:21 +0300
Message-ID: <20170601170721.uyjhkjtuey6p3gmt@intel.com>
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
> On Tue, May 30, 2017 at 12:54 AM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Thu, May 25, 2017 at 04:20:30PM -0700, Josh Zimmerman wrote:
> >> The TPM class has some common shutdown code that must be executed for
> >> all drivers. This adds some needed functionality for that.
> >>
> >> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >
> > Does not apply yet to security-next (ancestor missing).
> 
> Hm, it applied cleanly for me to the "next" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git.
> Are you referring to something else with "security-next"?

Hmm...

I get 

$ git am -3 ~/Downloads/v5-2-2-Add-shutdown-to-struct-class-..patch 
Applying: Add "shutdown" to "struct class".
error: patch fragment without header at line 7: @@ -407,6 +408,7 @@ struct class {
error: could not build fake ancestor
Patch failed at 0001 Add "shutdown" to "struct class".
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

My tree rebased to latest security/next

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
