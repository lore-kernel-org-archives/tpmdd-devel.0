From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 3/3] TPM2.0:Adds securityfs support for
 TPM2.0 eventlog
Date: Tue, 9 Aug 2016 16:19:39 -0600
Message-ID: <20160809221939.GC5535@obsidianresearch.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-4-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470771295-15680-4-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Aug 09, 2016 at 03:34:55PM -0400, Nayna Jain wrote:
> Adds securityfs support for TPM2.0.
> This patch currently supports only binary_bios_measurements.
> 
> Changelog v2:
>         * Single tpm_of.c for reading both tpm and vtpm device tree values.
>         * Some of the issues are fixed in Patch 1 itself.
>         * Comments in tpm2.h give reference to the standard from where structs
> 	are taken.
> 	* Now, tpm_of.c has same code applied for both tpm and vtpm, so I think
> 	that now it is needed to have generic types rather than endian specific type.
> 
> There are few preexisting issues as being mentioned in feedback and are not 
> addressed in this patch. Reason being, I don't have much expertise of ACPI side as of now, 
> and these changes will affect acpi,tpm,vtpm, all paths, so I would like to go slow
> and fix them as different patch later after better understanding.
> Hope this sounds ok to have them as different patch.

Yes, but do the patches first please, this stuff is obviously broken,
do not make the mess larger.

You are the only person ever to come up who can test the _of side of
this, so the rest of us have the opposite problem to you.

If you have doubts about the acpi stuff then ask.

> +	/*
> +	 * NOTE: Currently, support is added only for binary_bios_measurements
> +	 * for TPM2.0. And so it is required to check that if device is TPM2,
> +	 * only 2 entries are allocated i.e. tpm0 dir and
> +	 * binary_bios_measurements file.
> +	 */
> +
> +	num_files = chip->flags & TPM_CHIP_FLAG_TPM2 ? 2 : 3;

?? just ++ as you go like sysfs does

>  	const u32 *sizep;
>  	const u64 *basep;
> +	u32 log_size;
>  
>  	if (log->bios_event_log != NULL) {
>  		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
> @@ -52,6 +53,11 @@ int read_log(struct tpm_bios_log *log, struct tpm_chip *chip)
>  		goto cleanup_eio;
>  	}
>  
> +	if (!strncmp(np->name, "tpm", 3))
> +		log_size = be32_to_cpup(sizep);
> +	else
> +		log_size = *sizep;

?? That deserves a comment, one of your systems has swapped
endianness?? 'np->name' is not an appropriate way to detect
that. compatible string would be better, or something else..

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
