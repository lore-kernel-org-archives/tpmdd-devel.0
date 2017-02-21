From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: declare tpm2_get_pcr_allocation() as
	static
Date: Tue, 21 Feb 2017 08:17:11 +0200
Message-ID: <20170221061659.dssonwv44q35j5y4@intel.com>
References: <20170215180228.25650-1-jarkko.sakkinen@linux.intel.com>
	<20170217102427.427h3qxwajocilji@intel.com>
	<58ABD542.1040704@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58ABD542.1040704-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 21, 2017 at 11:20:58AM +0530, Nayna wrote:
> 
> 
> On 02/17/2017 03:54 PM, Jarkko Sakkinen wrote:
> > On Wed, Feb 15, 2017 at 08:02:28PM +0200, Jarkko Sakkinen wrote:
> > > There's no need to export tpm2_get_pcr_alloation() because it is only
> > > a helper function for tpm2_auto_startup(). For the same reason it does
> > > not make much sense to maintain documentation for it.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > Nayna, does this look good to you?
> 
> Oops !! I don't know how it is missed. Sorry for that..My internet
> connection wasn't working since my Friday evening and just started working
> yesterday. So, probably somewhere got this missed and saw it today
> 
> It is fine and I already see it in PULL request. So, Thanks !!
> 
> Thanks & Regards,
>    - Nayna

It's fine, just a minor glitch that I wanted to fix before it goes
to release...

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
