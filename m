From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: move struct tpm_class_ops to drivers/char/tpm/tpm.h
Date: Fri, 2 Sep 2016 16:11:22 -0600
Message-ID: <20160902221122.GA1897@obsidianresearch.com>
References: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Sep 03, 2016 at 12:48:03AM +0300, Jarkko Sakkinen wrote:
> The struct tpm_class_ops is not used outside the TPM driver. Thus,
> it can be safely move to drivers/char/tpm/tpm.h.

No, this is the wrong direction.

The goal is to make things more like other subsystems, so we should be
moving struct tpm_chip into the public header, and that requires ops
to be in the public header.

This is why I put ops here in the first place.

Jason
