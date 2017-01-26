From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: fix RC value check in tpm2_seal_trusted
Date: Thu, 26 Jan 2017 11:32:52 -0700
Message-ID: <20170126183252.GA16502@obsidianresearch.com>
References: <20170125210348.13790-1-jarkko.sakkinen@linux.intel.com>
 <20170125221245.GB713@obsidianresearch.com>
 <20170126112714.xvvvb72dybmfgitw@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170126112714.xvvvb72dybmfgitw@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 26, 2017 at 01:27:14PM +0200, Jarkko Sakkinen wrote:

> "The error code handling is bogus as any error code that has the bits
> set that TPM_RC_HASH could pass. Implemented tpm2_rc_value() helper to
> parse the error value from FMT0 and FMT1 error codes to use to check the
> error so that these types of mistakes is prevented in the future."

Great thanks

Jason
