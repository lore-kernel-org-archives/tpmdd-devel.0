From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [tpmdd-devel] [backport v4.9] tpm_tis: use default timeout value
 if chip reports it as zero
Date: Sun, 16 Apr 2017 21:14:29 +0200
Message-ID: <79399e000218504619c21ce6729c8334@molgen.mpg.de>
References: <20170415152622.14451-1-user@jsakkine-mobl1>
 <20170415205032.GA17774@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170415205032.GA17774@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, stable@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Dear Greg,


On 2017-04-15 22:50, Greg KH wrote:
> On Sat, Apr 15, 2017 at 06:26:22PM +0300, Jarkko Sakkinen wrote:
>> From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
>> 
>> Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for
>> TPM access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 
>> 13.9)
>> no longer works.  The initialization proceeds fine until we get and
>> start using chip-reported timeouts - and the chip reports C and D
>> timeouts of zero.
>> 
>> It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
>> means to override the chip returned timeouts") we had actually let
>> default timeout values remain in this case, so let's bring back this
>> behavior to make chips like Atmel 3203 work again.
>> 
>> Use a common code that was introduced by that commit so a warning is
>> printed in this case and /sys/class/tpm/tpm*/timeouts correctly says 
>> the
>> timeouts aren't chip-original.
>> 
>> Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM 
>> access")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> What is the git commit id for this patch in Linus's tree?

The git commit hash is 1d70fe9d9c3a4c627f9757cbba5d628687b121c1.


Kind regards,

Paul
