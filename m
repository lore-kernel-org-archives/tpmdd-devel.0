From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Thu, 17 Nov 2016 18:15:20 -0500
Message-ID: <513da75c-6221-39ce-2718-19290c216ff1@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
	<ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
	<20161117181006.GA26039@obsidianresearch.com>
	<c6e84bc7-151c-e698-e269-0ef1ebf3897b@linux.vnet.ibm.com>
	<20161117183328.GC26039@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161117183328.GC26039-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/17/2016 01:33 PM, Jason Gunthorpe wrote:
> On Thu, Nov 17, 2016 at 01:25:54PM -0500, Stefan Berger wrote:
>> In the case of x86, tpm_read_log_of() is a stub return -ENODEV, which in
>> turn fails the whole device:
> Somehow this got screwed up during the lengthy review. ENODEV is the
> right return from the leaf routines but the tests in tpm_eventlog di
> not get fixed:
>
>> http://git.infradead.org/users/jjs/linux-tpmdd.git/blob/4d388433e85f8257f5a9344a7acf6f499ba2b29e:/drivers/char/tpm/tpm_eventlog.h#l87
> Is wrong, should be:
>
> if (rc != -ENODEV)
>     return rc;
>
> And the one in tpm_bios_log_setup should be
>
> if (rc != 0 && rc != -ENODEV)
>      return rc;


Can you show a patch that shows where to place these two?

>      
>> I think the OF log reading code will also need to check for chip->dev.parent
>> being NULL.
> Currect! Lets get that fixed too. :(
>
>> Further, I had the impression that the error unwinding following -ENODEV has
>> an issue related to sysfs.
> I don't follow this comment..

I have encountered this error here, which gets masked when applying the 
previously shown patch.

[   58.270643] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000088
[   58.271017] IP: [<ffffffff812e9b7f>] kernfs_find_ns+0x1f/0x140
[   58.271017] PGD 0
[   58.271017] Oops: 0000 [#1] SMP
[   58.271017] Modules linked in: tpm_vtpm_proxy nf_conntrack_netbios_ns 
nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 
xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter 
ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
ip6table_mangle ip6table_security ip6table_raw ip6table_filter 
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw 
crc32c_intel tpm_tis joydev virtio_balloon i2c_piix4 pcspkr i2c_core 
tpm_tis_core tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc 8139too 
virtio_pci 8139cp virtio_ring ata_generic mii serio_raw pata_acpi virtio 
floppy
[   58.271017] CPU: 10 PID: 1420 Comm: vtpmctrl Not tainted 4.9.0-rc5+ #607
[   58.271017] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.9.0-156-g3560877 04/01/2014
[   58.271017] task: ffff8802abb58000 task.stack: ffffc90002604000
[   58.271017] RIP: 0010:[<ffffffff812e9b7f>] [<ffffffff812e9b7f>] 
kernfs_find_ns+0x1f/0x140
[   58.271017] RSP: 0018:ffffc90002607af8  EFLAGS: 00010292
[   58.271017] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
ffff8802abb58820
[   58.271017] RDX: 0000000000000000 RSI: ffffffff81885960 RDI: 
0000000000000000
[   58.271017] RBP: ffffc90002607b28 R08: 0000000000000000 R09: 
b39d2cf200000000
[   58.271017] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffffffff81885960
[   58.271017] R13: 0000000000000000 R14: ffffffff81885960 R15: 
ffff8802acaf4360
[   58.271017] FS:  0000000000000000(0000) GS:ffff8802b2480000(0000) 
knlGS:0000000000000000
[   58.271017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.271017] CR2: 0000000000000088 CR3: 0000000001c0a000 CR4: 
00000000000006e0
[   58.271017] Stack:
[   58.271017]  000000001efbca09 0000000000000000 ffffffff81885960 
0000000000000000
[   58.271017]  ffff8802b0168fe0 ffff8802acaf4360 ffffc90002607b50 
ffffffff812e9cd3
[   58.271017]  ffffffff81cf3dc0 ffff8802a8654000 0000000000000000 
ffffc90002607b70
[   58.271017] Call Trace:
[   58.271017]  [<ffffffff812e9cd3>] kernfs_find_and_get_ns+0x33/0x60
[   58.271017]  [<ffffffff812ed5dd>] sysfs_unmerge_group+0x1d/0x60
[   58.271017]  [<ffffffff8155bd32>] dpm_sysfs_remove+0x22/0x60
[   58.271017]  [<ffffffff8154e438>] device_del+0x58/0x280
[   58.271017]  [<ffffffffa024c020>] tpm_chip_unregister+0x40/0xb0 [tpm]
[   58.271017]  [<ffffffffa0292360>] vtpm_proxy_fops_release+0x40/0x60 
[tpm_vtpm_proxy]
[   58.271017]  [<ffffffff812671ff>] __fput+0xdf/0x1f0
[   58.271017]  [<ffffffff8126734e>] ____fput+0xe/0x10
[   58.271017]  [<ffffffff810c8cde>] task_work_run+0x7e/0xa0
[   58.271017]  [<ffffffff810ad5d8>] do_exit+0x2f8/0xb20
[   58.271017]  [<ffffffff810b98a2>] ? get_signal+0xc2/0x6d0
[   58.271017]  [<ffffffff810ade90>] do_group_exit+0x50/0xd0
[   58.271017]  [<ffffffff810b9a6f>] get_signal+0x28f/0x6d0
[   58.271017]  [<ffffffff8102f0b7>] do_signal+0x37/0x6a0
[   58.271017]  [<ffffffffa02924bb>] ? vtpm_proxy_fops_read+0x13b/0x1b0 
[tpm_vtpm_proxy]
[   58.271017]  [<ffffffff810f1570>] ? wake_atomic_t_function+0x70/0x70
[   58.271017]  [<ffffffff8137e74b>] ? security_file_permission+0x9b/0xc0
[   58.271017]  [<ffffffff810032b6>] exit_to_usermode_loop+0x76/0xb0
[   58.271017]  [<ffffffff81003c5f>] syscall_return_slowpath+0xaf/0xc0
[   58.271017]  [<ffffffff817a1a49>] entry_SYSCALL_64_fastpath+0xac/0xae
[   58.271017] Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
55 49 89 f8 48 89 e5 41 57 41 56 41 55 41 54 49 89 f6 53 49 89 d5 48 83 
ec 08 <44> 0f b7 a7 88 00 00 00 8b 05 13 af 9e 00 48 8b 5f 68 66 41 83
[   58.271017] RIP  [<ffffffff812e9b7f>] kernfs_find_ns+0x1f/0x140
[   58.271017]  RSP <ffffc90002607af8>
[   58.271017] CR2: 0000000000000088
[   58.271017] ---[ end trace 88bc09bcfa89f874 ]---
[   58.271017] Fixing recursive fault but reboot is needed!





------------------------------------------------------------------------------
