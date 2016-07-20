From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 3/5] tpm: replace tpm_gen_interrupt() with
 tpm_tis_gen_interrupt()
Date: Wed, 20 Jul 2016 23:54:10 +0300
Message-ID: <20160720205410.GB6525@intel.com>
References: <1468971906-6528-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1468971906-6528-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160720170624.GE21460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160720170624.GE21460@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 20, 2016 at 11:06:24AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 20, 2016 at 02:44:58AM +0300, Jarkko Sakkinen wrote:
> > Since tpm_gen_interrupt() is only used in tpm_tis_core.c this commit
> > replaces it with an internal tpm_tis_gen_interrupt(). The semantics
> > also changed in a way that on a system error the driver initialization
> > is failed.
> 
> All the patches look good to me now..
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks.

/Jarkko
