From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 04/10] tpm: Get rid of module locking
Date: Mon, 29 Feb 2016 17:24:53 -0700
Message-ID: <20160301002453.GA12174@obsidianresearch.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-5-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229203550.GB26296@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160229203550.GB26296-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 29, 2016 at 10:35:50PM +0200, Jarkko Sakkinen wrote:
> On Mon, Feb 29, 2016 at 12:29:50PM -0500, Stefan Berger wrote:
> > Now that the tpm core has strong locking around 'ops' it is possible
> > to remove a TPM driver, module and all, even while user space still
> > has things like /dev/tpmX open. For consistency and simplicity, drop
> > the module locking entirely.
> 
> I don't understand why the user visible behavior of /dev/tpmX should
> be changed if there are no life and death reasons to do it. Do you
> think that this patch is absolutely crucial for the feature
> implemented?

Stefan is addressing it here because once NULL is a legal parent for
registration the chip->dev.parent->driver->owner expression becomes
useless for module locking.

If we want to keep module locking then Stefen has to add an 'owner'
field to tpm_class_ops and update all drivers. The ops->owner would
be used for the module locking instead of driver->owner

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
