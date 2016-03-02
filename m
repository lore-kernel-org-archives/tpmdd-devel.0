From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Fix unallocated memory access in TPM
	eventlog code
Date: Tue, 1 Mar 2016 17:03:02 -0700
Message-ID: <20160302000302.GA447@obsidianresearch.com>
References: <1456873414-6127-1-git-send-email-mjg59@coreos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456873414-6127-1-git-send-email-mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 01, 2016 at 03:03:34PM -0800, Matthew Garrett wrote:
> COmmit 0cc698 added support for handling endian fixups in the event log code
> but broke the binary log file in the process. Keep the endian code, but read
> the event data from the actual event rather than from unallocated RAM.

This patch is doing the same thing?

https://git.kernel.org/cgit/linux/kernel/git/jmorris/linux-security.git/commit/drivers/char/tpm/tpm_eventlog.c?h=next&id=186d124f07da193a8f47e491af85cb695d415f2f

Already on it's way to mainline.

> -	for (i = 0; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
> +	for (i = 0; i < sizeof(struct tcpa_event); i++)
> +		seq_putc(m, tempPtr[i]);
> +
> +	tempPtr = (char *)&event->event_data;
> +
> +	for (i = 0; i < temp_event.event_size; i++)
>  		seq_putc(m, tempPtr[i]);

Though this does look more elegant.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
