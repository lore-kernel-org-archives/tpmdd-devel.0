From: Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm: Apply an adapterlimit for retransmission.
Date: Mon, 27 Feb 2017 19:48:21 +0100
Message-ID: <CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA@mail.gmail.com>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
 <20170221162948.GD25818@lunn.ch> <ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
 <20170222140134.GA23586@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170222140134.GA23586@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Bounce to Wolfram Sang

2017-02-22 15:01 GMT+01:00 Andrew Lunn <andrew@lunn.ch>:
> On Wed, Feb 22, 2017 at 12:16:08PM +0100, Enric Balletbo i Serra wrote:
>> Hi Andrew,
>>
>> Removing Bryan Freed from the loop as seems his email is not valid anymore. I already CC'ied Andrey which is doing the TPM bit in chromeos kernel.
>>
>> On 21/02/17 17:29, Andrew Lunn wrote:
>> > On Tue, Feb 21, 2017 at 03:44:59PM +0100, Enric Balletbo i Serra wrote:
>> >> From: Bryan Freed <bfreed@chromium.org>
>> >>
>> >> When the I2C Infineon part is attached to an I2C adapter that imposes
>> >> a size limitation, large requests will fail -EINVAL.
>> >> Retry them with size backoff without re-issuing the 0x05 command
>> >> as this appears to occasionally put the TPM in a bad state.
>> >
>> > Hi Enric
>> >
>> > Rather than trying small and smaller transfers, would it not be better
>> > to get the i2c core to expose the quirk info about transfer limits?
>> >
>>
>> Sounds a good idea to me, I guess the quirk info can be accessed with
>>
>>   tpm_dev.client->adapter->quirks->max_read_len
>>
>> so I think we don't need to touch the i2c core. I'll propose a second version of the patch.
>
> Hi Enric
>
> You should probably ask Wolfram Sang <wsa@the-dreams.de>, the i2c
> subsystem maintainer. He may prefer adding an API call.
>
>           Andrew
