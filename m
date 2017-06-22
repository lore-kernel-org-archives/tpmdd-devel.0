From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: consolidate the TPM startup code
Date: Thu, 22 Jun 2017 12:02:56 +0200
Message-ID: <20170622100256.ehlcwkjp4iduxkbm@linux.intel.com>
References: <20170621073134.7436-1-jarkko.sakkinen@linux.intel.com>
 <1ff1a552-15a9-d8a6-3bcd-3c0f9ff6d71e@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ff1a552-15a9-d8a6-3bcd-3c0f9ff6d71e@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 21, 2017 at 07:04:53AM -0400, Stefan Berger wrote:
> On 06/21/2017 03:31 AM, Jarkko Sakkinen wrote:
> > Consolidated all the "manual" TPM startup code to a single function
> > in order to make code flows a bit cleaner and migrate to tpm_buf.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> 
> 
> FYI:
> swtpm chardev --vtpm-proxy  --tpmstate dir=/tmp --log level=1 --tpm2
> swtpm chardev --vtpm-proxy  --tpmstate dir=/tmp --log level=1

Thank you! I will also add your Tested-by to

- https://patchwork.kernel.org/patch/9799059/
- https://patchwork.kernel.org/patch/9799057/

I'm in the process of enhancing my BuildRoot enviroment with libtpms and
swtpm packages. My first target is TPM 1.2 test environment by using
tpm_vtpm_proxy driver.

http://git.infradead.org/users/jjs/buildroot-tpmdd.git

Should be easy as you have nicely autooled projects :-)

/Jarkko
