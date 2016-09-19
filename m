From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/2] tpm: Clean up reading of timeout and duration
 capabilities
Date: Mon, 19 Sep 2016 17:24:06 -0600
Message-ID: <20160919232406.GE22760@obsidianresearch.com>
References: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1474316530-17315-2-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474316530-17315-2-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ed Swierk <eswierk@skyportsystems.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 19, 2016 at 11:22:08PM +0300, Jarkko Sakkinen wrote:
> From: Ed Swierk <eswierk@skyportsystems.com>
> 
> Call tpm_getcap() from tpm_get_timeouts() to eliminate redundant
> code. Return all errors to the caller rather than swallowing them
> (e.g. when tpm_transmit_cmd() returns nonzero).

I didn't look at these closely, but I agree with the idea.

Jason
