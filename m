From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC v2 5/5] tpm2: expose resource manager
 via	a device link /dev/tpms<n>
Date: Thu, 12 Jan 2017 11:46:09 -0800
Message-ID: <1484250369.5807.11.camel@HansenPartnership.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170112174612.9314-6-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> 
> Currently the Resource Manager (RM) is not exposed to userspace. 
>  Make
> this exposure via a separate device, which can now be opened multiple
> times because each read/write transaction goes separately via the RM.
> 
> Concurrency is protected by the chip->tpm_mutex for each read/write
> transaction separately.  The TPM is cleared of all transient objects
> by the time the mutex is dropped, so there should be no interference
> between the kernel and userspace.

There's a bug in this code that will crash on first command.  This is
the incremental fix.  It must have got lost when I did the split.

James

---

diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
index f4cb7a3..3eb5955 100644
--- a/drivers/char/tpm/tpms-dev.c
+++ b/drivers/char/tpm/tpms-dev.c
@@ -20,6 +20,11 @@ static int tpms_open(struct inode *inode, struct file *file)
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
 		return -ENOMEM;
+	priv->space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (priv->space.context_buf == NULL) {
+		kfree(priv);
+		return -ENOMEM;
+	}
 
 	tpm_common_open(file, chip, &priv->priv);
 


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
