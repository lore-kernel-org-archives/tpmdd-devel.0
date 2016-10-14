From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Suspend/Resume issue in 4.8-rc8
Date: Fri, 14 Oct 2016 14:53:15 +0300
Message-ID: <20161014115315.GB17736@intel.com>
References: <147608140340.2733.12285605928656228981@localhost.localdomain>
	<20161011114122.GA25108@intel.com>
	<147642134073.20066.15696073460683830578@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147642134073.20066.15696073460683830578-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Genki Marshall <genki-pL6Mir/PLNc@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 14, 2016 at 01:02:20AM -0400, Genki Marshall wrote:
> Quoting Jarkko Sakkinen (2016-10-11 07:41:22)
> > The commit is not in 4.8:
> >
> > jsakkine at jsakkine-mobl1 in ~/projects/tpm2/git/linux-torvalds
> > (master)
> > $ git describe --contains 0c54133
> > fatal: cannot describe '0c541332231e7957f23013e37f3720db33e7804c'
> >
> > It's in fact part of my 4.9 PR:
> >
> > https://lkml.org/lkml/2016/9/15/333
> 
> Ah, I see, apologies. So, it is/was in the range between v4.8-rc8 and
> Linus's tree's HEAD and I mixed the two when I was looking into it.
> 
> > I think the issue is this:
> >
> > http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7ddcdd8990e4783d09c7e86d90ccb4121
> >
> > I've sent a PR containing this fix to James Morris but AFAIK he
> > hasn't yet pulled it so you either have to stick to 4.8 kernel or
> > apply this fix manually.
> >
> > Hope this helps.
> 
> It does very much, thanks. I applied the patch and it resolves the
> issue on my machine.

Good to hear!

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
