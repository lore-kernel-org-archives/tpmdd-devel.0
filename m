From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2, RESEND 3/3] tpm: move TPM 1.2 code of
 tpm_pcr_extend() to tpm1_pcr_extend()
Date: Fri, 5 May 2017 13:55:44 +0300
Message-ID: <20170505105544.c33f2vbaybe4th5s@intel.com>
References: <20170503161911.17606-1-roberto.sassu@huawei.com>
 <20170504111647.9384-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170504111647.9384-1-roberto.sassu@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 04, 2017 at 01:16:47PM +0200, Roberto Sassu wrote:
> In preparation of the modifications to tpm_pcr_extend(), which will
> allow callers to supply a digest for each PCR bank of a TPM 2.0,
> the TPM 1.2 specific code has been moved to tpm1_pcr_extend().
> 
> tpm1_pcr_extend() uses tpm_buf_init() to prepare the command buffer,
> which offers protection against buffer overflow. It is called by
> tpm_pcr_extend() and tpm_pm_suspend().
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
