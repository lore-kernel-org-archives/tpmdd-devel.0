From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_eventlog.c: fix
	binary_bios_measurements
Date: Tue, 9 Feb 2016 10:33:44 -0700
Message-ID: <20160209173344.GA13615@obsidianresearch.com>
References: <56B9C234.5050402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56B9C234.5050402-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 09, 2016 at 11:40:52AM +0100, Harald Hoyer wrote:

> From 57558a66cfadd329cdf63570af7ad1d0fd61010f Mon Sep 17 00:00:00 2001
> From: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date: Sat, 6 Feb 2016 15:44:42 +0100
> Subject: [PATCH] tpm_eventlog.c: fix binary_bios_measurements
> 
> commit 0cc698af36ff22295dce2f5e46b0cfe605789fa4 copied the event,
> but

This should be a fixes line, see Documentation/

> without the event data, did an endian conversion on the size and tried
> to output the event data from the copied version, which has only have
> one byte of the data, resulting in garbage event data.
> 
> Signed-off-by: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  drivers/char/tpm/tpm_eventlog.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index bd72fb0..a21624f 100644
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -244,7 +244,12 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
>  
>  	tempPtr = (char *)&temp_event;
>  
> -	for (i = 0; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
> +	for (i = 0; i < sizeof(struct tcpa_event)-1 ; i++)
> +		seq_putc(m, tempPtr[i]);
> +
> +	tempPtr = (char *)v;
> +
> +	for (i = sizeof(struct tcpa_event)-1; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
>  		seq_putc(m, tempPtr[i]);

Looks reasonable otherwise.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
