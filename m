From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm2: add session handle isolation to
 tpm spaces
Date: Fri, 20 Jan 2017 19:57:53 +0200
Message-ID: <20170120175753.dlysjpqn5tjlmx4b@intel.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
 <1484752186.2717.16.camel@HansenPartnership.com>
 <20170119115812.vqaoxv77mgnuq43h@intel.com>
 <1484827883.3140.7.camel@HansenPartnership.com>
 <20170120132331.74dixmuj6htzgr4z@intel.com>
 <1484923153.3011.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484923153.3011.15.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 20, 2017 at 09:39:13AM -0500, James Bottomley wrote:
> On Fri, 2017-01-20 at 15:23 +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 19, 2017 at 07:11:23AM -0500, James Bottomley wrote:
> > > On Thu, 2017-01-19 at 13:58 +0200, Jarkko Sakkinen wrote:
> > > > On Wed, Jan 18, 2017 at 10:09:46AM -0500, James Bottomley wrote:
> > > > > sessions should be isolated during each instance of a tpm 
> > > > > space.  This means that spaces shouldn't be able to see each 
> > > > > other's sessions and also when a space is closed, all the 
> > > > > sessions belonging to it should be flushed.
> > > > > 
> > > > > This is implemented by adding a session_tbl to the space to 
> > > > > track the created session handles.  Sessions can be flushed 
> > > > > either by not setting the continueSession attribute in the 
> > > > > session table or by an explicit flush.  In the first case we 
> > > > > have to mark the session as being ready to flush and explicitly 
> > > > > forget it if the command completes successfully and in the 
> > > > > second case we have to intercept the flush instruction and
> > > > > clear the session from our table.
> > > > 
> > > > You could do this without these nasty corner cases by arbage 
> > > > collecting when a command emits a new session handle.
> > > 
> > > I could for this patch set.  However, the global session accounting 
> > > RFC requires strict accounting, because it needs to know exactly 
> > > when to retry a command that failed because we were out of sessions 
> > > and because we don't want to needlessly evict a session if there 
> > > was one available which we didn't see because of lazy accounting. 
> > >  It would be a lot of churn to do it lazily in this patch set and 
> > > then switch to strict in that one, so I chose to account sessions
> > > strictly always.
> > 
> > Lazy is kind of ambiguous word so I'll have to check that we have 
> > same definition for it in this context.
> > 
> > I'm talking about not trying to detect if something gets deleted. 
> > When something gets created you would go through the global list of
> > sessions and check if it is used. If so, it must be that the session 
> > was deleted at some point.
> 
> That's my terminology too.  We're talking about lazy and strict
> tracking of session flushing.
> 
> > Your argument is that in this scheme sometimes there might be a
> > session marked as "reserved" but it is in fact free. This might lead
> > to useless eviction. Am I correct?
> 
> Yes, but not just that, it will also lead to over long waits because we
> can no longer wake the waiters the moment a session becomes free.
> 
> > My argument is that the lazy scheme is more generic (does not require
> > special cases). As a subsystem maintainer I tend to be more fond of 
> > that kind of solutions. Having special cases raises questios like 
> > (for example):
> > 
> > 1. What if standard gets added something that does not fall into the
> >    current set of special cases? You never know.
> > 2. What about vendor specific commands? The lazy scheme is compatible
> >    with them. The standard does not put any kind of constraints for
> >    vendor specific commands.
> 
> We rely on the assertion in the Manual that sessions are only returned
> in the handle area (as we do for objects).  We also rely on the
> guarantee that they're only destroyed by flush or continueSession being
> 0 in the session attributes.
> 
> If some mad vendor introduces a command that creates an object and
> doesn't return it in the handle area, we'll get screwed for both
> transient objects and sessions.  Sessions also could have issues if
> some mad vendor creates a command that flushes them outside of the
> above description.  That's why the standard has all these caveats about
> handle and session creation.  In theory the vendors are not allowed to
> violate them in their own commands ...
> 
> > You could solve the problem you are stating by getting the full the
> > list of alive sessions with CAP_HANDLES and mark dangling sessions
> > as free.
> 
> That's a command which produces a huge output ... I'd have to do it at
> the end of every input command to get the list of current handles ... I
> don't really think it's a better solution.
> 
> Let me describe the failure case with strict destruction accounting:
> supposing a mad vendor does introduce a command that flushes a session
> outside the standards prescribed way.  What happens is that it gets re
> -used before the TPM exhausts handles, and tpm2_session_chip_add will
> simply to replace what it currently has.  The only consequence is a
> single missed wakeup.  So even in the face of vendor failure, this
> scheme will work almost all of the time and it will always work better
> than a lazy scheme because the failure case gives us properties
> identical to the lazy case.  To make this case iron, we should get a
> failure on context save, so I can use that failure to drop the handle
> and I think the strict scheme will then always perform better than the
> lazy scheme (let's call it strict with lazy backup) will that suffice?
> 
> > PS. I've started to think that maybe also with sessions it is better
> > to have just one change that implements full eviction like we have
> > for transient objects after seeing your breakdown. I'm sorry about
> > putting you extra trouble doing the isolation only patch. It's better
> > to do this right once...
> 
> Well, I can put them back together again, but you could just apply them
> together as two patches ... they are now bisectable.

Sure forgot this last comment. It's really irrelevant. I'll reply
properly later on.

> James

/Jarkko
