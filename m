From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle isolation to
 tpm spaces
Date: Fri, 20 Jan 2017 15:23:31 +0200
Message-ID: <20170120132331.74dixmuj6htzgr4z@intel.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
	<1484752186.2717.16.camel@HansenPartnership.com>
	<20170119115812.vqaoxv77mgnuq43h@intel.com>
	<1484827883.3140.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484827883.3140.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 19, 2017 at 07:11:23AM -0500, James Bottomley wrote:
> On Thu, 2017-01-19 at 13:58 +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 18, 2017 at 10:09:46AM -0500, James Bottomley wrote:
> > > sessions should be isolated during each instance of a tpm space. 
> > >  This means that spaces shouldn't be able to see each other's 
> > > sessions and also when a space is closed, all the sessions 
> > > belonging to it should be flushed.
> > > 
> > > This is implemented by adding a session_tbl to the space to track 
> > > the created session handles.  Sessions can be flushed either by not
> > > setting the continueSession attribute in the session table or by an
> > > explicit flush.  In the first case we have to mark the session as
> > > being ready to flush and explicitly forget it if the command 
> > > completes successfully and in the second case we have to intercept 
> > > the flush instruction and clear the session from our table.
> > 
> > You could do this without these nasty corner cases by arbage 
> > collecting when a command emits a new session handle.
> 
> I could for this patch set.  However, the global session accounting RFC
> requires strict accounting, because it needs to know exactly when to
> retry a command that failed because we were out of sessions and because
> we don't want to needlessly evict a session if there was one available
> which we didn't see because of lazy accounting.  It would be a lot of
> churn to do it lazily in this patch set and then switch to strict in
> that one, so I chose to account sessions strictly always.

Lazy is kind of ambiguous word so I'll have to check that we have same
definition for it in this context.

I'm talking about not trying to detect if something gets deleted. When
something gets created you would go through the global list of sessions
and check if it is used. If so, it must be that the session was deleted
at some point.

Your argument is that in this scheme sometimes there might be a session
marked as "reserved" but it is in fact free. This might lead to useless
eviction. Am I correct?

My argument is that the lazy scheme is more generic (does not require
special cases). As a subsystem maintainer I tend to be more fond of that
kind of solutions. Having special cases raises questios like (for
example):

1. What if standard gets added something that does not fall into the
   current set of special cases? You never know.
2. What about vendor specific commands? The lazy scheme is compatible
   with them. The standard does not put any kind of constraints for
   vendor specific commands.

You could solve the problem you are stating by getting the full the
list of alive sessions with CAP_HANDLES and mark dangling sessions
as free.

PS. I've started to think that maybe also with sessions it is better
to have just one change that implements full eviction like we have
for transient objects after seeing your breakdown. I'm sorry about
putting you extra trouble doing the isolation only patch. It's better
to do this right once...

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
