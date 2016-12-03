From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: use get_unaligned_be32 unaligned
	buffer access.
Date: Sat, 3 Dec 2016 17:30:28 +0200
Message-ID: <20161203153028.3xaqkamutio5gwgs@intel.com>
References: <1479899094-9486-1-git-send-email-tomas.winkler@intel.com>
	<20161124133400.5dziisshpxqewkh2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161124133400.5dziisshpxqewkh2-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hey,

On Thu, Nov 24, 2016 at 03:34:00PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 23, 2016 at 01:04:54PM +0200, Tomas Winkler wrote:
> > Use get_unaligned_be32 as b32_to_cpu doesn't work correctly on
> > all platforms for unaligned access.
> > 
> > The fix doesn't cover all the cases as also some cast
> > structures have members on unaligned addresses.
> > 
> > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This looks good to me with the exceptio that was pointed out by Jason.
> CC the next version to the linux-security-module. I talked with James
> about this at LPC and since this list does not have too many active
> reviewers it makes sense to cycle all the non-trivial changes through
> that list.

Are you planning to send an updated version of this. Should be a
no-brainer to apply.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
