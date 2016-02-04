From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: About devm_ioremap_resource()
Date: Wed, 3 Feb 2016 17:31:08 -0700
Message-ID: <20160204003108.GA26123@obsidianresearch.com>
References: <20160203225519.GA8647@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203225519.GA8647-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 03, 2016 at 02:55:19PM -0800, Jarkko Sakkinen wrote:
> Hi
> 
> I have couple of concerns with tpm_crb changes made for 4.5:
> 
> * I used devm_ioremap_nocache() to disable WB. This does not
>   matter when one has ACPI start as it goes through SMM and caches are
>   flushed. It might be a problem with a CRB start only TPM device. How does
>   devm_ioremap_resource address this?

ioremap_nocache and ioremap() are the same thing, the former is just
more descriptive.

devm_ioremap_resource calls ioremap which does ioremap_nocache.

Resources are assumed to be memory mapped registers, and are always
handled appropriately.

> * I'm a bit puzzled with that function. Why there exists ioremaps that
>   do not add stuff to a resource tree and those that do? Maybe you have
>   a deeper understanding in this area could enlighten me since you did
>   the commit.

The resource tree and mapping are different things, not all drivers
can use the resource tree all the time, but certainly the majority of
drivers should be using it, hence the devm helper to do both.

When you see a ioremap without resource handling in a driver it is
probably a mistake, and if it isn't, IMHO there should be a comment
discussing why this driver cannot lock the resource region.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
