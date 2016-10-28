From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: tpm_tis regression in 4.9?
Date: Fri, 28 Oct 2016 17:36:45 +0300
Message-ID: <20161028143645.oosfrdzoqbmuoxil@intel.com>
References: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 27, 2016 at 05:33:57PM -0700, Andy Lutomirski wrote:
> Hi-
> 
> I think this error on my laptop is new on 4.9 kernels:
> 
> [  +0.014696] tpm_tis 00:09: 1.2 TPM (device-id 0xFE, rev-id 2)
> [  +0.012228] tpm tpm0: TPM self test failed
> [  +0.000019] tpm_tis: probe of 00:09 failed with error -14
> 
> Is this known?
> 
> At the very least, shouldn't the error message include rc?

It is known:

http://www.spinics.net/lists/kernel/msg2356176.html

> --Andy

/Jarkko
