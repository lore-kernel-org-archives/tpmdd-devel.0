From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm: check size of response before accessing data
Date: Mon, 9 Jan 2017 13:09:31 -0500
Message-ID: <be58d656-28f4-5510-d9e7-cfb8333a919c@linux.vnet.ibm.com>
References: <1483618284-3470-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170109160538.gwvksj253wl2v5oy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170109160538.gwvksj253wl2v5oy@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/09/2017 11:05 AM, Jarkko Sakkinen wrote:
> On Thu, Jan 05, 2017 at 07:11:24AM -0500, Stefan Berger wrote:
>> Check the size of the response before accesing data in
>> the response packet. This is to avoid accessing data beyond
>> the end of the response.
>>
>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> How on earth this could happen if we request only one property?

My test program vtpmctrl ( 
https://github.com/stefanberger/linux-vtpm-tests ) didn't feed the 
kernel a proper response to a TPM command and that's why this code blew 
up. We do have a very basic check in the driver and otherwise assume 
that the TPM is a trusted device responding with an expected response.

http://lxr.free-electrons.com/source/drivers/char/tpm/tpm-interface.c#L417

414         len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
415         if (len <  0)
416                 return len;
417         else if (len < TPM_HEADER_SIZE)
418                 return -EFAULT;


Now should we expand on this check or just assume the device is flawless?

This particular check above should probably check whether the len is 
also what the len in the packet indicates.

    Stefan

