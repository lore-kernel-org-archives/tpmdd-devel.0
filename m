From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/3] tpm: move PCR read code to static function
 tpm2_pcr_read_common()
Date: Wed, 4 Oct 2017 13:45:14 +0300
Message-ID: <20171004104514.udehflbyjaebxd3j@linux.intel.com>
References: <20170925111950.21511-1-roberto.sassu@huawei.com>
 <20170925111950.21511-2-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925111950.21511-2-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 25, 2017 at 01:19:48PM +0200, Roberto Sassu wrote:
> tpm2_pcr_read() copies the digest stored in a PCR to a buffer provided by
> the caller. However, it does not return the digest size, included in the
> output from the TPM. Retrieving it would be useful when a TPM algorithm
> is not known by the crypto subsystem, which the TPM driver currently
> depends upon.

Remove this paragraph. It is just generic nonsense.

> Most of tpm2_pcr_read() code is moved to the static function
> tpm2_pcr_read_common(), which writes the output of the PCR read to the
> tpm_buf structure passed as input.
> 
> tpm2_pcr_read_common() will be called by tpm2_pcr_read(), and by the new
> function tpm2_init_active_bank_info(), which will store the identifier
> and the digest size of TPM algorithms in the tpm_chip structure.

1. Export tpm_buf to arch/x86/include/linux/tpm.h
2. Repeal and replace tpm2_pcr_read().

I would just pass one tpm_buf (i.e. no u8* res_buf) that is used both
for input and output.

Speaking about tpm2_inti_active_bank_info(), which is a *nonexistent*
function is questionable. For me a sufficient commit message would be
something like:

"
tpm: refine tpm2_pcr_read() access to all PCR banks

Refine tpm2_pcr_read() interface and implementation in order to enable
access to all PCR banks for other kernel subsystems such as IMA.
"

That describes all there is in this commit.

/Jarkko
