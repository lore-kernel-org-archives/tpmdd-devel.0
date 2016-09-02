From: Rob Herring <robh@kernel.org>
Subject: Re: [tpmdd-devel] [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Fri, 2 Sep 2016 12:57:19 -0500
Message-ID: <CAL_Jsq+jmAHSGTJPxWZgc_87NTA8uvWZSegx9E7krXKzDcgBmw@mail.gmail.com>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20160902145121.GA9636@rob-hp-laptop> <20160902170613.GA5024@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <20160902170613.GA5024@obsidianresearch.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, "wsa@the-dreams.de" <wsa@the-dreams.de>, tpmdd-devel@lists.sourceforge.net, gcwilson@us.ibm.com, "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 2, 2016 at 12:06 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Sep 02, 2016 at 09:51:21AM -0500, Rob Herring wrote:
>> > +- linux,sml-base : base address of the Event Log. It is a physical address.
>> > +              sml stands for shared memory log.
>>
>> How is it a physical address on an i2c device? Why 2 cells (which needs
>> to be documented also)?
>
> To be clear, as I understand it, this mechanism is a hand off from the
> boot firmware to Linux.
>
> The boot firmware talks i2c to the device, does some stuff, writes it
> to memory and then linux reads that stuff. I agree it seems crazy to
> include a random physical address like that.

I'd put that in reserved-memory then if designing this from scratch...

Must not be completely random as somehow the kernel doesn't use that memory.

> The linux,sml-* names appear to have been used by IBM for a long time
> on their enterprise PPC platforms (see drivers/char/tpm/tpm_of.c), so
> I've expected we have to keep them?

Yes. I wasn't aware of that.

> I asked Nayna to document this stuff IBM is doing so the rest of us
> in TPM land can have a hope of maintaining it...
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
