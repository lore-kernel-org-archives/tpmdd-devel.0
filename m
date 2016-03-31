From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: cleanup tpm_tis_remove()
Date: Thu, 31 Mar 2016 13:17:13 +0300
Message-ID: <20160331101713.GB20686@intel.com>
References: <1459419087-20487-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160331101536.GA20686@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160331101536.GA20686-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 31, 2016 at 01:15:36PM +0300, Jarkko Sakkinen wrote:
> Christophe,
> 
> On Thu, Mar 31, 2016 at 01:11:27PM +0300, Jarkko Sakkinen wrote:
> > Created a local variable for the register in order to clean up
> > experession where TPM_GLOBAL_INT_ENABLE is cleared. This expression is
> > horrible to read and makes changing the function uncomfortable because
> > like easily surpass 80 characters.
> 
> Can you test this patch your hardware and reply with Tested-by tag if it
> does? I can then update your iobase patch to apply on top of this.
> 
> I thought it was better idea to simplify the expression a little bit
> than make it even worse mess.

And yes  I'll fix all the typos in the commit msg in this patch before
applying it :)

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
