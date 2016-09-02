From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 4/4] tpm_crb: fix incorrect values of cmdReady and goIdle
 bits
Date: Fri, 2 Sep 2016 22:41:00 +0300
Message-ID: <20160902194100.GA25014@intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1472844861-24599-5-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472844861-24599-5-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 10:34:20PM +0300, Jarkko Sakkinen wrote:
> CRB_CTRL_CMD_READY and CRB_CTRL_GO_IDLE have incorrect values.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Fixes: 30fc8d138e91 ("tpm: TPM 2.0 CRB Interface")
Cc: stable@vger.kernel.org

/Jarkko
