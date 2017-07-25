From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [tpmdd-devel] tpm: read burstcount from TPM_STS in one 32-bit
 transaction
Date: Tue, 25 Jul 2017 20:17:58 +0200
Message-ID: <20170725201758.230de968@kitsune.suse.cz>
References: <20170725150443.7cf8fc91@kitsune.suse.cz>
        <1501004171.3689.25.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501004171.3689.25.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Christophe Ricard <christophe.ricard@gmail.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, apronin@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 25 Jul 2017 10:36:11 -0700
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Tue, 2017-07-25 at 15:04 +0200, Michal Suchánek wrote:
> > Hello,
> > 
> > in commit 9754d45e9970 ("tpm: read burstcount from TPM_STS in one
> > 32-bit transaction") you change reading of two 8-bit values to one
> > 32bit read. This is obviously wrong wrt endianess unless the
> > underlying tpm_tis_read32 does endian conversion.   
> 
> Some of the bus read primitives do do endianness conversions.  The
> problem is with the SPI attachment, which has unclear endianness.  A
> standard PCI bus attachment uses ioread32() which automatically
> transforms from a little endian bus to the cpu endianness, however SPI
> is forced to transfer the bytes one at a time over the serial bus and
> then transform.  The assumption seems to be that the TIS TPM is
> replying in little endian format when SPI connected.
> 

Yes, that makes sense.

Thanks for clarification.

Michal
