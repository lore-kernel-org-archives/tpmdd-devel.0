From: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Tue, 5 Jan 2016 09:43:04 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724DA58784A8@EXCH2010B.sit.fraunhofer.de>
References: <20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org>
	<20151224114241.GA5119@intel.com> <n5h1rj$nkb$1@ger.gmane.org>
	<20160102203957.GA19490@obsidianresearch.com>
	<20160103135346.GA4047@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA5877E95@EXCH2010B.sit.fraunhofer.de>,
	<20160104181915.GA15908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160104181915.GA15908-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ken, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> > I'd like to get a list of people interested to work on some conceptual stuff
> > first though.
> 
> I don't care in what process the patches are implemented. I can review
> and test patches once there is something real to be evaluated.

Understood, you and Mimi do not want to talk concept without code.
However, I'd prefer to have some things steightened out conceptually, before
running in wrong directions for weeks. Therefore, if anyone is willing to
argue some design choices with me, I appreciate the help.

> > Some concrete questions that originate from my personal unfamiliarity with
> > kernel coding that would influence my getting started concepting this thing:
> >
> > - fd-duplication (dup(), fork(), ...): How to handle objects in this case ? It is
> > possible to duplicate DH_HANDLES, but not SESSION_HANDLES.
> 
> What you are saying does not match the semantics of these system calls.
> They do not duplicate data. Nothing needs to be done.
> 
> > It would be easiest to disallow dup() and fork(), similar to CLOEXEC but rather
> > "CLOFORK". Is this possible ? What are alternatives ?
> >
> > - Similarly, can/shall we allow fd-passing ? In context of the previous question,
> > is it possible to force closing of fd in the original process when passing the fd ?
> > What alternatives would there be ?
> >
> > - What would be preferred, a layered approach vs a hook-table based approach ?
> > What's generally used in kernel modules ?
> 
> This discussion about fd's is way out of context.

Ok let me iterate a little about this point and why it's important.

The current semantics of a ResoureManager does not include the concept of
dup()'ing application contexts or concurrent access to session or key objects
from different application contexts. The reason is pretty simple; (i) there is
no real need and (ii) it is hard to get concurrent access to sessions right,
since they are stateful. When one context performs a change on a session object
the other context would be out of sync. Accordingly, in the ResourceManager
semantics a session (and also key) object are always bound to a single context
only.

In order to keep these semantics also for an in-kernel ResourceManager, I saw
specifically problems with the fork() and dup() calls. So my immediate reaction
was to question if they can be disallowed for the tpm-fd.

Side-Question: how does the current tpm-fd handle fork() and dup() ? Since it is
single access only as well ?

If disallowing is indeed impossible, the question for constructive alternatives
from other (similar) kernel-drivers would be interesting. I could imagine to
e.g. keep all objects bound to the original tpm-fd only and have the fork()'ed /
dup()'ed tpm-fd be completely blank with regards to associated objects. This may
also work.

The question of "How do I continue using tpm-fd contexts in the second thread"
and "How to handle fd-passing" remain unanswered though. Perhapes in the
passing case, one could empty the original context and move all objects to the
new tpm-fd context ? Would also provide a solution for the first question.

Comments highly welcome.

Thanks,
Andreas

------------------------------------------------------------------------------
