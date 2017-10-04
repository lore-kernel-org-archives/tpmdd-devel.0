From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/3] tpm: retrieve digest size of unknown algorithms from
 TPM
Date: Wed, 4 Oct 2017 10:32:58 +0300
Message-ID: <20171004073258.be2j7mdeud2pjbyk@linux.intel.com>
References: <20170925111950.21511-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925111950.21511-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

And apologies for late review.

On Mon, Sep 25, 2017 at 01:19:47PM +0200, Roberto Sassu wrote:
> This patch set derives from a larger patch set which modifies the TPM
> driver API in order to extend a PCR with multiple digests. It can be
> retrieved at the URL:
> 
> https://sourceforge.net/p/tpmdd/mailman/message/35905412/

A patch set should be able to live on its own. Please remove this link.

I don't care about that patch set at this point and I'm not going to
give any distant promises.

> The TPM driver currently relies on the crypto subsystem to determine the
> digest size of supported TPM algorithms. In the future, TPM vendors might
> implement new algorithms in their chips, and those algorithms might not
> be supported by the crypto subsystem.
> 
> Usually, vendors provide patches for the new hardware, and likely
> the crypto subsystem will be updated before the new algorithm is
> introduced. However, old kernels might be updated later, after patches
> are included in the mainline kernel. This would leave the opportunity
> for attackers to misuse PCRs, as PCR banks with an unknown algorithm
> are not extended.
> 
> This patch set provides a long term solution for this issue. If a TPM
> algorithm is not known by the crypto subsystem, the TPM driver retrieves
> the digest size from the TPM with a PCR read. All the PCR banks are
> extended, even if the algorithm is not yet supported by the crypto
> subsystem.

This part makes sense to me.

/Jarkko
