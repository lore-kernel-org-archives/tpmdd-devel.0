From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Apply an adapterlimit for
	retransmission.
Date: Thu, 02 Mar 2017 14:15:09 +0100
Message-ID: <9E9945C5-50AD-465C-BE0E-F77499D79A04@gmx.de>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
	<20170221162948.GD25818@lunn.ch>
	<ffdfb321-6c9b-06fe-1a90-04da5457b47d@collabora.com>
	<20170222140134.GA23586@lunn.ch>
	<CAFqH_536FjjkWiUS_5PyDJHHgy6S8BvBzArAxSAg6H6oa214KA@mail.gmail.com>
	<20170227191245.ecord2i7o6jwec5k@ninjato>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170227191245.ecord2i7o6jwec5k@ninjato>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Enric Balletbo Serra <eballetbo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, apronin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 27. Februar 2017 20:12:45 MEZ schrieb Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>:
>Hi,
>
>> >> > Rather than trying small and smaller transfers, would it not be
>better
>> >> > to get the i2c core to expose the quirk info about transfer
>limits?
>> >> >
>> >>
>> >> Sounds a good idea to me, I guess the quirk info can be accessed
>with
>> >>
>> >>   tpm_dev.client->adapter->quirks->max_read_len
>> >>
>> >> so I think we don't need to touch the i2c core. I'll propose a
>second version of the patch.
>> >
>> > Hi Enric
>> >
>> > You should probably ask Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, the i2c
>> > subsystem maintainer. He may prefer adding an API call.
>
>Thanks for pointing me to this thread.
>
>I understand it looks tempting to use the quirks struct directly, but I
>don't think this is the proper solution. Quirks are complex and and to
>determine which one finally applies, you need all the logic encoded in
>i2c_check_for_quirks(). Which already gets called on every transfer.
>
>So, my suggestion would be to simply fall back to a sane minimum when
>the maximum failed. 32 (I2C_SMBUS_BLOCK_MAX) should be a good choice.

Hi,
One problem is however that e.g. in the case of the atmel tpms, there is no sane minimum, since you mustn't split the tpm apdu.

If the command is larger than the supported adapter limit the command the only viable option is to return an error.
For this the tpm layer would need the adapter limit.

If somehow possible I would seriously vote for a adapter limit field (maybe not in the quirks).

TPMs are a not the best devices when it comes to i2c :/

Peter


>
>BTW I noted that the original patch checks for -EINVAL. The core
>returns
>-EOPNOTSUPP, though. So, a) the patch needs to be adapted and b) it
>looks the i2c host driver returning -EINVAL could be converted to use
>the quirk infrastructure? Which driver is it?
>
>Regards,
>
>   Wolfram

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
