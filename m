From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] vTPM: Fix missing NULL check
Date: Mon, 6 Mar 2017 16:19:46 -0700
Message-ID: <20170306231946.GA23953@obsidianresearch.com>
References: <1488839535-11822-1-git-send-email-honclo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488839535-11822-1-git-send-email-honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 06, 2017 at 05:32:15PM -0500, Hon Ching(Vicky) Lo wrote:
> The current code passes the address of tpm_chip as the argument to
> dev_get_drvdata() without prior NULL check in
> tpm_ibmvtpm_get_desired_dma.  This resulted an oops during kernel
> boot when vTPM is enabled in Power partition configured in active
> memory sharing mode.
> 
> The vio_driver's get_desired_dma() is called before the probe(), which
> for vtpm is tpm_ibmvtpm_probe, and it's this latter function that
> initializes the driver and set data.  Attempting to get data before
> the probe() caused the problem.
> 
> This patch adds a NULL check to the tpm_ibmvtpm_get_desired_dma.

Does this also need a hunk in tpm_ibmvtpm_remove to null the drvdata
after removal, or does something in the driver code guarentee it is
null'd after remove?

We don't want to use-after-free chip on the next probe cycle.

>  static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
> -	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
> +	struct ibmvtpm_dev *ibmvtpm = NULL;
> +
> +	if (chip)
> +		ibmvtpm = dev_get_drvdata(&chip->dev);

Maybe just do this, clearer that it is chip that can be null. We do
not want to see drivers testing their chip drvdata against null.

Also, how does locking work here? Does the vio core prevent
tpm_ibmvtpm_get_desired_dma and tpm_ibmvtpm_remove from running
concurrently?

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 946025a7413b6b..ced6b9f0008dc2 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -294,6 +294,8 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 		kfree(ibmvtpm->rtce_buf);
 	}
 
+	/* For tpm_ibmvtpm_get_desired_dma */
+	dev_set_drvdata(&vdev->dev, NULL);
 	kfree(ibmvtpm);
 
 	return 0;
@@ -309,15 +311,16 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
-	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	struct ibmvtpm_dev *ibmvtpm;
 
 	/* ibmvtpm initializes at probe time, so the data we are
 	* asking for may not be set yet. Estimate that 4K required
 	* for TCE-mapped buffer in addition to CRQ.
 	*/
-	if (!ibmvtpm)
+	if (!chip)
 		return CRQ_RES_BUF_SIZE + PAGE_SIZE;
 
+	ibmvtpm = dev_get_drvdata(&chip->dev);
 	return CRQ_RES_BUF_SIZE + ibmvtpm->rtce_size;
 }
 

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
