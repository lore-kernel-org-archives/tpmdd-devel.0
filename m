From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: move struct tpm_class_ops to
	drivers/char/tpm/tpm.h
Date: Sat, 3 Sep 2016 09:22:22 +0300
Message-ID: <20160903062221.GA2061@intel.com>
References: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160902221122.GA1897@obsidianresearch.com>
	<20160902223522.GA27454@intel.com>
	<20160902224531.GC1897@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160902224531.GC1897-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 04:45:31PM -0600, Jason Gunthorpe wrote:
> On Sat, Sep 03, 2016 at 01:35:22AM +0300, Jarkko Sakkinen wrote:
> > On Fri, Sep 02, 2016 at 04:11:22PM -0600, Jason Gunthorpe wrote:
> > > On Sat, Sep 03, 2016 at 12:48:03AM +0300, Jarkko Sakkinen wrote:
> > > > The struct tpm_class_ops is not used outside the TPM driver. Thus,
> > > > it can be safely move to drivers/char/tpm/tpm.h.
> > > 
> > > No, this is the wrong direction.
> > > 
> > > The goal is to make things more like other subsystems, so we should be
> > > moving struct tpm_chip into the public header, and that requires ops
> > > to be in the public header.
> > > 
> > > This is why I put ops here in the first place.
> > 
> > I'm OK with it as long as you explain why this is necessary. I see no
> > use for them outside the TPM subsystem.
> 
> That is because the users out side the subsystem are Doing it Wrong.
> 
> eg this:
> 
>  extern int tpm_is_tpm2(u32 chip_num);
> 
> Should be:
> 
>  extern int tpm_is_tpm2(struct tpm_chip *chip);
> 
> And same for all other examples.
> 
> The 'chip_num' thing is bonkers.

OK, how would one get the chip instance?

/Jarkko

------------------------------------------------------------------------------
