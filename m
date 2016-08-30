From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
 support
Date: Tue, 30 Aug 2016 19:16:06 +0300
Message-ID: <20160830161606.GA17943@intel.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830101611.GA11819@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160830101611.GA11819-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 01:16:11PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 30, 2016 at 12:50:12AM -0400, Nayna Jain wrote:
> > Existing TPM2.0 support lacks the support for eventlog securityfs file.
> > This patch adds the binary_bios_measurements to TPM2.0 eventlog
> > securityfs file.
> 
> This is kind of patch set that would require very elaborate description
> how the problem was solved. I cannot really mirror the patches to
> anything (especially as the commit messages in commits are also very low
> quality).
> 
> If you write bad commit messages, it leaves me worried that the quality
> is low by other measure.
> 
> This is just an example but I do not know how this scales with algorithmic 
> agility. 
> 
> You also fail to explain how this should work with ACPI even though
> we know that there does not exist any kind for event log through ACPI
> with TPM 2.0 hardware. I.e. just by reading the commits I can obviously
> see that you are doing major untested code path changes.
> 
> This will need a lot of rework...

I can create a topic branch for this when this patch set starts to
converge more or less acceptable shape because that will help other
to work on the grub-kernel event log hand over. This will take a while
because I first want to test the code and I'm just started to acquire
hardware for that.

The dots need to be connected with this, event log handover and IMA for
the kexec.

/Jarkko

------------------------------------------------------------------------------
