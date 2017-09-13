From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/3] tpm: fix type of a local variable in
 tpm2_get_cc_attrs_tbl()
Date: Wed, 13 Sep 2017 12:14:21 -0600
Message-ID: <20170913181421.GA1536@obsidianresearch.com>
References: <20170913172620.24829-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913172620.24829-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 13, 2017 at 10:26:20AM -0700, Jarkko Sakkinen wrote:
> The local variable 'attrs' should have the type __be32 instead of u32.
> 
> Fixes: 58472f5cd4f6 ("tpm: validate TPM 2.0 commands")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

All 3 look good to me:

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
