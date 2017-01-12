From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC v2 1/5] tpm: validate TPM 2.0 commands
Date: Thu, 12 Jan 2017 22:34:50 +0200
Message-ID: <20170112203450.exxpxypm6bmrvymi@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112174612.9314-2-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 07:46:04PM +0200, Jarkko Sakkinen wrote:
> Check for every TPM 2.0 command that the command code is supported and
> the command buffer has at least the length that can contain the header
> and the handle area.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I think this could be bundled with Stefans patch. It is fairly
independent of the rest of the patch set.

/Jarkko
