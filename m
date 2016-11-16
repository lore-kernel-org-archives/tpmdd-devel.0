From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Wed, 16 Nov 2016 12:07:23 -0500
Message-ID: <65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <3a38ddc6-1758-ae82-3df3-9cc55906880d-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/16/2016 10:41 AM, Stefan Berger wrote:
> On 11/16/2016 10:37 AM, Jarkko Sakkinen wrote:
>> On Wed, Nov 16, 2016 at 09:24:05AM -0500, Stefan Berger wrote:
>>> The virtual TPM driver must not access the hosts's event log,
>>> otherwise we get crashes from that.
>>>
>>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Can you give me a "Fixes" line (no need to send a new patch)?
>
> I haven't bisected, yet.... but will do that today.

The culprit seems to be 'tpm: fix the missing .owner in 
tpm_bios_measurements_ops'

'Something' now can only have a single owner?

The crash looks like this:

[  173.597916] iounmap: bad address ffffc9000d8c0000
[  173.599149] CPU: 10 PID: 686 Comm: kworker/10:2 Not tainted 
4.9.0-rc5+ #578
[  173.600051] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.9.0-156-g3560877 04/01/2014
[  173.600137] Workqueue: tpm-vtpm vtpm_proxy_work [tpm_vtpm_proxy]
[  173.600137]  ffffc900027b7c78 ffffffff8140ca11 ffff8802ad548300 
ffffc9000d8c0000
[  173.600137]  ffffc900027b7c98 ffffffff8106b99f ffff8802ad548300 
ffffc9000d8c0000
[  173.605189]  ffffc900027b7ca8 ffffffff8106b9dc ffffc900027b7cc8 
ffffffff81496c75
[  173.608722] Call Trace:
[  173.608722]  [<ffffffff8140ca11>] dump_stack+0x63/0x82
[  173.608722]  [<ffffffff8106b99f>] iounmap.part.1+0x7f/0x90
[  173.608722]  [<ffffffff8106b9dc>] iounmap+0x2c/0x30
[  173.608722]  [<ffffffff81496c75>] acpi_os_map_cleanup.part.10+0x31/0x3e
[  173.608722]  [<ffffffff8179629c>] acpi_os_unmap_iomem+0xcb/0xd2
[  173.608722]  [<ffffffffa00e1b28>] read_log+0xc8/0x19e [tpm]
[  173.608722]  [<ffffffffa00e1921>] tpm_bios_log_setup+0x31/0x170 [tpm]
[  173.608722]  [<ffffffffa00df0dc>] tpm_chip_register+0x4c/0x200 [tpm]
[  173.608722]  [<ffffffffa029e309>] vtpm_proxy_work+0x19/0x30 
[tpm_vtpm_proxy]
[  173.608722]  [<ffffffff810c4593>] process_one_work+0x1f3/0x560
[  173.608722]  [<ffffffff810c4511>] ? process_one_work+0x171/0x560
[  173.608722]  [<ffffffff810c494e>] worker_thread+0x4e/0x480
[  173.608722]  [<ffffffff810c4900>] ? process_one_work+0x560/0x560
[  173.608722]  [<ffffffff810c4900>] ? process_one_work+0x560/0x560
[  173.608722]  [<ffffffff810ca994>] kthread+0xf4/0x110
[  173.608722]  [<ffffffff810ca8a0>] ? kthread_park+0x60/0x60
[  173.608722]  [<ffffffff817a1c15>] ret_from_fork+0x25/0x30


     Stefan

>
> Also I am wondering whether we should introduce a flag 
> TPM_CHIP_NO_FIRMWARE_LOG that is checked below. The 
> TPM_CHIP_FLAG_VIRTUAL may not be ideal, also because it is set due to 
> the device not having a parent device, which may not be related. 
> Thoughts? That new flag would only be set by the vtpm proxy driver.
>
>    Stefan
>
>>
>>> ---
>>>   drivers/char/tpm/tpm_eventlog.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/char/tpm/tpm_eventlog.c 
>>> b/drivers/char/tpm/tpm_eventlog.c
>>> index fb603a7..e0abf40 100644
>>> --- a/drivers/char/tpm/tpm_eventlog.c
>>> +++ b/drivers/char/tpm/tpm_eventlog.c
>>> @@ -369,6 +369,9 @@ static int tpm_read_log(struct tpm_chip *chip)
>>>   {
>>>       int rc;
>>>   +    if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
>>> +        return -EFAULT;
>>> +
>>>       if (chip->log.bios_event_log != NULL) {
>>>           dev_dbg(&chip->dev,
>>>               "%s: ERROR - event log already initialized\n",
>>> -- 
>>> 2.4.3
>>>
>> /Jarkko
>>
>


------------------------------------------------------------------------------
