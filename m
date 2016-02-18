From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: fix: associate to the correct
 device
Date: Thu, 18 Feb 2016 11:03:31 -0700
Message-ID: <20160218180331.GA7191@obsidianresearch.com>
References: <1455708211-9653-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455708211-9653-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 17, 2016 at 01:23:31PM +0200, Jarkko Sakkinen wrote:
> At the moment for tpm_crb /proc/iomem shows the HW interface and not the
> device using the memory range. This patch fixes the issue by associating
> memory mappings to the TPM character device.
> 
> The end result is this:
> 
> $ cat /proc/iomem|grep MSFT -A2
> dbfff000-dbffffff : MSFT0101:00
>   dbfff000-dbffffff : tpm0

Hmmm... This large patch basically changes devm_ioremap so it uses the
tpm chip dev not the acpi_dev - which seems reasonable - however I
notice lots of drivers do use the parent device..

However, it will change the unwind ordering on remove.. And when we
check if tpm_crb is OK on that point I see this bug:

static int crb_acpi_remove(struct acpi_device *device)
{
[..]
        tpm_chip_unregister(chip);
        if (chip->flags & TPM_CHIP_FLAG_TPM2)
	                tpm2_shutdown(chip, TPM2_SU_CLEAR);

It is illegal to reference chip after tpm_chip_unregister, and it is
very illegal to try to send a command to an unregistered tpm. This
will conflict with my other patches to fix ops locking.

Further, it probably conflicts with this patch, since the iomapping is
associated with chip, it risks being torn down by tpm_chip_unregister
when it triggers the devm unwind.

Something like tpm2_shutdown belongs in the core code, add it to
tpm_chip_unregister, and do that before this patch..

Ideally this would have been fewer lines, not sure why the acpi stuff
had to move out of crb_map_io, for instance..

Does tpm_tis need the same fix?

> +	INIT_LIST_HEAD(&resources);
> +	rc = acpi_dev_get_resources(device, &resources, crb_check_resource,
> +				    priv);
> +	if (rc < 0)
> +		return rc;
> +	acpi_dev_free_resource_list(&resources);

I wonder if the acpi_dev_free_resource_list is what kill's the
resource name? Maybe that needs to be delayed until after the
ioremap, which is best done with this back in crb_map_io  ??

Thanks for looking at this stuff,
Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
