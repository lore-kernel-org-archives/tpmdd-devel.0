From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v11 1/4] tpm: Remove all uses of drvdata
	from the TPM Core
Date: Tue, 19 Apr 2016 11:06:45 -0600
Message-ID: <20160419170645.GA20844@obsidianresearch.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160419101214.GA11574@intel.com>
	<57160A26.5040805@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57160A26.5040805-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 06:36:22AM -0400, Stefan Berger wrote:
> On 04/19/2016 06:12 AM, Jarkko Sakkinen wrote:
> >On Mon, Apr 18, 2016 at 01:26:13PM -0400, Stefan Berger wrote:
> >>From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >>
> >>The final thing preventing this was the way the sysfs files were
> >>attached to the pdev. Follow the approach developed for ppi and move
> >>the sysfs files to the chip->dev with symlinks from the pdev
> >>for compatibility. Everything in the core now sanely uses container_of
> >>to get the chip.
> >Can you give me a quick recap why this patch was mandatory to make the
> >patch set work? Which regression in the earlier versions of the patch
> >set this fixes?
> 
> The below patch removes usage of dev_get_drvdata() for retrieving the chip.
> With Christophe's series dropping the priv field I now can use the drvdata
> to store proxy_dev rather than re-introducing the priv field in the chip
> structure. Besides that it doesn't seem necessary to use the drvdata field
> to get from the chip to the device if a simple container_of can do it.

More specifically, since the vtpm patches use a NULL parent, the
approach of putting the sysfs files on the parent is no longer
workable.

The early vtpm patches simply moved the sysfs files to the tpm_chip
when a parent is NULL, which is inconsistent for userspace. This also
created a problem where drvdata on the chip now had to point back to
the chip, meaning it became unusable for its new intended purpose.

The fix is to make everything uniform and put the sysfs files in the
correct place for all drivers (under the chip) and use symlinks for
compat.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
