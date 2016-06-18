From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/2] Fixes for sparse reported warnings
Date: Sat, 18 Jun 2016 14:20:13 +0200
Message-ID: <20160618122013.GA18014@intel.com>
References: <1466174369-7140-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466174369-7140-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 17, 2016 at 04:39:27PM +0200, Jarkko Sakkinen wrote:
> Jarkko Sakkinen (2):
>   tpm_vtpm_proxy: fix address space of a user pointer in
>     vtpmx_fops_ioctl()
>   tpm_crb: fix address space of the return pointer in crb_map_res()

Merged to next.

/Jarkko
