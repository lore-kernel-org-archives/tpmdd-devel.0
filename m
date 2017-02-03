From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux 4.11
Date: Sat, 4 Feb 2017 10:34:48 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1702041034330.16611@namei.org>
References: <20170203204155.wjycqoojowivn24u@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170203204155.wjycqoojowivn24u@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 3 Feb 2017, Jarkko Sakkinen wrote:

> Hi
> 
> This is the second flush of updates for 4.11. 
> 
> The pull request include two new features:
> 
> 1. Extension to tpm_pcr_extend() (used by IMA) to extend all PCR banks
> instead of just SHA-1 banks. It is recommended by TCG to do so in order
> to prevent malicious use of PCRs.
> 2. TPM 2.0 event log with backend support for OF device tree.
> 
> /Jarkko
> 
> The following changes since commit 20f482ab9e0f800d1e01ce748ebd382d085abe56:
> 
>   ima: allow to check MAY_APPEND (2017-01-27 14:17:21 -0500)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170204
> 

Pulled, thanks!

-- 
James Morris
<jmorris@namei.org>

