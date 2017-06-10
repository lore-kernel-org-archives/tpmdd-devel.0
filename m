From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4] tpm: Enable CLKRUN protocol for Braswell systems
Date: Sat, 10 Jun 2017 14:13:39 +0300
Message-ID: <20170610111339.ggphrkwqiez35wer@intel.com>
References: <1496369044-38234-1-git-send-email-azhar.shaikh@intel.com>
 <1496965593-187931-1-git-send-email-azhar.shaikh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496965593-187931-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Azhar Shaikh <azhar.shaikh@intel.com>
Cc: jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 08, 2017 at 04:46:33PM -0700, Azhar Shaikh wrote:
> To overcome a hardware limitation on Intel Braswell systems,
> disable CLKRUN protocol during TPM transactions and re-enable
> once the transaction is completed.
> 
> Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
> ---
> Changes from v1:
> - Add CONFIG_X86 around disable_lpc_clk_run () and enable_lpc_clk_run() to avoid
> - build breakage on architectures which do not implement kmap_atomic_pfn()
> 
> Changes from v2:
> - Use ioremap()/iounmap() instead of kmap_atomic_pfn()/kunmap_atomic()
> - Move is_bsw() and all macros from tpm.h to tpm_tis.c file.
> - Add the is_bsw() check in disable_lpc_clk_run() and enable_lpc_clk_run()
> - instead of adding it in each read/write API.
> 
> Changes from v3:
> - Move the code under #ifdef CONFIG_X86 and create stub functions for everything else
> - Rename the functions disable_lpc_clk_run() -> tpm_platform_begin_xfer() and
> - enable_lpc_clk_run() -> tpm_platform_end_xfer()
> - Remove wmb()

The wrong parameter order in outb() is not worth of mentioning in your
opinion?

Related.

I looked again the kmap version of the patch and still cannot figure
out what could be wrong. Obviously the wrong outb() cause unexpected
behavior.

Do you have chances to grab klog from kmap version with correct outb?

/Jarkko
