From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [RESEND][RFC] tpm_tis: broken on TPMs with a static burst count
Date: Tue, 10 Jan 2017 00:44:14 +0100
Message-ID: <623bb5fa-ed8a-f12b-f660-7e98c89838ba@maciej.szmigiero.name>
References: <77221b3a-40b3-f5db-e821-10e258f869dc@maciej.szmigiero.name>
 <20170109220903.vr36mux3nr2bp6z5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170109220903.vr36mux3nr2bp6z5@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

On 09.01.2017 23:09, Jarkko Sakkinen wrote:
> On Wed, Jan 04, 2017 at 06:47:52PM +0100, Maciej S. Szmigiero wrote:
>> (Resending as no reply received, this time with CCs to TPM maintainers and
>> author of the original commit).
>>
>> Hi all,
>>
>> Commit 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
>> broke TPM support on ThinkPad X61S (and likely also on other machines which
>> use TPMs with a static burst count).
>>
>> It looks like tpm_tis code before this commit had spun on TPM_STS_DATA_AVAIL |
>> TPM_STS_VALID status bits in the read case and TPM_STS_VALID in the write case
>> when it got a zero burst count.
>>
>> I have attached a patch against current code (linux-tpmdd tree) that brings
>> back this old behavior.
>> With this patch the TPM works again on X61S.
>> However, somebody with more TPM experience should comment whether such behavior
>> was OK or the change brought by commit 1107d065fdf1 was intentional.
>>
> 
> For me this commit makes perfect sense. Could you do the following things:
> 
> 1. Clean up the description a little bit
> 2. Add your Signed-off-by tag.
> 3. Add "Cc: stable@vger.kernel.org" tag right after your signed-off-by.
> 4. CC this linux-security-module@vger.kernel.org, stable@vger.kernel.org,
>    linux-kernel@vger.kernel.org.
> 5. Run scripts/checkpatch.pl
> 6. Re-send for review.

Yes, I will respin this as a proper submission, just wanted to make sure
that it makes sense to restore the old behavior.

> Thanks for fixing the issue. Keep up the good work!

Thanks for kind words and all your TPM work!

> /Jarkko

Maciej
