From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tpm_tis: Check return values from get_burstcount.
Date: Tue, 10 Jan 2017 11:07:35 +0100
Message-ID: <20170110100735.GC1011@kroah.com>
References: <20170109214658.8474-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170109214658.8474-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: stable@vger.kernel.org, Josh Zimmerman <joshz@google.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 09, 2017 at 11:46:58PM +0200, Jarkko Sakkinen wrote:
> From: Josh Zimmerman <joshz@google.com>
> 
> If the TPM we're connecting to uses a static burst count, it will report
> a burst count of zero throughout the response read. However, get_burstcount
> assumes that a response of zero indicates that the TPM is not ready to
> receive more data. In this case, it returns a negative error code, which
> is passed on to tpm_tis_{write,read}_bytes as a u16, causing
> them to read/write far too many bytes.
> 
> This patch checks for negative return codes and bails out from recv_data
> and tpm_tis_send_data.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
> Signed-off-by: Josh Zimmerman <joshz@google.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> Backport for 4.8 and 4.9

4.8 is now end-of-life, but I've queued this up for 4.9-stable, many
thanks!

greg k-h
