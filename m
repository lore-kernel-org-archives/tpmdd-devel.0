From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] tpm: msleep() delays - replace with usleep_range()
 in i2c nuvoton driver
Date: Fri, 10 Mar 2017 06:41:57 -0500
Message-ID: <1489146117.28954.47.camel@linux.vnet.ibm.com>
References: <1487893578.3193.155.camel@linux.vnet.ibm.com>
         <20170224170100.prwbcsffxdqjudc2@intel.com>
         <1487957342.3193.200.camel@linux.vnet.ibm.com>
         <20170302083347.q33wiwsdcwbxyrp6@intel.com>
         <1488893960.3216.45.camel@linux.vnet.ibm.com>
         <20170309110558.wbnzalcfgv4pzu4l@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170309110558.wbnzalcfgv4pzu4l@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, tpmdd-devel <tpmdd-devel@lists.sourceforge.net>, Thomas@intel.com, Dan Morav <dmorav@nuvoton.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, linux-ima-devel <linux-ima-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-03-09 at 13:05 +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 07, 2017 at 08:39:20AM -0500, Mimi Zohar wrote:
> > On Thu, 2017-03-02 at 10:33 +0200, Jarkko Sakkinen wrote:
> > > On Fri, Feb 24, 2017 at 12:29:02PM -0500, Mimi Zohar wrote:
> > > > On Fri, 2017-02-24 at 19:01 +0200, Jarkko Sakkinen wrote:
> > > > > On Thu, Feb 23, 2017 at 06:46:18PM -0500, Mimi Zohar wrote:
> > > > > > Commit 500462a9de65 "timers: Switch to a non-cascading wheel" replaced
> > > > > > the 'classic' timer wheel, which aimed for near 'exact' expiry of the
> > > > > > timers.  Their analysis was that the vast majority of timeout timers
> > > > > > are used as safeguards, not as real timers, and are cancelled or
> > > > > > rearmed before expiration.  The only exception noted to this were
> > > > > > networking timers with a small expiry time.
> > > > > > 
> > > > > > Not included in the analysis was the TPM polling timer, which resulted
> > > > > > in a longer normal delay and, every so often, a very long delay.  The
> > > > > > non-cascading wheel delay is based on CONFIG_HZ.  For a description of
> > > > > > the different rings and their delays, refer to the comments in
> > > > > > kernel/time/timer.c.
> > > > > > 
> > > > > > Below are the delays given for rings 0 - 2, which explains the longer
> > > > > > "normal" delays and the very, long delays as seen on systems with
> > > > > > CONFIG_HZ 250.
> > > > > > 
> > > > > > * HZ 1000 steps
> > > > > >  * Level Offset  Granularity            Range
> > > > > >  *  0      0         1 ms                0 ms - 63 ms
> > > > > >  *  1     64         8 ms               64 ms - 511 ms
> > > > > >  *  2    128        64 ms              512 ms - 4095 ms (512ms - ~4s)
> > > > > > 
> > > > > > * HZ  250
> > > > > >  * Level Offset  Granularity            Range
> > > > > >  *  0      0         4 ms                0 ms - 255 ms
> > > > > >  *  1     64        32 ms              256 ms - 2047 ms (256ms - ~2s)
> > > > > >  *  2    128       256 ms             2048 ms - 16383 ms (~2s - ~16s)
> > > > > > 
> > > > > > Below is a comparison of extending the TPM with 1000 measurements,
> > > > > > using msleep() vs. usleep_delay() when configured for 1000 hz vs. 250
> > > > > > hz, before and after commit 500462a9de65.
> > > > > > 
> > > > > > 		linux-4.7 | msleep()	usleep_range()
> > > > > > 1000 hz:	0m44.628s | 1m34.497s	29.243s
> > > > > > 250 hz:		1m28.510s | 4m49.269s	32.386s
> > > > > > 
> > > > > > 		linux-4.7 	| min-max (msleep)  min-max (usleep_range)
> > > > > > 1000 hz:	0:017 - 2:760s	| 0:015 - 3:967s    0:014 - 0:418s
> > > > > > 250 hz:		0:028 - 1:954s	| 0:040 - 4:096s    0:016 - 0:816s
> > > > > > 
> > > > > > This patch replaces the msleep() with usleep_range() calls in the
> > > > > > i2c nuvoton driver with a consistent max range value.
> > > > > > 
> > > > > > Signed-of-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > > > > > Reviewed-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > > > 
> > > > > So why doesn't it go to level 0 with msleep()?  I quickly skimmed
> > > > > through __mod_timer() and for me it looked like that level 0 would be
> > > > > calculated (when it is eventually called starting from msleep()).
> > > > > What did I miss?
> > > > 
> > > > I've just added some printk's in kernel/time/timer.c.  It looks like it
> > > > is level 0.  The delay seems to be caused by schedule() in
> > > > schedule_timeout().
> > > > 
> > > >         setup_timer_on_stack(&timer, process_timeout, (unsigned
> > > > long)current);
> > > >         __mod_timer(&timer, expire, false, false);
> > > >         schedule();  <===
> > > >         del_singleshot_timer_sync(&timer);
> > > > 
> > > >         /* Remove the timer from the object tracker */
> > > >         destroy_timer_on_stack(&timer);
> > > > 
> > > > 
> > > > printks output:
> > > > 124.901002] calc_wheel_index: level 0 timer: c000003fab32b150 expires
> > > > 4294923520 new expires 4294923520 now 4294923518
> > > > [  124.901003] __mod_timer: exit timer c000003fab32b1a0 now 4294923518
> > > > 
> > > > <  call to schedule()  >
> > > > 
> > > > [  128.607463] schedule_timeout: before destroy timer: c000003fab32b150
> > > > expires 4294923520 now 4294924439   <=== notice that the "now" time is
> > > > way beyond the expires time.
> > > >    
> > > > Mimi
> > > 
> > > Hey, I totally forgot this patch! Sorry.
> > > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > Thanks, Jarkko!  From looking at the code and adding some printks, the
> > TPM extends should have been in level 0.    We were left wondering why
> > msleep() was performing so poorly.   Unfortunately, we haven't gotten
> > very far.  Initially we thought it might be in "is_idle", but can't even
> > confirm that.  Sprinkling "printks" isn't very useful as it changes the
> > timing.  Even adding "1"  like in the change below improved the
> > performance a lot as shown in the table below.   Thomas, any
> > suggestions?
> 
> The documentation recommends to use usleep_range() for sleeping times
> that are shorter than 10 ms:
> 
> http://lxr.free-electrons.com/source/Documentation/timers/timers-howto.txt
> 
> "msleep(1~20) may not do what the caller intends, and will often sleep
> longer (~20 ms actual sleep for any value given in the 1~20ms range). In
> many cases this is not the desired behavior."
> 
> As for the value for 'max' I would consider it in te following way.
> 
> We should probably pick the largest possible value for 'max' that is
> still sufficient for tpm2_i2c_nuvoton because it is best for the overall
> system performance. What is in your opinion the largest value we could
> pick? Maybe 2x min?

In polling mode, we're waiting to check for a response from the TPM.
This is different than the maximum amount of time to wait for a TPM
response.

FYI, Nayna will be posting a cleaned up version of this patch, in
addition to another one.

thanks,

Mimi

