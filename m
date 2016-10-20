From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: remove redundant CRB_FL_CRB_START flag
Date: Thu, 20 Oct 2016 14:24:21 -0600
Message-ID: <20161020202421.GA13459@obsidianresearch.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
	<20161017225113.qnghq5vroxlmsurc@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
	<20161019160928.n5fswy25t2ppdh73@intel.com>
	<20161020135906.ah4rjympz3wq6g3t@intel.com>
	<20161020140011.s5mu3atjjwnwqda4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161020140011.s5mu3atjjwnwqda4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 20, 2016 at 05:00:11PM +0300, Jarkko Sakkinen wrote:

> > > I have a 4th Gen Core NUC where I experienced this issue. It reported
> > > requiring only ACPI start but actually required ACPI + CRB start. The
> > > comment could have been better.

Shouldn't bios work arounds be keyed on something? What happens if a
system rolls around that cannot do ACPI + CRB start? How does this
system work in windows?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
