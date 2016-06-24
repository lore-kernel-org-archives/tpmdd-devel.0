From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/5] tpm: unify tpm_gen_interrupt()
Date: Fri, 24 Jun 2016 13:30:24 -0600
Message-ID: <20160624193024.GA563@obsidianresearch.com>
References: <1466197847-4937-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1466197847-4937-2-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466197847-4937-2-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 17, 2016 at 11:10:43PM +0200, Jarkko Sakkinen wrote:
>  extern int tpm_get_timeouts(struct tpm_chip *);
> -extern void tpm_gen_interrupt(struct tpm_chip *);
> +void tpm_gen_interrupt(struct tpm_chip *);

Dropping the argument name is not the kernel standard, if these lines
are going to be churned they may as well be churned to the standard.

FWIW, all the extern's should be dropped too.

Jason
