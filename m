From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] Add "shutdown" to "struct class".
Date: Wed, 31 May 2017 15:01:13 -0700
Message-ID: <CAHSjozBDNX-bEQGjUtjqJzG_kuSWgxmrjPmdA=nfYhr1DFGgYg@mail.gmail.com>
References: <CAHSjozD_NjH0Ta=ELCOqG6ezX=qgteumKBnN2ceqE4ty2FaAZQ@mail.gmail.com>
	<20170530075419.766mlyxomxrzbxz6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170530075419.766mlyxomxrzbxz6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 30, 2017 at 12:54 AM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Thu, May 25, 2017 at 04:20:30PM -0700, Josh Zimmerman wrote:
>> The TPM class has some common shutdown code that must be executed for
>> all drivers. This adds some needed functionality for that.
>>
>> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> Does not apply yet to security-next (ancestor missing).

Hm, it applied cleanly for me to the "next" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git.
Are you referring to something else with "security-next"?

>> -----
>> v2: Add Signed-off-by.
>> v3: Remove logically separate change.
>> v4: Add "acked-by" and "cc".
>> ---
>>  drivers/base/core.c    | 5 +++++
>>  include/linux/device.h | 2 ++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 6bb60fb6a30b..687668d9afbe 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -2667,6 +2667,11 @@ void device_shutdown(void)
>>                 pm_runtime_get_noresume(dev);
>>                 pm_runtime_barrier(dev);
>>
>> +               if (dev->class && dev->class->shutdown) {
>> +                       if (initcall_debug)
>> +                               dev_info(dev, "shutdown\n");
>> +                       dev->class->shutdown(dev);
>> +               }
>>                 if (dev->bus && dev->bus->shutdown) {

I just looked again at this line, which I am suddenly skeptical of. Is there
any reason to run _both_ the class and the bus or driver shutdown
functions? In the code as-is, only the bus or the driver function will
execute. Right now, this patch will change that behavior. I suspect I
should just add the appropriate "else", but I'm not sure if there is
some reason to prefer the behavior as implemented in this version of
the patch.

>>                         if (initcall_debug)
>>                                 dev_info(dev, "shutdown\n");
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index 9ef518af5515..f240baac2001 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -378,6 +378,7 @@ int subsys_virtual_register(struct bus_type *subsys,
>>   * @suspend:   Used to put the device to sleep mode, usually to a low power
>>   *             state.
>>   * @resume:    Used to bring the device from the sleep mode.
>> + * @shutdown:  Called at shut-down time to quiesce the device.
>>   * @ns_type:   Callbacks so sysfs can detemine namespaces.
>>   * @namespace: Namespace of the device belongs to this class.
>>   * @pm:                The default device power management operations
>> of this class.
>> @@ -407,6 +408,7 @@ struct class {
>>
>>         int (*suspend)(struct device *dev, pm_message_t state);
>>         int (*resume)(struct device *dev);
>> +       int (*shutdown)(struct device *dev);
>>
>>         const struct kobj_ns_type_operations *ns_type;
>>         const void *(*namespace)(struct device *dev);
>> --
>> 2.13.0.219.gdb65acc882-goog

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
