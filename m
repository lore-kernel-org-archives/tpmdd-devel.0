From: Andy Lutomirski <luto@amacapital.net>
Subject: tpm_tis regression in 4.9?
Date: Thu, 27 Oct 2016 17:33:57 -0700
Message-ID: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi-

I think this error on my laptop is new on 4.9 kernels:

[  +0.014696] tpm_tis 00:09: 1.2 TPM (device-id 0xFE, rev-id 2)
[  +0.012228] tpm tpm0: TPM self test failed
[  +0.000019] tpm_tis: probe of 00:09 failed with error -14

Is this known?

At the very least, shouldn't the error message include rc?

--Andy
