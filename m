From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] tpm_tis: Check return values from get_burstcount.
Date: Mon, 24 Oct 2016 19:32:07 +0200
Message-ID: <20161024173207.GA11533@kroah.com>
References: <20161024155439.GA27123@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161024155439.GA27123@google.com>
Sender: stable-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 24, 2016 at 08:54:39AM -0700, Josh Zimmerman wrote:
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
> Fixes: 1107d065fdf1

huh?

No signed off?

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
