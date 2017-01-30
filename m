From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fixing TPM_RC_CONTEXT_GAP
Date: Sun, 29 Jan 2017 19:33:13 -0500
Message-ID: <o6m1k4$qhp$1@blaine.gmane.org>
References: <1485392679.2473.51.camel@linux.vnet.ibm.com>
	<o6gf96$jgf$1@blaine.gmane.org>
	<20170129152518.ddeqk257prml5cna@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170129152518.ddeqk257prml5cna-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 1/29/2017 10:25 AM, Jarkko Sakkinen wrote:
>
> We should probably block the following from /dev/tpms0 by default:
>
> 1. ContextLoad for sessions.
> 2. ContextSave for sessions.
> 3. Vendor specific commands.

This is reasonable to me.  The only vendor specific commands I currently 
know of are for low level device configuration.  It's done in OEM 
manufacturing and then locked.

Eventually, we'll want to block extends to certain PCRs.  E.g., the IMA 
PCR (10) should be accessibly to the kernel but not user space.





------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
