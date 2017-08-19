From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] msleep() delays - replace with usleep_range() in TPM
 1.2/2.0 generic drivers
Date: Sat, 19 Aug 2017 15:16:20 +0300
Message-ID: <20170819121620.4zxnvz5ki76jbbe4@linux.intel.com>
References: <20170814180916.GA5574@dev-HP-EliteBook-Folio-1040-G1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170814180916.GA5574@dev-HP-EliteBook-Folio-1040-G1>
Sender: owner-linux-security-module@vger.kernel.org
To: Hamza Attak <hamza@hpe.com>
Cc: tpmdd-devel@lists.sourceforge.net, nigel.edwards@hpe.com, ludo@hpe.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 14, 2017 at 07:09:16PM +0100, Hamza Attak wrote:
> The patch simply replaces all msleep function calls with usleep_range calls
> in the generic drivers.
> 
> Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a
> thousand PCR extends, we see results going from 1m57s unpatched to 40s
> with the new patch. We obtain similar results when using the original and
> patched tpm_infineon driver, which is also part of the patch.
> Similarly with a STM TPM 2.0, using the CRB driver, it takes about 20ms per
> extend unpatched and around 7ms with the new patch.
> 
> Note that the PCR consistency is untouched with this patch, each TPM has
> been tested with 10 million extends and the aggregated PCR value is
> continuously verified to be correct.
> 
> As an extension of this work, this could potentially and easily be applied
> to other vendor's drivers. Still, these changes are not included in the
> proposed patch as they are untested.
> 
> Signed-off-by: Hamza Attak <hamza@hpe.com>

Applying this.

Tested-by: Jarkko Sakkine <jarkko.sakkinen@linux.intel.com>

PS. Your short summary is broken. See how I fixed it. Otherwise,
no complains.

/Jarkko
