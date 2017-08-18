From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] tpm: vtpm: constify vio_device_id
Date: Fri, 18 Aug 2017 21:32:46 +1000
Message-ID: <87ziaxp0v5.fsf@concordia.ellerman.id.au>
References: <a9ebcd668f5a7293c3805d0b6b21245f15c80212.1502989694.git.arvind.yadav.cs@gmail.com> <20170817191642.GF24735@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170817191642.GF24735@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: tpmdd@selhorst.net, linux-kernel@vger.kernel.org, jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net, ashleydlai@gmail.com, peterhuewe@gmx.de, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

Jason Gunthorpe <jgunthorpe@obsidianresearch.com> writes:

> On Thu, Aug 17, 2017 at 11:04:21PM +0530, Arvind Yadav wrote:
>> vio_device_id are not supposed to change at runtime. All functions
>> working with vio_device_id provided by <asm/vio.h> work with
>> const vio_device_id. So mark the non-const structs as const.
>> 
>> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks Jason.

>>  drivers/char/tpm/tpm_ibmvtpm.c | 2 +-

Who merges changes for this driver? I assume it's Jarkko?

cheers
