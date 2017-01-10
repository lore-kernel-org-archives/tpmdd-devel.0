From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm: check size of response before accessing data
Date: Mon, 9 Jan 2017 19:15:29 -0500
Message-ID: <e552f37e-9b82-96a6-69e1-9398520bf5dd@linux.vnet.ibm.com>
References: <1483618284-3470-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170109160538.gwvksj253wl2v5oy@intel.com>
 <be58d656-28f4-5510-d9e7-cfb8333a919c@linux.vnet.ibm.com>
 <20170109225954.zcd3ep4ul6o7x3ly@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170109225954.zcd3ep4ul6o7x3ly@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/09/2017 05:59 PM, Jarkko Sakkinen wrote:
> On Mon, Jan 09, 2017 at 01:09:31PM -0500, Stefan Berger wrote:
>> On 01/09/2017 11:05 AM, Jarkko Sakkinen wrote:
>>> On Thu, Jan 05, 2017 at 07:11:24AM -0500, Stefan Berger wrote:
>>>> Check the size of the response before accesing data in
>>>> the response packet. This is to avoid accessing data beyond
>>>> the end of the response.
>>>>
>>>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>>> How on earth this could happen if we request only one property?
>> My test program vtpmctrl ( https://github.com/stefanberger/linux-vtpm-tests
>> ) didn't feed the kernel a proper response to a TPM command and that's why
>> this code blew up. We do have a very basic check in the driver and otherwise
>> assume that the TPM is a trusted device responding with an expected
>> response.
> Hmm.... I guess I could add this check but I'll have to probably
> do a similar check at least in one other place in this patch set
> where I grab the metadata for commands.
>
> I guess similar issues will arise as the virtual TPMs get more
> common. For now I think a good guideline is
>
> 1. For new code check that validation for message size is in place.

Before accessing data in the response, make sure we don't access beyond 
the number of bytes returned.

> 2. Fix the old code as you bump into issus.

It doesn't look too bad. I would rebase my current patch on your master 
tree and submit a few small other ones with it. Agrred?

    Stefan

>
> /Jarkko
>

