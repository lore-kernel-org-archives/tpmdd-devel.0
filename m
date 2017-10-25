From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Wed, 25 Oct 2017 09:22:25 -0600
Message-ID: <20171025152225.GC15557@obsidianresearch.com>
References: <20171025115508.5682-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171025115508.5682-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, David Safford <safford@us.ibm.com>, David Howells <dhowells@redhat.com>, Jerry Snitselaar <jsnitsel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 25, 2017 at 01:55:04PM +0200, Jarkko Sakkinen wrote:
> Device number (the character device index) is not a stable identifier
> for a TPM chip. That is the reason why every call site passes
> TPM_ANY_NUM to tpm_chip_find_get().
> 
> This commit changes the API in a way that instead a struct tpm_chip
> instance is given and NULL means the default chip. In addition, this
> commit refines the documentation to be up to date with the
> implementation.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com> (@chip_num -> @chip)
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> v2:
> * Further defined function documentation.
> * Changed @chip_num to @chip instead of removing the parameter as suggested by
>   Jason Gunthorpe.

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
