From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm: use tpm2_pcr_read() in
 tpm2_do_selftest()
Date: Thu, 29 Jun 2017 22:56:07 +0300
Message-ID: <20170629195607.n7w7houaw5vr7fji@linux.intel.com>
References: <20170623134157.30399-1-roberto.sassu@huawei.com>
 <20170623134157.30399-3-roberto.sassu@huawei.com>
 <20170628221935.joqqxrohskhq3kj6@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170628221935.joqqxrohskhq3kj6@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 29, 2017 at 01:19:35AM +0300, Jarkko Sakkinen wrote:
> On Fri, Jun 23, 2017 at 03:41:57PM +0200, Roberto Sassu wrote:
> > tpm2_do_selftest() performs a PCR read during the TPM initialization phase.
> > This patch replaces the PCR read code with a call to tpm2_pcr_read().
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>

Tested-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>

/Jarkko
