From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Sat, 19 Nov 2016 11:32:55 -0700
Message-ID: <20161119183255.GB22775@obsidianresearch.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
	<ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
	<20161117181006.GA26039@obsidianresearch.com>
	<c6e84bc7-151c-e698-e269-0ef1ebf3897b@linux.vnet.ibm.com>
	<20161117183328.GC26039@obsidianresearch.com>
	<513da75c-6221-39ce-2718-19290c216ff1@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <513da75c-6221-39ce-2718-19290c216ff1-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 06:15:20PM -0500, Stefan Berger wrote:

> >>Further, I had the impression that the error unwinding following -ENODEV has
> >>an issue related to sysfs.
> >I don't follow this comment..
> 
> I have encountered this error here, which gets masked when applying the
> previously shown patch.

If tpm_chip_register fails vtpm must not call tpm_chip_unregister:

> [   58.271017]  [<ffffffff8155bd32>] dpm_sysfs_remove+0x22/0x60
> [   58.271017]  [<ffffffff8154e438>] device_del+0x58/0x280
> [   58.271017]  [<ffffffffa024c020>] tpm_chip_unregister+0x40/0xb0 [tpm]
> [   58.271017]  [<ffffffffa0292360>] vtpm_proxy_fops_release+0x40/0x60 [tpm_vtpm_proxy]

So, this is a vtpm thing I missed for 'tpm: Get rid of TPM_CHIP_FLAG_REGISTERED'

Does this do the trick?

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 3d6f6ca81def75..d3a41f9d65c85c 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -42,6 +42,7 @@ struct proxy_dev {
 	long state;                  /* internal state */
 #define STATE_OPENED_FLAG        BIT(0)
 #define STATE_WAIT_RESPONSE_FLAG BIT(1)  /* waiting for emulator response */
+#define STATE_REGISTERED_FLAG	 BIT(2)
 
 	size_t req_len;              /* length of queued TPM request */
 	size_t resp_len;             /* length of queued TPM response */
@@ -372,6 +373,7 @@ static void vtpm_proxy_work(struct work_struct *work)
 	if (rc)
 		goto err;
 
+	proxy_dev->state |= STATE_REGISTERED_FLAG;
 	return;
 
 err:
@@ -516,7 +518,8 @@ static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
 	 */
 	vtpm_proxy_fops_undo_open(proxy_dev);
 
-	tpm_chip_unregister(proxy_dev->chip);
+	if (proxy_dev->state & STATE_REGISTERED_FLAG)
+		tpm_chip_unregister(proxy_dev->chip);
 
 	vtpm_proxy_delete_proxy_dev(proxy_dev);
 }


------------------------------------------------------------------------------
