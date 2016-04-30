From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] tpm: use devm_add_action_or_reset
Date: Sat, 30 Apr 2016 18:00:25 +0100
Message-ID: <20160430170025.GB25043@sudip-laptop>
References: <1461617198-32351-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160426083014.GA29628@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160426083014.GA29628@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 26, 2016 at 11:30:14AM +0300, Jarkko Sakkinen wrote:
> On Mon, Apr 25, 2016 at 09:46:38PM +0100, Sudip Mukherjee wrote:
> > If devm_add_action() fails we are explicitly calling the cleanup function
> > in the error path. Lets use the helper function devm_add_action_or_reset()
> > and return directly as we know the cleanup has been done by the helper.
> 
> Have you verified that this compiles against my tree?

This was done against linux-next. But now I have just rebased against
the charmisc tree and sent v2. Also added the Reviewed-by tag to it.
(hope thats ok)

regards
sudip
