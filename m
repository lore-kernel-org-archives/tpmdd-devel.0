From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 1/3] TPM2.0: Refactored eventlog init
 functions.
Date: Fri, 12 Aug 2016 20:45:40 -0600
Message-ID: <20160813024540.GB26929@obsidianresearch.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20160809222740.GD5535@obsidianresearch.com>
	<57AB0C14.8080305@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57AB0C14.8080305-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Aug 10, 2016 at 04:42:20PM +0530, Nayna wrote:
> Thanks for reviewing.
> 
> Sure, I will post next version with split as two patches and other fixes as
> suggested. Below is the breakdown of two patches, let me know if this
> doesn't sound ok.
> 
> 1. First patch to clean up the code related to tpm_eventlog_init.c - generic
> open() and bios_dir as dentry array.

Split the patches further. One idea per patch.

> 2. Second patch to have changes related to using of_node property and struct
> tpm_chip in tpm_of.c. Includes adding CONFIG_OF.

Yes

> And one feedback which I didn't understand and so need your help with that
> is
> 
> >> -extern struct dentry **tpm_bios_log_setup(const char *);
> >> -extern void tpm_bios_log_teardown(struct dentry **);
> >> +extern void tpm_bios_log_setup(struct tpm_chip *chip);
> >> +extern void tpm_bios_log_teardown(struct tpm_chip *chip);
> >
> > We are trying to get rid of these extra externs..
> 
> This is currently called by tpm_chip_register to setup the bios log.
> So, what did it meant by getting rid of these ?

The word extern in this context is unnecessary, just drop it when you
edit the line.

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
