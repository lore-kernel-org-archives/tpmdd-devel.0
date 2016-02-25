From: kay <kay.diam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: tpm_tis driver failed to suspend, error -62
Date: Thu, 25 Feb 2016 22:49:01 +0100
Message-ID: <CANaOheYpnr+T9YNGfA=UNyD8K_H1L_FyWEqYKSQR523s0pkM7g@mail.gmail.com>
References: <CANaOheYnD6S8gHbaLL0bY_csUmbFNcy0OeFA2=a8YornS1OkUA@mail.gmail.com>
	<20151023092539.GB6941@intel.com>
	<CANaOhebYSrW4jzwu8zsKu2=pZYbN--b1ehNc6M0yOBUVRpDTAA@mail.gmail.com>
	<20151023110914.GA9719@intel.com>
	<CANaOheZLeqx37ZEX4yc1ubaFpdOHO3G04WO6GWa3YLPgOjttvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CANaOheZLeqx37ZEX4yc1ubaFpdOHO3G04WO6GWa3YLPgOjttvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterasplund-xYBMnk5ip2SzQB+pC5nmwQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

Weird, but whole last week it worked perfectly. But several minutes
ago I've reproduced the same issue.

[11062.511097] tpm_tis 00:01: tpm_transmit: tpm_send: error -62
[11062.511099] tpm_tis 00:01: Error (-62) sending savestate before suspend
[11062.511105] __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x1d0 returns -62
[11062.511108] dpm_run_callback(): pnp_bus_suspend+0x0/0x20 returns -62
[11062.511111] PM: Device 00:01 failed to suspend: error -62
[11062.511113] PM: Some devices failed to suspend, or early wake event detected

uname -a
Linux host-HP 4.2.0-30-generic #35~14.04.1-Ubuntu SMP Fri Feb 19
14:48:13 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Regards

On Thu, Feb 25, 2016 at 9:19 PM, kay <kay.diam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Jarkko,
>
> I tested new kernel (4.2) and it didn't help. Same problem on suspend.
> Then I found another solution - boot with the "tpm_tis.interrupts=0"
> kernel parameter and this resolved the issue. Could you explain me
> what exactly does it make so it solves most of the problems with tpm
> and suspend?
>
> Regards
>
> On Fri, Oct 23, 2015 at 1:09 PM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> On Fri, Oct 23, 2015 at 11:52:51AM +0200, kay wrote:
>>> Hi Jarkko,
>>>
>>> It was reproduced even in earlier version. You can review initial
>>> topic message.
>>
>> OK, the thing that I would try would be to assing sometihing enormous
>> like 4 * 60 * HZ to local variable 'stop' inside tpm_transmit() in
>> tpm-interface.c.
>>
>> If the problem still occurs it's definitely HW/firmware issue
>>
>> /Jarkko

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
