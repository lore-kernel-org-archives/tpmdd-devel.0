From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm: Apply an adapterlimit for
 retransmission.
Date: Wed, 22 Feb 2017 12:16:08 +0100
Message-ID: <ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
 <20170221162948.GD25818@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170221162948.GD25818@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Andrew,

Removing Bryan Freed from the loop as seems his email is not valid anymore. I already CC'ied Andrey which is doing the TPM bit in chromeos kernel.

On 21/02/17 17:29, Andrew Lunn wrote:
> On Tue, Feb 21, 2017 at 03:44:59PM +0100, Enric Balletbo i Serra wrote:
>> From: Bryan Freed <bfreed@chromium.org>
>>
>> When the I2C Infineon part is attached to an I2C adapter that imposes
>> a size limitation, large requests will fail -EINVAL.
>> Retry them with size backoff without re-issuing the 0x05 command
>> as this appears to occasionally put the TPM in a bad state.
> 
> Hi Enric
> 
> Rather than trying small and smaller transfers, would it not be better
> to get the i2c core to expose the quirk info about transfer limits?
> 

Sounds a good idea to me, I guess the quirk info can be accessed with

  tpm_dev.client->adapter->quirks->max_read_len

so I think we don't need to touch the i2c core. I'll propose a second version of the patch.

Thanks,
  Enric


>    Andrew
> 
