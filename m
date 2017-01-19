From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle isolation to
 tpm spaces
Date: Thu, 19 Jan 2017 07:11:23 -0500
Message-ID: <1484827883.3140.7.camel@HansenPartnership.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
	<1484752186.2717.16.camel@HansenPartnership.com>
	<20170119115812.vqaoxv77mgnuq43h@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170119115812.vqaoxv77mgnuq43h-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-19 at 13:58 +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 18, 2017 at 10:09:46AM -0500, James Bottomley wrote:
> > sessions should be isolated during each instance of a tpm space. 
> >  This means that spaces shouldn't be able to see each other's 
> > sessions and also when a space is closed, all the sessions 
> > belonging to it should be flushed.
> > 
> > This is implemented by adding a session_tbl to the space to track 
> > the created session handles.  Sessions can be flushed either by not
> > setting the continueSession attribute in the session table or by an
> > explicit flush.  In the first case we have to mark the session as
> > being ready to flush and explicitly forget it if the command 
> > completes successfully and in the second case we have to intercept 
> > the flush instruction and clear the session from our table.
> 
> You could do this without these nasty corner cases by arbage 
> collecting when a command emits a new session handle.

I could for this patch set.  However, the global session accounting RFC
requires strict accounting, because it needs to know exactly when to
retry a command that failed because we were out of sessions and because
we don't want to needlessly evict a session if there was one available
which we didn't see because of lazy accounting.  It would be a lot of
churn to do it lazily in this patch set and then switch to strict in
that one, so I chose to account sessions strictly always.

> When a session handle is created check if any of the spaces contain 
> it and remove from the array. No special cases needed.
> 
> This will render the need to do any kind of interception whatsoever
> unneeded.

It can be done either way for these two patches, but I think, for the
reason above, it should begin life as it will go on (i.e. strict
accounting).  It's not that much extra code to do it and it's easier to
follow the flow of the three patches.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
