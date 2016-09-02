From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: invalid self test error message
Date: Fri, 2 Sep 2016 11:07:10 -0600
Message-ID: <20160902170710.GD24997@obsidianresearch.com>
References: <1472795790-15131-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472795790-15131-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 08:56:29AM +0300, Jarkko Sakkinen wrote:
> The driver emits invalid self test error message even though the init
> succeeds.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Fixes: cae8b441fc20 ("tpm: Factor out common startup code")

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reported-by: Petr Vandrovec <petr@vmware.com>

Jason
