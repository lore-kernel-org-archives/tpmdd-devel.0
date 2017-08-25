From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 3/3] tpm-chip: Export TPM device to user space
 even when startup failed
Date: Fri, 25 Aug 2017 20:20:21 +0300
Message-ID: <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824083714.10016-4-Alexander.Steffen@infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Steffen <Alexander.Steffen@infineon.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:37:14AM +0200, Alexander Steffen wrote:
> When one of the commands during the auto_startup sequences does not return
> TPM_RC_SUCCESS, tpm_chip_register misleadingly returns ENODEV, even though
> a TPM device is definitely present.
> 
> An error response during those sequences is indeed unexpected, so to
> prevent subsequent errors, the kernel should not make use of the TPM
> device. But user space applications still might be able to communicate with
> the TPM, so they can be used to further diagnose and/or fix the problem. To
> allow this, with this patch the device is still exported to user space,
> even if a TPM error code has been received, but the kernel itself will not
> be allowed to use the device for anything.
> 
> This is not a hypothetical scenario, but there are devices in the wild that
> show this behavior. With this fix, those devices can be recovered from
> their failed state.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>

I can understand the benefits but you could make the same argument for
any class devices that kernel handles. I don't think it is that common
to let user space access malfunctioning devices.

Adding linux-security-module.

PS. You should have in *all* patches that you don't tag as RFC have
linux-kernel@vger.kernel.org. Now you have it in *none* of your patches.
When you don't have RFC you are saying out loud that this is production
ready code that should be included to the mainline kernel.

PPS. This patch set should be obviously RFC. It's  avery questionable and
intrusive change. That's why I didn't include linux-kernel.

/Jarkko
