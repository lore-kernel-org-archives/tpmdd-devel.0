From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] tpm_tis: use default timeout value if chip reports it as
 zero
Date: Tue, 24 Jan 2017 14:42:29 +0100
Message-ID: <d722965a-e10f-43df-54c3-9f7d0e9899e4@maciej.szmigiero.name>
References: <d5469294-34e6-2e5e-43e8-9ff82579fc2a@maciej.szmigiero.name>
 <20170116094202.bng7zfznepw7s5la@intel.com>
 <20170116134612.uuzbb6xi7pw7czyo@intel.com>
 <20170116135539.4qtrylwt3m2yfapx@intel.com>
 <17fd82a8-d6fd-d4ec-0965-3ebba25fca0e@maciej.szmigiero.name>
 <20170116163927.od5coufxvctgknot@intel.com>
 <8f971cbc-a4f6-22c9-fd6d-982bf4691530@maciej.szmigiero.name>
 <20170124120124.ycq2maroibtesjhu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170124120124.ycq2maroibtesjhu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On 24.01.2017 13:01, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 06:23:55PM +0100, Maciej S. Szmigiero wrote:
>> On 16.01.2017 17:39, Jarkko Sakkinen wrote:
>>> On Mon, Jan 16, 2017 at 03:58:26PM +0100, Maciej S. Szmigiero wrote:
>>>> On 16.01.2017 14:55, Jarkko Sakkinen wrote:
>>>>> On Mon, Jan 16, 2017 at 03:46:12PM +0200, Jarkko Sakkinen wrote:
>>>>>> On Mon, Jan 16, 2017 at 11:42:02AM +0200, Jarkko Sakkinen wrote:
>>>>>>> On Fri, Jan 13, 2017 at 10:37:00PM +0100, Maciej S. Szmigiero wrote:
>>>>>>>> Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM
>>>>>>>> access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version 13.9) no
>>>>>>>> longer works.
>>>>>>>> The initialization proceeds fine until we get and start using chip-reported
>>>>>>>> timeouts - and the chip reports C and D timeouts of zero.
>>>>>>>>
>>>>>>>> It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
>>>>>>>> means to override the chip returned timeouts") we had actually let default
>>>>>>>> timeout values remain in this case, so let's bring back this behavior to
>>>>>>>> make chips like Atmel 3203 work again.
>>>>>>>>
>>>>>>>> Use a common code that was introduced by that commit so a warning is
>>>>>>>> printed in this case and /sys/class/tpm/tpm*/timeouts correctly says the
>>>>>>>> timeouts aren't chip-original.
>>>>>>>>
>>>>>>>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>>>>>>>>
>>>>>>>> Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM access")
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>
>>>>>>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>>>>
>>>>>> It's now applied to my master branch so if someone wants to
>>>>>> test it, it should be fairly easy.
>>>>>
>>>>> And I decided to squash the rename commit to it.
>>>>
>>>> Wouldn't it be better to squash the rename commit into "fix iTPM probe via
>>>> probe_itpm() function" patch (if it isn't too late), since they touch the
>>>> same functionality?
>>>
>>> It can be renamed, modified and even dropped as long as it is in my
>>> master branch and I haven't sent pull request to James Morris.
>>
>> I see that "fix iTPM probe via probe_itpm() function" patch isn't present
>> in your pull request for 4.11.
>>
>> What I meant in previous message was that you squashed and "rename
>> TPM_TIS_ITPM_POSSIBLE to TPM_TIS_ITPM_WORKAROUND" patch into "use default timeout
>> value if chip reports it as zero" patch while it was logically connected with
>> "fix iTPM probe via probe_itpm() function" patch instead (which now isn't present
>> at all in the tree).
>> Sorry if it wasn't 100% clear.
> 
> I see.
> 
> I'll probably send later on pull request with fixes for release content
> I can include that commit into that pull request. Does that work for
> you?

Yes, it would be fine, thanks.

> /Jarkko

Maciej
