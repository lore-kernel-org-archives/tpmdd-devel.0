From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Mon, 30 Jan 2017 14:14:37 -0800
Message-ID: <1485814477.2518.30.camel@HansenPartnership.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
	<1485563558.3229.41.camel@HansenPartnership.com>
	<20170129213957.zx6v6g42kwcabc6y@intel.com>
	<1485729418.2491.10.camel@HansenPartnership.com>
	<20170130214526.56e4ai2k6zhzvgy4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170130214526.56e4ai2k6zhzvgy4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Mon, 2017-01-30 at 23:45 +0200, Jarkko Sakkinen wrote:
> On Sun, Jan 29, 2017 at 02:36:58PM -0800, James Bottomley wrote:
[...]
> > > 2. Can it really return both TPM_RC_HANDLE and
> > > TPM_RC_REFERENCE_H0? 
> > 
> > Yes, it seems that a session that doesn't exist (because it's been
> > flushed) then it returns TPM_RC_REFERNCE_H0, but if the context has 
> > a sequence mismatch (because it's been flushed and reloaded) then 
> > we get TPM_RC_HANDLE.
> > 
> > James
> 
> If it is flushed, wouldn't you just get TPM_RC_REFERENCE_H0 when you 
> try to TPM2_ContextLoad? The "and reloaded" does not make sense to 
> me. Once a session is flushed it cannot be reloaded.
> 
> Maybe you meant to say "beause it's been saved and reloaded"? That 
> would make more sense and fits better what I see in the Commands 
> specification.

I mean if you load a prior context instead of the current one for an
existing handle, effectively a replay, you get TPM_RC_HANDLE.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
