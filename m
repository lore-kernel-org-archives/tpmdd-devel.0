From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after
	tpm_bios_log_setup
Date: Mon, 21 Nov 2016 22:46:10 +0200
Message-ID: <20161121204610.v56fhxfxibhsvzss@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161118155249.sdxp2qfjfzfw4tzt@intel.com>
	<20161119182228.GA22775@obsidianresearch.com>
	<20161120121451.awcraondhcvzpbig@intel.com>
	<20161121175520.GA24191@obsidianresearch.com>
	<20161121203244.iwx2wa2zcilqd5ao@intel.com>
	<20161121203708.GA7294@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161121203708.GA7294-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 01:37:08PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 21, 2016 at 10:32:44PM +0200, Jarkko Sakkinen wrote:
> 
> > > And this one fixes the sysfs problem
> > > 
> > > https://patchwork.kernel.org/patch/9438331/
> > > 
> > > Here is a commit message:
> > > 
> > > tpm: Do not call tpm_chip_unregister if register has not succeeded
> > > 
> > > This is no longer allowed, vtpm was relying on the check inside the
> > > tpm core which was removed. Fixes an oops during error unwind.
> > > 
> > > Fixes: a8ed92219a04 ("tpm: Get rid of TPM_CHIP_FLAG_REGISTERED")
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > 
> > > That just leaves the ACPI thing..
> > 
> > I like the original commit message more. It documents the change.
> 
> ??
> 
> This is for  https://patchwork.kernel.org/patch/9438331/ which didn't
> have a message yet.

This was the commit message when I did git am:

    tpm: vtpm_proxy: Do not access host's event log
    
    On Thu, Nov 17, 2016 at 06:15:20PM -0500, Stefan Berger wrote:
    
    > >>Further, I had the impression that the error unwinding following -ENODEV has
    > >>an issue related to sysfs.
    > >I don't follow this comment..
    >
    > I have encountered this error here, which gets masked when applying the
    > previously shown patch.
    
    If tpm_chip_register fails vtpm must not call tpm_chip_unregister:
    
    > [   58.271017]  [<ffffffff8155bd32>] dpm_sysfs_remove+0x22/0x60
    > [   58.271017]  [<ffffffff8154e438>] device_del+0x58/0x280
    > [   58.271017]  [<ffffffffa024c020>] tpm_chip_unregister+0x40/0xb0 [tpm]
    > [   58.271017]  [<ffffffffa0292360>] vtpm_proxy_fops_release+0x40/0x60 [tpm_vtpm_proxy]
    
    So, this is a vtpm thing I missed for 'tpm: Get rid of TPM_CHIP_FLAG_REGISTERED'
    
    Does this do the trick?

/Jarkko

------------------------------------------------------------------------------
