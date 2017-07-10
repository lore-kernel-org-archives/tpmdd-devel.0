From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH RFC] tpm_crb: excluding locality registers for
 ARM64
Date: Mon, 10 Jul 2017 14:52:34 -0500
Message-ID: <8e465692-c445-0f59-5764-9a5ffb4f56f5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


Hi Guys,

In this patch https://patchwork.kernel.org/patch/9562247/
Are the locality registers in crb_regs_head specific to x86?

On ARM64, we don't have locality registers before control area in ACPI 
IO region.  We are hitting this check and getting the FW_BUG "Bad ACPI 
memory layout" log.

+	/* The ACPI IO region starts at the head area and continues to include
+	 * the control area, as one nice sane region except for some older
+	 * stuff that puts the control area outside the ACPI IO region.
+	 */
+	if (!(priv->flags & CRB_FL_ACPI_START)) {
+		if (buf->control_address == io_res.start +
+		    sizeof(*priv->regs_h))
+			priv->regs_h = priv->iobase;
+		else
+			dev_warn(dev, FW_BUG "Bad ACPI memory layout");
+	}

The quick fix that would make it work for ARM64 is to also exclude 
CRB_FL_CRB_SMC_START.

- if (!(priv->flags & CRB_FL_ACPI_START)) {
+ if (!(priv->flags & CRB_FL_ACPI_START ||
+       priv->flags & CRB_FL_CRB_SMC_START)) {

But would like to understand more why the check was only excluding 
CRB_FL_ACPI_START and getting opinions on this fix.  We don't see 
locality registers defined in TCG ACPI spec nor how a platform indicates 
the locality registers are present before control area.

I've done similar workaround to bypass x86 specific workaround in common 
code path.

For example, in crb_map_io(),  there is a specific PTT HW bug workaround 
for x86.

	/*
	 * PTT HW bug w/a: wake up the device to access
	 * possibly not retained registers.
	 */
	ret = crb_cmd_ready(dev, priv);
	if (ret)
		return ret;

crb_cmd_ready() does nothing for devices with ACPI-start method as it 
does not support goIdle and cmdReady bits and idle state management is 
not exposed to the host SW.  So I've done similar workaround to bypass 
by additionally excluding CRB_FL_CRB_SMC_START.

static int __maybe_unused crb_cmd_ready(struct device *dev,
					struct crb_priv *priv)
{
	if ((priv->flags & CRB_FL_ACPI_START) ||
	    (priv->flags & CRB_FL_CRB_SMC_START))
		return 0;


-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a 
Linux Foundation Collaborative Project.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
