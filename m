From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] Add "shutdown" to "struct class".
Date: Mon, 5 Jun 2017 15:48:34 +0300
Message-ID: <20170605124834.e6myswydwvvscaao@intel.com>
References: <CAHSjozD_NjH0Ta=ELCOqG6ezX=qgteumKBnN2ceqE4ty2FaAZQ@mail.gmail.com>
	<20170530075419.766mlyxomxrzbxz6@intel.com>
	<CAHSjozBDNX-bEQGjUtjqJzG_kuSWgxmrjPmdA=nfYhr1DFGgYg@mail.gmail.com>
	<20170601170721.uyjhkjtuey6p3gmt@intel.com>
	<CAHSjozDaMwGspg=hhTGR7CUa+tMV7qC8FAssMKin9h_bFcysaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozDaMwGspg=hhTGR7CUa+tMV7qC8FAssMKin9h_bFcysaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

Does your patches in my tree if you try it yourself?

Very weird...

/Jarkko

On Fri, Jun 02, 2017 at 03:00:22PM -0700, Josh Zimmerman wrote:
> Quite strange. Here's what I see.
> 
> $ git pull
> Already up-to-date.
> $ git branch
>   master
> * next
> $ git am -3 /tmp/v6-0001-tpm-Issue-a-TPM2_Shutdown-for-TPM2-devices.patch
> Applying: tpm: Issue a TPM2_Shutdown for TPM2 devices.
> $ git am -3 /tmp/v6-0002-Add-shutdown-to-struct-class.patch  # This is
> identical to v5
> Applying: Add "shutdown" to "struct class".
> $ git status
> On branch next
> Your branch is ahead of 'origin/next' by 2 commits.
>   (use "git push" to publish your local commits)
> 
> nothing to commit, working tree clean
> $ git log --oneline | head -n 4
> 58410b1fef64 Add "shutdown" to "struct class".
> 84e311a15e94 tpm: Issue a TPM2_Shutdown for TPM2 devices.
> d68c51e0b377 Sync to mainline for security submaintainers to work against
> 08332893e37a Linux 4.12-rc2
> $ git remote -v
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
> (fetch)
> origin  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
> (push)
> Josh
> 
> 
> On Thu, Jun 1, 2017 at 10:07 AM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Wed, May 31, 2017 at 03:01:13PM -0700, Josh Zimmerman wrote:
> >> On Tue, May 30, 2017 at 12:54 AM, Jarkko Sakkinen
> >> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >> > On Thu, May 25, 2017 at 04:20:30PM -0700, Josh Zimmerman wrote:
> >> >> The TPM class has some common shutdown code that must be executed for
> >> >> all drivers. This adds some needed functionality for that.
> >> >>
> >> >> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >> >> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >
> >> > Does not apply yet to security-next (ancestor missing).
> >>
> >> Hm, it applied cleanly for me to the "next" branch of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git.
> >> Are you referring to something else with "security-next"?
> >
> > Hmm...
> >
> > I get
> >
> > $ git am -3 ~/Downloads/v5-2-2-Add-shutdown-to-struct-class-..patch
> > Applying: Add "shutdown" to "struct class".
> > error: patch fragment without header at line 7: @@ -407,6 +408,7 @@ struct class {
> > error: could not build fake ancestor
> > Patch failed at 0001 Add "shutdown" to "struct class".
> > The copy of the patch that failed is found in: .git/rebase-apply/patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> >
> > My tree rebased to latest security/next
> >
> > /Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
