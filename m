From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: improve tpm_tis send() performance by ignoring
 burstcount
Date: Tue, 8 Aug 2017 22:11:45 +0300
Message-ID: <20170808191145.kggmoczd5laiccrn@linux.intel.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 07, 2017 at 01:52:34PM +0200, Peter Huewe wrote:
> 
> 
> Am 7. August 2017 13:46:32 MESZ schrieb Nayna Jain <nayna@linux.vnet.ibm.com>:
> >The TPM burstcount status indicates the number of bytes that can
> >be sent to the TPM without causing bus wait states.  Effectively,
> >it is the number of empty bytes in the command FIFO. Further,
> >some TPMs have a static burstcount, when the value remains zero
> >until the entire FIFO is empty.
> >
> >This patch ignores burstcount, permitting wait states, and thus
> >writes the command as fast as the TPM can accept the bytes.
> >The performance of a 34 byte extend on a TPM 1.2 improved from
> >52 msec to 11 msec.
> >
> >Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
> >conjunction with the TPM Device Driver work group.
> >Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> >Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> 
> Are you sure this is a good idea?
> On lpc systems this more or less stalls the bus, including keyboard/mouse (if connected via superio lpc).
> 
> On which systems have you tested this?
> Spi/Lpc? Architecture?
> 
> This might not be noticable for small transfers, but think about much larger transfers....
> 
> Imho: NACK from my side.
> 
> Thanks,
> Peter

Thanks Peter, a great insight. TPM could share the bus with other
devices. Even if this optimizes the performace for TPM it might cause
performance issues elsewhere.

One more viewpoint: TCG must added the burst count for a reason (might
be very well related what Peter said). Is ignoring it something that TCG
recommends? Not following standard exactly in the driver code sometimes
makes sense on *small details* but I would not say that this a small
detail...

After these viewpoints definitive NACK from my side too...

/Jarkko

/Jarkko
