From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: make check_locality return bool
Date: Wed, 22 Mar 2017 13:24:54 +0200
Message-ID: <20170322112454.3bcdbqoxrxy4kfev@intel.com>
References: <20170318085957.12277-1-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170318085957.12277-1-jsnitsel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Marcel Selhorst <tpmdd@selhorst.net>, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 18, 2017 at 01:59:57AM -0700, Jerry Snitselaar wrote:
> Since check_locality is checking to see if a certain
> locality is active, return true if active otherwise
> return false.
> 
> Cc: Christophe Ricard <christophe.ricard@gmail.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Marcel Selhorst <tpmdd@selhorst.net>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> ---
> Tested tpm_tis, but don't have the ability to
> test Infineon or STMicro drivers.

Thanks.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> 
(with a TPM 1.2 chip on Dell E6400 laptop)

/Jarkko
