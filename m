From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Mon, 15 May 2017 09:39:09 -0600
Message-ID: <20170515153909.GA3433@obsidianresearch.com>
References: <20170512234058.25716-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170512234058.25716-1-joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, May 12, 2017 at 04:40:58PM -0700, Josh Zimmerman wrote:
> If a TPM2 loses power without a TPM2_Shutdown command being issued, it
> may lose some state that has yet to be persisted to NVRam, and will
> increment the DA counter (meaning that after too many disorderly
> reboots, the TPM will lock the user out).
> 
> This is a variant of https://patchwork.kernel.org/patch/9516631/.
> It differs in that:
>   * It only changes behavior on TPM2 devices, to avoid invoking the
>   unbounded-waiting sysfs codepath that was discussed on that patch, and
>   to avoid racing on chip->ops.
>   * It modifies tpm-chip rather than tpm_i2c_infineon, so that it can
>   change behavior for all TPM2 devices.
> 
> This patch is dependent on '[PATCH] Add "shutdown" to "struct class".'
> http://marc.info/?l=linux-kernel&m=149463235025420&w=2

Looks like it includes that patch. You need split this and send both
to Greg as he requested.
> +static void tpm_shutdown(struct device *dev)
> +{
> +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
> +	// TPM 2.0 requires that the TPM2_Shutdown() command be issued prior to
> +	// loss of power. If it is not, the DA counter will be incremented and,
> +	// eventually, the user will be locked out of their TPM.
> +	// XXX: This codepath relies on the fact that sysfs is not enabled for
> +	// TPM2: sysfs uses an implicit lock on chip->ops, so this use could
> +	// race if TPM2 has sysfs support enabled before TPM sysfs's implicit
> +	// locking is fixed.

Please use the same block comment format as the rest of the file

> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		down_read(&chip->ops_sem);

This needs to be down_write

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
