From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] TPM2.0:Adds securityfs support for
 TPM2.0 eventlog
Date: Fri, 29 Jul 2016 11:14:28 -0600
Message-ID: <20160729171428.GB6331@obsidianresearch.com>
References: <1469774679-25232-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1469774679-25232-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469774679-25232-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Fri, Jul 29, 2016 at 02:44:39AM -0400, Nayna Jain wrote:
  
> +	chip->bios_dir = tpm_bios_log_setup(chip);
> +

And the next somewhat pre-existing issue is that we call
tpm_bios_log_setup even if we don't have access to a bios log.

Does the bios log ever change or is it static at boot? Can we move
read_log into the chip and do it once so we can tell if it worked
before creating security fs stuff??

> +++ b/drivers/char/tpm/tpm2.h

You should probably pick a different name if this is only bios log
stuff.

> +struct tcg_efispecideventalgorithmsize {
> +	u16	algorithm_id;
> +	u16	digest_size;
> +} __packed;

The bios log is defined to be host endian?

Please refernce the standard in a comment that these structs are
coming from.

> +int read_log(struct tpm_bios_log *log)
> +{
> +	struct device_node *np;
> +	u32 logSize;
> +	const u32 *sizep;
> +	const u64 *basep;
> +
> +	if (log->bios_event_log != NULL) {
> +		pr_err("%s: ERROR - Eventlog already initialized\n",
> __func__);

No to all this logging.

If you really need some of it then use dev_dbg(&chip->dev) pr_err is
not acceptable.

Yes, this means you need to safely get tpm_chip into read_log. Please
make that a singular patch because the lifetime model will be quite
complex.

> +	np = of_find_node_by_name(NULL, "tpm");
> +	if (!np) {
> +		pr_err("%s: ERROR - tpm entry not supported\n", __func__);
> +		return -ENODEV;
> +	}

If you are doing of stuff then you need to document it in
Documentation/device-tree, so NAK on this without a proper
documentation patch. (make sure you follow the special rules for these
patches)

What is 'tpm' ? Is that the DT node that the TPM driver is binding
too? If so then you need to use chip->pdev->of_node instead of
'of_find_node_by_name'.

Same comments applies to the pre-existing tpm_of.c, please fix that as
well.

Why have you substantially copied tpm_of and called it tpm2_of? Don't
do that.

> +
> +	sizep = of_get_property(np, "linux,sml-size", NULL);
> +	if (sizep == NULL) {
> +		pr_err("%s: ERROR - sml-get-allocated-size not found\n",
> +				__func__);
> +		goto cleanup_eio;
> +	}
> +	logSize = be32_to_cpup(sizep);

If you call endianness converters then make sure to tag
properly. eg sizep should be a be32, etc. Audit everything in
eventlog, I saw other cases..

> +	log->bios_event_log = kmalloc(logSize, GFP_KERNEL);
> +	if (!log->bios_event_log) {
> +		pr_err("%s: ERROR - Not enough memory for firmware measurements\n",
> +				__func__);

Never log for ENOMEM, the kernel logs extensively already.

>  #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
> -	defined(CONFIG_ACPI)
> -extern struct dentry **tpm_bios_log_setup(const char *);
> -extern void tpm_bios_log_teardown(struct dentry **);
> +	defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
> +extern struct dentry **tpm_bios_log_setup(struct tpm_chip *chip);
> +extern void tpm_bios_log_teardown(struct tpm_chip *chip);

I'm really deeply unhappy about these ifdefs and the general scheme
that was used to force this special difference into the tpm core.

Please find another way to do it.

IMHO, 'read_log' should simply try ACPI and OF in sequence to find the
log.

> +	num_files = chip->flags & TPM_CHIP_FLAG_TPM2 ? 2 : 3;
> +	ret = kmalloc_array(num_files, sizeof(struct dentry *), GFP_KERNEL);
> +	if (!ret)
> +		goto out;

Follow the sysfs pattern please.

Jason

------------------------------------------------------------------------------
