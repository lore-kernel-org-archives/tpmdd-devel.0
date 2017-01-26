From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix RC value check in tpm2_seal_trusted
Date: Thu, 26 Jan 2017 13:27:14 +0200
Message-ID: <20170126112714.xvvvb72dybmfgitw@intel.com>
References: <20170125210348.13790-1-jarkko.sakkinen@linux.intel.com>
 <20170125221245.GB713@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125221245.GB713@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 03:12:45PM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 25, 2017 at 11:03:48PM +0200, Jarkko Sakkinen wrote:
> > Fixes: 5ca4c20cfd37 ("keys, trusted: select hash algorithm for TPM2 chips")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> I think you need a commit message for this.. Is this following the
> spec?

Yes.

Format one commands the upper bits contain either handle, session or
parameter index. Bit 7 tells whether it the error code is format zero or
one. Format zero errors do not require masking. They do not have any
data in addition to value.

The reason why this bug was repeated in TPM space code was that I
originally melded that code form my trusted keys code (copy pasted and
edited message construction).

"The error code handling is bogus as any error code that has the bits
set that TPM_RC_HASH could pass. Implemented tpm2_rc_value() helper to
parse the error value from FMT0 and FMT1 error codes to use to check the
error so that these types of mistakes is prevented in the future."

Is that suitable or do you want me to add something?

Jarkko
