From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v5 3/3] tpm: add securityfs support for TPM
 2.0 firmware event log
Date: Thu, 24 Nov 2016 21:51:03 -0500
Message-ID: <11f97863-aa40-a9aa-836f-4b446faf1ed3@linux.vnet.ibm.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479922057-8752-4-git-send-email-nayna@linux.vnet.ibm.com>
 <20161124211057.xynmfteky5r7uc27@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161124211057.xynmfteky5r7uc27@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 11/24/2016 04:10 PM, Jarkko Sakkinen wrote:
> On Wed, Nov 23, 2016 at 12:27:37PM -0500, Nayna Jain wrote:
>> Unlike the device driver support for TPM 1.2, the TPM 2.0 does
>> not support the securityfs pseudo files for displaying the
>> firmware event log.
>>
>> This patch enables support for providing the TPM 2.0 event log in
>> binary form. TPM 2.0 event log supports a crypto agile format that
>> records multiple digests, which is different from TPM 1.2. This
>> patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
>> event log parser which understand the TPM 2.0 crypto agile format.
>>
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> I don't want to say much about this before I've tested it. I wonder
> what cheap hardware I could use to test this. Any advice is on this
> from anyone is much appreciated.

Virtual hardware would be cheap :-)

I tested this series with QEMU + vTPM + SeaBIOS with TPM 1.2 + TPM 2 
support (basing the log on ACPI). I had to fix an endianess issue on the 
SeaBIOS side, which made it work. So for this version of the patches I 
can give it my tested-by:

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>


>
> /Jarkko
>
> ------------------------------------------------------------------------------
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>

