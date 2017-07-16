From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC] tpm_crb: excluding locality registers
 for ARM64
Date: Sun, 16 Jul 2017 14:16:19 +0300
Message-ID: <1500203779.8397.2.camel@linux.intel.com>
References: <8e465692-c445-0f59-5764-9a5ffb4f56f5@codeaurora.org>
	<20170710202957.GA19948@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170710202957.GA19948-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-07-10 at 14:29 -0600, Jason Gunthorpe wrote:
> On Mon, Jul 10, 2017 at 02:52:34PM -0500, Jiandi An wrote:
> > 
> > Hi Guys,
> > 
> > In this patch https://patchwork.kernel.org/patch/9562247/
> > Are the locality registers in crb_regs_head specific to x86?
> 
> IMHO, the ACPI specification for TPM2 has been a disaster. The spec
> is
> too vauge and weird - this buisness with storing addresses inside a
> buffer inside a memory map is insane.
> 
> This is allowing implementations to do all manner of crazy things
> that
> make no sense at all.
> 
> > The quick fix that would make it work for ARM64 is to also exclude
> > CRB_FL_CRB_SMC_START.
> 
> Well, when the ACPI extension for ACPI_TPM2_COMMAND_BUFFER_WITH_SMC
> was defined, it needs to specify how to handle locality. If it is
> done
> via the registers in crb_regs_head then the ACPI spec needs to define
> how to locate those registers.
> 
> I suspect the test you pointed out is just poorly constructed:
> 
>         if (!(priv->flags & CRB_FL_ACPI_START)) {
> 
> It should be
> 
>    	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm ==
> ACPI_TPM2_MEMORY_MAPPED)
> 
> As those are the only two modes to define the register layout in
> this way.
> 
> But, you will still need to implement locality support for
> ACPI_TPM2_COMMAND_BUFFER_WITH_SMC.
> 
> > For example, in crb_map_io(),  there is a specific PTT HW bug
> > workaround for
> > x86.
> > 
> > 	/*
> > 	 * PTT HW bug w/a: wake up the device to access
> > 	 * possibly not retained registers.
> > 	 */
> > 	ret = crb_cmd_ready(dev, priv);
> > 	if (ret)
> > 		return ret;
> > 
> > crb_cmd_ready() does nothing for devices with ACPI-start method as
> > it does
> > not support goIdle and cmdReady bits and idle state management is
> > not
> > exposed to the host SW.  So I've done similar workaround to bypass
> > by
> > additionally excluding CRB_FL_CRB_SMC_START.
> 
> Again, I think these tests are backwards, a work around like this
> should be a while list, not a black list.. So it should refer to
> exactly the sm values the impacted chipsets would use.
> 
> Jason

I happen have a NUC that reports ACPI_TPM2_START_METHOD but still
requires that bit to be set always before invoking the ACPI:

https://lkml.org/lkml/2016/10/20/417

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
