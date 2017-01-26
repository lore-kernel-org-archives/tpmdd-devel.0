From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Fixing TPM_RC_CONTEXT_GAP
Date: Wed, 25 Jan 2017 17:04:39 -0800
Message-ID: <1485392679.2473.51.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

TPM_RC_CONTEXT_GAP is an error the TPM is allowed to return when the
counter that ensures the uniqueness of context saved sessions
overflows.  The solution, according to the manual, is to re-load and
save the oldest session because that frees the old value causing the
gap.

This leads to a problem: we have to have access to the session context
to pull this trick, and that means we have to disallow TPM users from
calling ContextSave on a session otherwise they could DoS us by
inducing an unremediable TPM_RC_CONTEXT_GAP error (simply by keeping
the saved session and never loading it).  We could pull other tricks,
like emulating ContextSave and ContextLoad for sessions, but I can't
actually see why any legitimate application would want to save a
session context at all.

Unless anyone can see a way around this particular problem, I'll go
ahead and implement it in the next iteration of the session exhaustion
patch.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
