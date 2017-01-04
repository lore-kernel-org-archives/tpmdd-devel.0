From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Wed, 04 Jan 2017 11:05:35 -0800
Message-ID: <1483556735.2561.53.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
	<1483553976.2561.38.camel@linux.vnet.ibm.com>
	<OF3FD1DF4F.FB87C3F2-ON0025809E.00682E9B-8525809E.00684A8A@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <OF3FD1DF4F.FB87C3F2-ON0025809E.00682E9B-8525809E.00684A8A-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-04 at 13:59 -0500, Stefan Berger wrote:
> [   67.699811] WARNING: CPU: 12 PID: 870 at mm/page_alloc.c:3511 

What's the code context around this line in your source?  Or what
kernel version?  If it's this

	if (order >= MAX_ORDER) {
		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
		return NULL;
	}

Then I think you may have returned bogus data to TPM_PT_TOTAL_COMMANDS;
perhaps print nr_commands.

James

> __alloc_pages_slowpath+0x771/0xaf0
> [   67.701198] Modules linked in:
> [   67.701400]  tpm_vtpm_proxy
> [   67.701642]  nf_conntrack_netbios_ns nf_conntrack_broadcast
> [   67.702450]  ip6t_rpfilter
> [   67.702662]  ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat
> [   67.703618]  ebtable_broute
> [   67.703784]  bridge stp llc ebtable_filter
> [   67.704213]  ebtables
> [   67.704367]  ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
> [   67.705310]  nf_nat_ipv6
> [   67.705523]  ip6table_mangle ip6table_security ip6table_raw 
> ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 
> nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security 
> iptable_raw nfsd auth_rpcgss nfs_acl lockd crc32c_intel tpm_tis 
> virtio_balloon i2c_piix4 tpm_tis_core
> [   67.711414]  i2c_core
> [   67.711610]  joydev tpm pcspkr grace sunrpc
> [   67.712170]  8139too
> [   67.712360]  virtio_pci 8139cp virtio_ring serio_raw
> [   67.713504]  ata_generic
> [   67.713706]  mii floppy pata_acpi virtio
> [   67.714891] CPU: 12 PID: 870 Comm: kworker/12:2 Not tainted 4.9.0
> -rc5+ 
> #652
> [   67.715054] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 
> rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
> [   67.715054] Workqueue: tpm-vtpm vtpm_proxy_work [tpm_vtpm_proxy]
> [   67.715054]  ffffc90002b6fa80 ffffffff8140cad1
> [   67.715054]  0000000000000000
> [   67.715054]  0000000000000000
> [   67.715054]  ffffc90002b6fac0 ffffffff810a8b6b 00000db7aba7d298 
> 00000000026000c0
> [   67.715054]  0000000000000000 0000000000000014 000000000260c0c0 
> ffff8802aba7ca00
> [   67.715054] Call Trace:
> [   67.715054]  [<ffffffff8140cad1>] dump_stack+0x63/0x82
> [   67.715054]  [<ffffffff810a8b6b>] __warn+0xcb/0xf0
> [   67.715054]  [<ffffffff810a8c9d>] warn_slowpath_null+0x1d/0x20
> [   67.715054]  [<ffffffff811da6f1>]
> __alloc_pages_slowpath+0x771/0xaf0
> [   67.715054]  [<ffffffff811d95e6>] ?
> get_page_from_freelist+0x526/0xaf0
> [   67.715054]  [<ffffffff8179e583>] ?
> __mutex_unlock_slowpath+0xe3/0x1a0
> [   67.715054]  [<ffffffff811dad9f>]
> __alloc_pages_nodemask+0x32f/0x390
> [   67.715054]  [<ffffffff8123a4fe>] kmalloc_large_node+0x7e/0xe0
> [   67.715054]  [<ffffffff81241885>] 
> __kmalloc_node_track_caller+0x225/0x2c0
> [   67.715054]  [<ffffffffa00c0f42>] ? tpm2_auto_startup+0xa2/0x2e0
> [tpm]
> [   67.715054]  [<ffffffff815572b7>] devm_kmalloc+0x27/0x70
> [   67.715054]  [<ffffffffa00c0f42>] tpm2_auto_startup+0xa2/0x2e0
> [tpm]
> [   67.715054]  [<ffffffffa00bf3bc>] tpm_chip_register+0x5c/0x200
> [tpm]
> [   67.715054]  [<ffffffffa029c309>] vtpm_proxy_work+0x19/0x40 
> [tpm_vtpm_proxy]
> [   67.715054]  [<ffffffff810c4593>] process_one_work+0x1f3/0x560
> [   67.715054]  [<ffffffff810c4511>] ? process_one_work+0x171/0x560
> [   67.715054]  [<ffffffff810c494e>] worker_thread+0x4e/0x480
> [   67.715054]  [<ffffffff810c4900>] ? process_one_work+0x560/0x560
> [   67.715054]  [<ffffffff810c4900>] ? process_one_work+0x560/0x560
> [   67.715054]  [<ffffffff810ca994>] kthread+0xf4/0x110
> [   67.715054]  [<ffffffff810ca8a0>] ? kthread_park+0x60/0x60
> [   67.715054]  [<ffffffff817a1c15>] ret_from_fork+0x25/0x30
> [   67.746343] ---[ end trace 4d9abf66365987bd ]---
> 
> 
> 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
