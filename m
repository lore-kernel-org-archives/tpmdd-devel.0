From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] tpm_crb: fix address space of the return pointer in
 crb_map_res()
Date: Fri, 17 Jun 2016 10:43:30 -0400
Message-ID: <57640C92.1010803@linux.vnet.ibm.com>
References: <1466174369-7140-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1466174369-7140-3-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466174369-7140-3-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 06/17/2016 10:39 AM, Jarkko Sakkinen wrote:
> When running make C=2 M=drivers/char/tpm/
>
>    CHECK   drivers/char/tpm//tpm_crb.c
> drivers/char/tpm//tpm_crb.c:248:31: warning: incorrect type in return expression (different address spaces)
> drivers/char/tpm//tpm_crb.c:248:31:    expected void [noderef] <asn:2>*
> drivers/char/tpm//tpm_crb.c:248:31:    got void *
>
> Fixes: 1bd047be37d9 ("tpm_crb: Use devm_ioremap_resource")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
