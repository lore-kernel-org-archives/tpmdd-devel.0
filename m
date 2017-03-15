From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v1 1/2] tpm: msleep() delays - replace
 with usleep_range() in i2c nuvoton driver
Date: Wed, 15 Mar 2017 21:51:47 +0530
Message-ID: <58C96A1B.3080803@linux.vnet.ibm.com>
References: <1489171554-6844-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20170315155226.xtgpttv5slej77ep@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170315155226.xtgpttv5slej77ep-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-4.8" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 03/15/2017 09:22 PM, Jarkko Sakkinen wrote:
> On Fri, Mar 10, 2017 at 01:45:53PM -0500, Nayna Jain wrote:
>> Commit 500462a9de65 "timers: Switch to a non-cascading wheel" replaced
>> the 'classic' timer wheel, which aimed for near 'exact' expiry of the
>> timers.  Their analysis was that the vast majority of timeout timers
>> are used as safeguards, not as real timers, and are cancelled or
>> rearmed before expiration.  The only exception noted to this were
>> networking timers with a small expiry time.
>>
>> Not included in the analysis was the TPM polling timer, which resulted
>> in a longer normal delay and, every so often, a very long delay.  The
>> non-cascading wheel delay is based on CONFIG_HZ.  For a description of
>> the different rings and their delays, refer to the comments in
>> kernel/time/timer.c.
>>
>> Below are the delays given for rings 0 - 2, which explains the longer
>> "normal" delays and the very, long delays as seen on systems with
>> CONFIG_HZ 250.
>>
>> * HZ 1000 steps
>>   * Level Offset  Granularity            Range
>>   *  0      0         1 ms                0 ms - 63 ms
>>   *  1     64         8 ms               64 ms - 511 ms
>>   *  2    128        64 ms              512 ms - 4095 ms (512ms - ~4s)
>>
>> * HZ  250
>>   * Level Offset  Granularity            Range
>>   *  0      0         4 ms                0 ms - 255 ms
>>   *  1     64        32 ms              256 ms - 2047 ms (256ms - ~2s)
>>   *  2    128       256 ms             2048 ms - 16383 ms (~2s - ~16s)
>>
>> Below is a comparison of extending the TPM with 1000 measurements,
>> using msleep() vs. usleep_delay() when configured for 1000 hz vs. 250
>> hz, before and after commit 500462a9de65.
>>
>> linux-4.7 | msleep() usleep_range()
>> 1000 hz: 0m44.628s | 1m34.497s 29.243s
>> 250 hz: 1m28.510s | 4m49.269s 32.386s
>>
>> linux-4.7  | min-max (msleep)  min-max (usleep_range)
>> 1000 hz: 0:017 - 2:760s | 0:015 - 3:967s    0:014 - 0:418s
>> 250 hz: 0:028 - 1:954s | 0:040 - 4:096s    0:016 - 0:816s
>>
>> This patch replaces the msleep() with usleep_range() calls in the
>> i2c nuvoton driver with a consistent max range value.
>>
>> Signed-of-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-4.8)
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>> Changelog v1:
>>
>> - Included Jason's feedbacks related to #defines.
>
> What was changed?
>

Changelog v1:
 >>
 >> - Included Jason's feedbacks related to #defines.

Based on Jason's review:
- Added () in #define
- Replaced hardcoded maximum range value with defined name.

Hmm.. could have included exact details.

Thanks & Regards,
- Nayna

> /Jarkko
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
