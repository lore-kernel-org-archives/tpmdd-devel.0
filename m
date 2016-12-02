From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 2/2] tpm: add securityfs support for TPM 2.0 firmware
 event log
Date: Fri, 2 Dec 2016 15:01:03 +0530
Message-ID: <58413F57.7020805@linux.vnet.ibm.com>
References: <1480164339-26409-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1480164339-26409-3-git-send-email-nayna@linux.vnet.ibm.com>
 <20161126154755.56goahgkjf5n67ay@intel.com>
 <583F0554.1030107@linux.vnet.ibm.com>
 <20161201114318.6wqxpqmhiqimeobh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161201114318.6wqxpqmhiqimeobh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 12/01/2016 05:13 PM, Jarkko Sakkinen wrote:
> On Wed, Nov 30, 2016 at 10:29:00PM +0530, Nayna wrote:
>>
>>
>> On 11/26/2016 09:17 PM, Jarkko Sakkinen wrote:
>>> On Sat, Nov 26, 2016 at 07:45:39AM -0500, Nayna Jain wrote:
>>>> Unlike the device driver support for TPM 1.2, the TPM 2.0 does
>>>> not support the securityfs pseudo files for displaying the
>>>> firmware event log.
>>>>
>>>> This patch enables support for providing the TPM 2.0 event log in
>>>> binary form. TPM 2.0 event log supports a crypto agile format that
>>>> records multiple digests, which is different from TPM 1.2. This
>>>> patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
>>>> event log parser which understand the TPM 2.0 crypto agile format.
>>>>
>>>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>>>
>>> I would not rush with new patch set versions as long as the testing is
>>> almost completely lacking. I didn't even have time to read the previous
>>> version properly before this came out.
>>
>> Sure Jarkko. My apologies for multiple versions. I will wait for testing,
>> before posting my next version.
>
> You could send now a new version because probably anyone who wants
> to review your patches has had a chance to look at it. My point was
> that you wait for at least few days.

Sure Jarkko. Thanks !!

Also Jarkko/Jason, please let me know your views on #defines in 
tpm_eventlog.h for TPM 2.0 event log support. I have responded to the 
related and other feedbacks in my previous mail sent on 30th Nov.

Thanks & Regards,
    - Nayna

>
> Maybe Jason could help testing your patches. I don't know when I have
> time to setup environment. He had OF environment available.
>
> /Jarkko
>

