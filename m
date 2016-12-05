From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 3/3] tpm_crb: request and relinquish locality 0
Date: Mon, 5 Dec 2016 09:32:35 -0700
Message-ID: <20161205163235.GA24852@obsidianresearch.com>
References: <20161203175213.10210-1-jarkko.sakkinen@linux.intel.com>
 <20161203175213.10210-4-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161203175213.10210-4-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Dec 03, 2016 at 07:52:13PM +0200, Jarkko Sakkinen wrote:
> +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);

Since regs_h can be null shouldn't there be some guards ?

Jason
