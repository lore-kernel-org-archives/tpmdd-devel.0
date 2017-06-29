From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] tpm: use tpm_buf functions in tpm2_pcr_read()
Date: Thu, 29 Jun 2017 22:54:56 +0300
Message-ID: <20170629195456.yesgplwa74l2e6pc@linux.intel.com>
References: <20170623134157.30399-1-roberto.sassu@huawei.com>
 <20170623134157.30399-2-roberto.sassu@huawei.com>
 <20170628221858.65mybzp6tyzh27g7@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170628221858.65mybzp6tyzh27g7@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 29, 2017 at 01:18:58AM +0300, Jarkko Sakkinen wrote:
> On Fri, Jun 23, 2017 at 03:41:56PM +0200, Roberto Sassu wrote:
> > tpm2_pcr_read() now builds the PCR read command buffer with tpm_buf
> > functions. This solution is preferred to using a tpm2_cmd structure,
> > as tpm_buf functions provide protection against buffer overflow.
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
