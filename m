From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Wed, 28 Sep 2016 14:10:55 +0530
Message-ID: <57EB8217.40202@linux.vnet.ibm.com>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20160902145121.GA9636@rob-hp-laptop>
 <20160902170613.GA5024@obsidianresearch.com>
 <CAL_Jsq+jmAHSGTJPxWZgc_87NTA8uvWZSegx9E7krXKzDcgBmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+jmAHSGTJPxWZgc_87NTA8uvWZSegx9E7krXKzDcgBmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org" <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



On 09/02/2016 11:27 PM, Rob Herring wrote:
> On Fri, Sep 2, 2016 at 12:06 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Fri, Sep 02, 2016 at 09:51:21AM -0500, Rob Herring wrote:
>>>> +- linux,sml-base : base address of the Event Log. It is a physical address.
>>>> +              sml stands for shared memory log.
>>>
>>> How is it a physical address on an i2c device? Why 2 cells (which needs
>>> to be documented also)?
>>
>> To be clear, as I understand it, this mechanism is a hand off from the
>> boot firmware to Linux.
>>
>> The boot firmware talks i2c to the device, does some stuff, writes it
>> to memory and then linux reads that stuff. I agree it seems crazy to
>> include a random physical address like that.
>
> I'd put that in reserved-memory then if designing this from scratch...

Thanks for the review comments.

Yes, it is in reserved-memory. I modified the explanation for 
linux,sml-base property to be more descriptive now in my v2 version of 
the patch, posted just now.
>
> Must not be completely random as somehow the kernel doesn't use that memory.
>
>> The linux,sml-* names appear to have been used by IBM for a long time
>> on their enterprise PPC platforms (see drivers/char/tpm/tpm_of.c), so
>> I've expected we have to keep them?
>
> Yes. I wasn't aware of that.
>
>> I asked Nayna to document this stuff IBM is doing so the rest of us
>> in TPM land can have a hope of maintaining it...
>>
>> Jason
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
