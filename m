From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] tpm_tis: fix iTPM probe via probe_itpm() function
Date: Thu, 12 Jan 2017 21:10:51 +0100
Message-ID: <3114e3be-2bc9-7d52-ddef-60aad87997b4@maciej.szmigiero.name>
References: <6bd0d2fe-f979-a4dc-7c4d-54036f4d37f8@maciej.szmigiero.name>
 <20170112185005.GC12836@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112185005.GC12836@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On 12.01.2017 19:50, Jason Gunthorpe wrote:
> On Thu, Jan 12, 2017 at 07:12:06PM +0100, Maciej S. Szmigiero wrote:
>> probe_itpm() function is supposed to send command without an itpm flag set
>> and if this fails to repeat it, this time with the itpm flag set.
>>
>> However, commit 41a5e1cf1fe15 ("tpm/tpm_tis: Split tpm_tis driver into a
>> core and TCG TIS compliant phy") moved the itpm flag from an "itpm"
>> variable to a TPM_TIS_ITPM_POSSIBLE chip flag, so setting the
>> (now function-local) itpm variable no longer had any effect.
>>
>> Finally, this function-local itpm variable was removed by
>> commit 56af322156dbe9 ("tpm/tpm_tis: remove unused itpm variable")
>>
>> Tested only on non-iTPM TIS TPM.
>>
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> 
> could you also change the name of TPM_TIS_ITPM_POSSIBLE
> to TPM_TIS_ITPM_WORKAROUND ?

I will prepare such patch.

> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Jason

Maciej
