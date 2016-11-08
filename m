From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 4/7] tpm: fix the race condition
 between event log access and chip getting unregistered
Date: Mon, 7 Nov 2016 16:26:43 -0800
Message-ID: <20161108002642.4pvvubjcz57m4nov@intel.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1476838185-24007-5-git-send-email-nayna@linux.vnet.ibm.com>
	<20161104051410.iqxb5k6fwizv7inc@intel.com>
	<20161107234839.GC7002@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161107234839.GC7002-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 07, 2016 at 04:48:39PM -0700, Jason Gunthorpe wrote:
> On Thu, Nov 03, 2016 at 11:14:10PM -0600, Jarkko Sakkinen wrote:
> > On Tue, Oct 18, 2016 at 08:49:42PM -0400, Nayna Jain wrote:
> > > Currently, the event log file operations are not serialized with
> > > tpm_chip_unregister(), which can possibly cause a race condition.
> > > 
> > > This patch fixes the race condition by:
> > >  - moving read_log() from fops to chip register.
> > 
> > What is "chip register"? Please use exact names.
> > 
> > >  - disallowing event log file operations when chip unregister is in
> > >    progress.
> > 
> > Could you elaborate this sentence?
> > 
> > >  - guarding event log memory using chip krefs.
> > 
> > Could you elaborate this sentence?
> > 
> > Please describe how the race condition could happen and provide the
> > "Fixes:" line for the commit ID that caused it. Otherwise, your commit
> > message won't make any sense. I cannot apply this commit with this
> > commit message.
> > 
> > The commit message does not make much sense...
> 
> Lets get this moving along, it is hard to keep everything straight
> over months..
> 
> Nayna: This commit message should work:
> 
> tpm: Have eventlog use the tpm_chip
> 
> Move the backing memory for the eventlog into tpm_chip and push
> the tpm_chip into read_log. This optimizes read_log processing by
> only doing it once and prepares things for the next patches in the
> series which require the tpm_chip to locate the event log via
> ACPI and OF handles instead of searching.
> 
> This is straightfoward except for the issue of passing a kref through
> i_private with securityfs. Since securityfs_remove does not have any
> removal fencing like sysfs we use the inode lock to safely get a
> kref on the tpm_chip.

Perfect. Thank you.

With this

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

No need for resend.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
