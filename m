From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Suspend/Resume issue in 4.8-rc8
Date: Tue, 11 Oct 2016 14:41:22 +0300
Message-ID: <20161011114122.GA25108@intel.com>
References: <147608140340.2733.12285605928656228981@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147608140340.2733.12285605928656228981-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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

On Mon, Oct 10, 2016 at 02:36:43AM -0400, Genki Marshall wrote:
>   Hello,
> 
> On 4.8-rc8, I'm having an issue with laptop suspend/resume for the
> Chromebook Pixel (2015). Specifically:
> 
> When on commit 24532f7 on Linus's tree (latest commit at time of
> writing) I'm having the following issue happen consistently:
> 
> 1. Close lid.
> 2. Wait for CPU to wind down and laptop lid's light to go off.
> 3. Open lid.
> 4. Observe that the computer is booting from scratch.
> 
> I noticed that 4.8-rc7 was working fine. Bisecting, I found 0c54133 to
> be the commit at which this issue starts happening, which is a
> patch to drivers/char/tpm/tpm-interface.c .
> 
> I confirmed this is still relevant as I can proceed to checkout
> 24532f7 again, do a git revert 0c54133, recompile, and the issue no
> longer happens.
> 
> It's a very small patch. Looking through the code, it's strange, as it
> seems to use the tpm_pcr_read_dev() helper correctly (to my totally
> untrained eye).
> 
> In the version with 0c54133 _reverted_, when I make the values of 'rc'
> be printed, recompile, and then resume my laptop (which again, it does
> successfully), I see the values go like:
> 
>   rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE, 0);
>   /* rc == 30 here */
>   ...
>   rc = be32_to_cpu(cmd.header.out.return_code);
>   /* rc == 0 here */
> 
> So it returns 0 correctly as expected. But tpm_transmit_cmd() looks
> like it should do effectively the same thing (calling tpm_transmit()
> then calling be32_to_cpu()), and it would just be that rc == 0 right
> away. It started to be difficult to debug as I can't see the results
> of prints when resuming on the broken tree (as it goes straight to
> rebooting).
> 
> Anyway, I was advised on #kernel-newbies that at this point it would
> be best to just email in like this. Let me know if it would be helpful
> for me to answer/test anything.

The commit is not in 4.8:

jsakkine at jsakkine-mobl1 in ~/projects/tpm2/git/linux-torvalds
(master) 
$ git describe --contains 0c54133    
fatal: cannot describe '0c541332231e7957f23013e37f3720db33e7804c'

It's in fact part of my 4.9 PR:

https://lkml.org/lkml/2016/9/15/333

I think the issue is this:

http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7ddcdd8990e4783d09c7e86d90ccb4121

I've sent a PR containing this fix to James Morris but AFAIK he
hasn't yet pulled it so you either have to stick to 4.8 kernel or
apply this fix manually.

Hope this helps.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
