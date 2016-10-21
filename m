From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] tpm: Clean up reading of timeout and duration
 capabilities
Date: Fri, 21 Oct 2016 23:33:44 +0300
Message-ID: <20161021203344.v76buscn5y377wjx@intel.com>
References: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1474316530-17315-2-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160919232406.GE22760@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160919232406.GE22760@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ed Swierk <eswierk@skyportsystems.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 19, 2016 at 05:24:06PM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 19, 2016 at 11:22:08PM +0300, Jarkko Sakkinen wrote:
> > From: Ed Swierk <eswierk@skyportsystems.com>
> > 
> > Call tpm_getcap() from tpm_get_timeouts() to eliminate redundant
> > code. Return all errors to the caller rather than swallowing them
> > (e.g. when tpm_transmit_cmd() returns nonzero).
> 
> I didn't look at these closely, but I agree with the idea.

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
