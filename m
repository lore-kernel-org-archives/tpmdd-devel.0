From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: remove tpm_read_index and tpm_write_index from tpm.h
Date: Wed, 25 Jan 2017 09:55:11 -0700
Message-ID: <20170125165511.GA16579@obsidianresearch.com>
References: <20170125144858.24889-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125144858.24889-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 04:48:58PM +0200, Jarkko Sakkinen wrote:
> These are non-generic functions and do not belong to tpm.h.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
