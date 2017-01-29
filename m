From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Fixing TPM_RC_CONTEXT_GAP
Date: Sun, 29 Jan 2017 17:25:18 +0200
Message-ID: <20170129152518.ddeqk257prml5cna@intel.com>
References: <1485392679.2473.51.camel@linux.vnet.ibm.com>
	<o6gf96$jgf$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <o6gf96$jgf$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 27, 2017 at 04:49:36PM -0500, Ken Goldman wrote:
> On 1/25/2017 8:04 PM, James Bottomley wrote:
> 
> > This leads to a problem: we have to have access to the session context
> > to pull this trick, and that means we have to disallow TPM users from
> > calling ContextSave on a session otherwise they could DoS us by
> > inducing an unremediable TPM_RC_CONTEXT_GAP error (simply by keeping
> > the saved session and never loading it).
> 
> I think it's perfectly acceptable to block applications from calling 
> context save for sessions.  I don't know of any use case that would 
> require it.
> 
> (There are definitely use cases for context save on transient objects, 
> but they don't have the replay / gap issue.)

We should probably block the following from /dev/tpms0 by default:

1. ContextLoad for sessions.
2. ContextSave for sessions.
3. Vendor specific commands.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
