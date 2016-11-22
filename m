From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: use test_bit() to check TPM2 flag in
 eventlog and sysfs code
Date: Tue, 22 Nov 2016 16:31:59 +0200
Message-ID: <20161122143159.wva54avrhtknuu5x@intel.com>
References: <1479715431-11983-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20161121195508.6urrvuhmlt2oo5d7@intel.com>
	<58340988.9000700@linux.vnet.ibm.com>
	<20161122105959.fmotb46kgzgmyqsy@intel.com>
	<583426D0.40105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <583426D0.40105-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 22, 2016 at 04:36:56PM +0530, Nayna wrote:
> 
> 
> On 11/22/2016 04:29 PM, Jarkko Sakkinen wrote:
> > On Tue, Nov 22, 2016 at 02:32:00PM +0530, Nayna wrote:
> > > 
> > > 
> > > On 11/22/2016 01:25 AM, Jarkko Sakkinen wrote:
> > > > On Mon, Nov 21, 2016 at 03:03:51AM -0500, Nayna Jain wrote:
> > > > > There is change done to introduce atomic bitops to set and test
> > > > > chip->flags.
> > > > > This patch fixes tpm_bios_log_setup() and tpm_sysfs_add_device()
> > > > > to use test_bit() to check for TPM_CHIP_FLAG_TPM2 flag.
> > > > > 
> > > > > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > > 
> > > > I'm bit lost of the purpose of this patch.
> > > 
> > > I was using tabrm branch which has changes related to using bitops for
> > > chip->flags, but it was failing for TPM2 check in tpm_bios_log_setup() with
> > > the existing way of checking. Replacing existing one with test_bit() check
> > > makes it work. Same in case of tpm_sysfs_add_device().
> > 
> > Why didn't you just response to the thread with a review comment
> > especially as the patch is not applied to the master branch?
> 
> Oh!! Ok.. Sorry, I should have done that.
> Will take care next time.
> 
> So basically it needs to be fixed as part of that patch.

NP. Thanks for reporting the issue!

/Jarkko

------------------------------------------------------------------------------
