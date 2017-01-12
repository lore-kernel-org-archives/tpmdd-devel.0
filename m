From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] tpm_tis: override reported C and D timeouts for Atmel
 3203
Date: Thu, 12 Jan 2017 21:09:33 +0100
Message-ID: <259e1606-255b-5bf4-54bb-1bed967c228a@maciej.szmigiero.name>
References: <08953fb6-c332-ef29-2614-6335570023be@maciej.szmigiero.name>
 <20170112184229.GB12836@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112184229.GB12836@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

On 12.01.2017 19:42, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 07:08:53PM +0100, Maciej S. Szmigiero wrote:
>> Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM
>> access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 13.9) no
>> longer works.
>> It turns out the initialization proceeds fine until we get and start using
>> chip-reported timeouts - and the chip reports C and D timeouts of zero.
>>
>> Since these are clearly not long enough let's add an override for them
>> to TPM TIS default values, just as we do for Atmel 3204.
>> A and B timeouts are set to the same values as the chip normally reports.
>>
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> 
>>  static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
>> +	/* Atmel 3203 */
>> +	{ 0x32031114, { (10*1000), (10*1000),
>> +			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
>>  	/* Atmel 3204 */
>>  	{ 0x32041114, { (TIS_SHORT_TIMEOUT*1000), (TIS_LONG_TIMEOUT*1000),
>>  			(TIS_SHORT_TIMEOUT*1000), (TIS_SHORT_TIMEOUT*1000) } },
> 
> Can you also add a check for 0 timeouts in the core code and print a
> FW_BUG :\

Hmm, I dug in history of tpm-interface.c and the code had actually rejected
zero timeouts until commit 8e54caf407b98e (this is the commit that
introduced the Atmel 3204 workaround) and let default timeout values remain
instead (it looks like they were exactly like these in above override at
that time).

Did Atmel 3204 report wrong but non-zero timeouts?

> Jason

Maciej
