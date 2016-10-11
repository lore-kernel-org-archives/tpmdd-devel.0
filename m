From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] char/tpm: Check return code of
	wait_for_tpm_stat
Date: Tue, 11 Oct 2016 20:01:09 +0200
Message-ID: <9174B547-9CD1-4F1B-A2A7-38B9A6AA3B33@gmx.de>
References: <1476187261-29027-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20161011171313.GD6881@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161011171313.GD6881-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



Hi
Am 11. Oktober 2016 19:13:13 MESZ, schrieb Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
>On Tue, Oct 11, 2016 at 03:01:01PM +0300, Jarkko Sakkinen wrote:
>> From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
>> 
>> In some weird cases it might be possible that the TPM does not set
>> STS.VALID within the given timeout time (or ever) but sets STS.EXPECT
>> (STS=0x0C) In this case the driver gets stuck in the while loop of
>> tpm_tis_send_data and loops endlessly.
>
>Doesn't that exchange mean the TPM has lost synchronization with the
>driver? Or maybe it crashed executing a command or something..

I saw that in the field on quite a few (similar) systems with our lpc tpms - so it affects end users.
Yes it is caused by some desynchronization or something similar.

If you manually send a commandReady by mmaping the memory region you can un-stuck the driver and the situation was never seen again on that system.

The exact reason how this happens is yet unknown, but the driver should definitely not be stuck in an endless loop (which zombies the application too) in that case but bail out as defined in the TIS protocol. The next access sends the cr which cures the unsynchronization.




Peter

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
