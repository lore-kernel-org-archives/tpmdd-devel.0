From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_vtpm_proxy: fix sparse warning
Date: Thu, 16 Jun 2016 22:34:13 +0200
Message-ID: <20160616203413.GH1414@intel.com>
References: <1466073474-4381-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <5762AC1A.8050702@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5762AC1A.8050702@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 16, 2016 at 09:39:38AM -0400, Stefan Berger wrote:
> On 06/16/2016 06:37 AM, Jarkko Sakkinen wrote:
> >When running make C=2 M=drivers/char/tpm/
> >
> >   CC [M]  drivers/char/tpm//tpm_crb.o
> >   CHECK   drivers/char/tpm//tpm_vtpm_proxy.c
> >drivers/char/tpm//tpm_vtpm_proxy.c:552:32: warning: incorrect type in assignment (different address spaces)
> >drivers/char/tpm//tpm_vtpm_proxy.c:552:32:    expected struct vtpm_proxy_new_dev *vtpm_new_dev_p
> >drivers/char/tpm//tpm_vtpm_proxy.c:552:32:    got void [noderef] <asn:1>*argp
> >drivers/char/tpm//tpm_vtpm_proxy.c:553:51: warning: incorrect type in argument 2 (different address spaces)
> >drivers/char/tpm//tpm_vtpm_proxy.c:553:51:    expected void const [noderef] <asn:1>*from
> >drivers/char/tpm//tpm_vtpm_proxy.c:553:51:    got struct vtpm_proxy_new_dev *vtpm_new_dev_p
> >drivers/char/tpm//tpm_vtpm_proxy.c:559:34: warning: incorrect type in argument 1 (different address spaces)
> >drivers/char/tpm//tpm_vtpm_proxy.c:559:34:    expected void [noderef] <asn:1>*to
> >drivers/char/tpm//tpm_vtpm_proxy.c:559:34:    got struct vtpm_proxy_new_dev *vtpm_new_dev_p
> >
> >The __user annotation was missing from the corresponding variable.
> >
> >Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> 
> PS: I get similar warnings for line 248 in tpm_crb.c.

Yup, I'll proceed to that next. Thank you.

/Jarkko
