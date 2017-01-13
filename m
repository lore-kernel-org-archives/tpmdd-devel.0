From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] tpm: Check size of response before accessing data
Date: Thu, 12 Jan 2017 20:22:37 -0500
Message-ID: <707e5ee5-db26-9c34-3911-c653569237f9@linux.vnet.ibm.com>
References: <1484085844-23374-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170112174043.a7drpmbhtxkakiy6@intel.com>
 <20170112203939.qdae6nqsxb5mw2uc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170112203939.qdae6nqsxb5mw2uc@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/12/2017 03:39 PM, Jarkko Sakkinen wrote:
> On Thu, Jan 12, 2017 at 07:40:43PM +0200, Jarkko Sakkinen wrote:
>> On Tue, Jan 10, 2017 at 05:04:04PM -0500, Stefan Berger wrote:
>>> Make sure that we have not received less bytes than what is indicated
>>> in the header of the TPM response. Also, check the number of bytes in
>>> the response before accessing its data.
>>>
>>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> This patch has a bunch of checkpatch.pl errors.
>>
>> Can you pick "tpm: validate TPM 2.0 commands" as part of v4?
> On a second thought: lets get this commit right first. Don't worry
> about my commit. Once this is ready to be applied I'll update my
> patch to use the new mechanism.
>
> So just fix the checkpatch.pl errors and send v4. I'll take care of
> the rest.

fixed in v4. apologize.

    Stefan

>
> /Jarkko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

