From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 6/6] tpm2: add session handle context
 saving and restoring to the space code
Date: Fri, 10 Feb 2017 08:11:18 -0800
Message-ID: <1486743078.2502.4.camel@HansenPartnership.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
	<20170208110713.14070-7-jarkko.sakkinen@linux.intel.com>
	<20170210085256.eqhnrmdug2fcz4ql@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170210085256.eqhnrmdug2fcz4ql-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-02-10 at 10:52 +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 08, 2017 at 01:07:08PM +0200, Jarkko Sakkinen wrote:
> > +		rc = tpm2_load_context(chip, space->session_buf,
> > +				       &offset, &handle);
> > +		if (rc == -ENOENT) {
> > +			/* load failed, just forget session */
> > +			space->session_tbl[i] = 0;
> 
> This is my only concern in this commit. Should we also in this case 
> just flush the space or not?

I elected not to.  If the handle is flushed by an external resource
manager, we get this event.  If the RM and the app agreed to release
the session handle, then flushing the space would be overkill because
it would destroy the client session, so simply removing the handle
works.  If the client tries to use the session again, it gets an error
and if it doesn't everything just works, which seems to be optimal.

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
