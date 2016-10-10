From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] tpm_crb: expand struct
 crb_control_area to struct crb_regs
Date: Mon, 10 Oct 2016 00:25:11 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F7497@hasmsx108.ger.corp.intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475972112-2819-2-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20161009014256.GA8210@obsidianresearch.com>
	<20161009093818.GG31891@intel.com>
	<20161009164905.GA12551@obsidianresearch.com>
	<20161009183232.GA27764@intel.com>	<20161009183358.GB27764@intel.com>
	<20161009230737.GA23823@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161009230737.GA23823-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, October 10, 2016 02:08
> To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: moderated list:TPM DEVICE DRIVER <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>;
> open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Subject: Re: [tpmdd-devel] [PATCH RFC 1/3] tpm_crb: expand struct
> crb_control_area to struct crb_regs
> 
> On Sun, Oct 09, 2016 at 09:33:58PM +0300, Jarkko Sakkinen wrote:
> 
> > > Sorry I missed this part.
> > >
> > > Here are the constraints for existing hardware:
> > >
> > > 1. All the existing CRB start only hardware has the iomem covering the
> > >    control area and registers for multiple localities.
> > > 2. All the existing ACPI start hardware has only the control area.
> > >
> > > If you assume that SSDT does not have malicous behavior caused by
> > > either a BIOS bug or maybe a rootkit, then the current patch works
> > > for all the existing hardware.
> > >
> > > To counter-measure for unexpected behavior in non-existing hardware
> > > and buggy or malicious firmware it probably make sense to use
> > > crb_map_res to validate the part of the CRB registers that is not
> > > part of the control area.
> 
> I don't know how much I'd assume BIOS authors do what you think - the spec I
> saw for this seems very vauge.
> 
> Certainly checking that locality region falls within the acpi mapping seems
> essential.
> 
> > > Doing it in the way you proposed does not work for ACPI start devices.
> > >
> > > For them it should be done in the same way as I'm doing in the
> > > existing patch as for ACPI start devices the address below the
> > > control area are never accessed. Having a separate crb_map_res for
> > > CRB start only devices is sane thing to do for validation.
> >
> > Alternative is to do two structures crb_regs_head and crb_regs_tail,
> > which might be cleaner. I'm fine with going either route.
> 
> Since the iomem doesn't actually exist for a configuration having two pointers
> is the better choice. Make sure one is null for the configuration that does not
> support it.
> 
> The negative offset thing is way too subtle.

I addition I believe it should be always on offset FED4_0xxxh by the Spec, so all this arithmetic is a bit of overkill.
Thanks
Tomas


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
