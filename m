From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: fix RC value check in tpm2_seal_trusted
Date: Wed, 25 Jan 2017 15:12:45 -0700
Message-ID: <20170125221245.GB713@obsidianresearch.com>
References: <20170125210348.13790-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125210348.13790-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 11:03:48PM +0200, Jarkko Sakkinen wrote:
> Fixes: 5ca4c20cfd37 ("keys, trusted: select hash algorithm for TPM2 chips")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I think you need a commit message for this.. Is this following the
spec?

Jason
