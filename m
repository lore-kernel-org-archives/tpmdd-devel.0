From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: improve tpm_tis send() performance by ignoring
 burstcount
Date: Wed, 9 Aug 2017 00:50:10 +0300
Message-ID: <20170808214638.4cbws5uogtihhtzg@linux.intel.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <5988786D.3080301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5988786D.3080301@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 07, 2017 at 07:55:49PM +0530, Nayna wrote:
> 
> 
> On 08/07/2017 05:22 PM, Peter Huewe wrote:
> > 
> > 
> > Am 7. August 2017 13:46:32 MESZ schrieb Nayna Jain <nayna@linux.vnet.ibm.com>:
> > > The TPM burstcount status indicates the number of bytes that can
> > > be sent to the TPM without causing bus wait states.  Effectively,
> > > it is the number of empty bytes in the command FIFO. Further,
> > > some TPMs have a static burstcount, when the value remains zero
> > > until the entire FIFO is empty.
> > > 
> > > This patch ignores burstcount, permitting wait states, and thus
> > > writes the command as fast as the TPM can accept the bytes.
> > > The performance of a 34 byte extend on a TPM 1.2 improved from
> > > 52 msec to 11 msec.
> > > 
> > > Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
> > > conjunction with the TPM Device Driver work group.
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > 
> > Are you sure this is a good idea?
> > On lpc systems this more or less stalls the bus, including keyboard/mouse (if connected via superio lpc).
> 
> Thanks Peter for quick response.
> 
> I actually meant to post this patch as RFC. Sorry, missed that.
> It was meant to be a starting place for the discussion related to
> burst_count.
> 
> > 
> > On which systems have you tested this?
> > Spi/Lpc? Architecture?
> 
> Tested it with LPC on x86.
> 
> > 
> > This might not be noticable for small transfers, but think about much larger transfers....
> 
> I did the following testing:
> 
> * Ran a script with 1000 extends. This was to test continuous extends
> which are generally in large numbers when IMA is enabled.
> 
> * Ran a command to ask TPM to hash big size file like 1MB. This was to
> test the long command.
> 
> In both of the above cases, I didn't face any tpm specific errors.
> 
> Is there any test-script or test-cases which I can try to test the
> scenario(stalling the bus, including keyboard/mouse) with the patch ?
> 
> Thanks & Regards,
>    - Nayna

My stand here is that if you want to such patch included there should
be outstanding evidence that:

- Burst count could be always safely ignored.
- There's no hardware platform including TPM that assumes that driver
  takes the burst count into account.

My main concern is stability and only if the stability is not at risk
we can consider this. There's no test script to take care all of this.

/Jarkko
