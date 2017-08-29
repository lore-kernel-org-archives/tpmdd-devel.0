From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RESEND 3/3] tpm-chip: Export TPM device to user space
 even when startup failed
Date: Tue, 29 Aug 2017 15:55:09 +0300
Message-ID: <20170829125509.55aylht3ikes3bpy@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
 <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander.Steffen@infineon.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 28, 2017 at 05:15:58PM +0000, Alexander.Steffen@infineon.com wrote:
> But is that just because nobody bothered to implement the necessary
> logic or for some other reason?

We do not want user space to access broken hardware. It's a huge risk
for system stability and potentially could be used for evil purposes.

This is not going to mainline as it is not suitable for general
consumption. You must use a patched kernel if you want this.

/Jarkko
