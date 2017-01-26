From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Thu, 26 Jan 2017 07:18:49 -0800
Message-ID: <1485443929.2457.5.camel@HansenPartnership.com>
References: <1485236113.2534.69.camel@HansenPartnership.com>
	<1485236231.2534.71.camel@HansenPartnership.com>
	<20170126125151.32sky3tajp6zigpd@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170126125151.32sky3tajp6zigpd-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Thu, 2017-01-26 at 14:51 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 09:37:11PM -0800, James Bottomley wrote:
> > sessions are different from transient objects in that their handles
> > may not be virtualized (because they're used for some hmac
> > calculations).  Additionally when a session is context saved, a
> > vestigial memory remains in the TPM and if it is also flushed, that
> > will be lost and the session context will refuse to load next time, 
> > so the code is updated to flush only transient objects after a 
> > context save.  Add a separate array (chip->session_tbl) to save and 
> > restore sessions by handle.  Use the failure of a context save or 
> > load to signal that the session has been flushed from the TPM and 
> > we can remove its memory from chip->session_tbl.
> > 
> > Sessions are also isolated during each instance of a tpm space. 
> >  This means that spaces shouldn't be able to see each other's 
> > sessions and is enforced by ensuring that a space user may only 
> > refer to sessions handles that are present in their own chip
> > ->session_tbl.  Finally when a space is closed, all the sessions 
> > belonging to it should be flushed so the handles may be re-used by
> > other spaces.
> > 
> > Signed-off-by: James Bottomley <
> > James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> 
> I'm wondering if you ever need more than two sessions at once? If we
> would limit the number of sessions to that you could probably 
> simplify a lot.

Three seems to be the agreed maximum: hmac authority, parameter
encryption and command audit.

I'll fix up the rest

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
