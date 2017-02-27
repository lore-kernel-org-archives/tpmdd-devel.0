From: Enric Balletbo Serra <eballetbo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Apply an adapterlimit for
	retransmission.
Date: Mon, 27 Feb 2017 22:30:32 +0100
Message-ID: <CAFqH_52TFBWLCXY00pTNdhDKJJ=R3uhY6kpp7Sgx2-fHnq-_iw@mail.gmail.com>
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
To: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrey Pronin <apronin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

2017-02-27 20:12 GMT+01:00 Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>:
> Hi,
>
>> >> > Rather than trying small and smaller transfers, would it not be better
>> >> > to get the i2c core to expose the quirk info about transfer limits?
>> >> >
>> >>
>> >> Sounds a good idea to me, I guess the quirk info can be accessed with
>> >>
>> >>   tpm_dev.client->adapter->quirks->max_read_len
>> >>
>> >> so I think we don't need to touch the i2c core. I'll propose a second version of the patch.
>> >
>> > Hi Enric
>> >
>> > You should probably ask Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, the i2c
>> > subsystem maintainer. He may prefer adding an API call.
>
> Thanks for pointing me to this thread.
>
> I understand it looks tempting to use the quirks struct directly, but I
> don't think this is the proper solution. Quirks are complex and and to
> determine which one finally applies, you need all the logic encoded in
> i2c_check_for_quirks(). Which already gets called on every transfer.
>
> So, my suggestion would be to simply fall back to a sane minimum when
> the maximum failed. 32 (I2C_SMBUS_BLOCK_MAX) should be a good choice.
>

Sounds a good solution for me, I'll test and send a new version of the patches.

> BTW I noted that the original patch checks for -EINVAL. The core returns
> -EOPNOTSUPP, though. So, a) the patch needs to be adapted

Yes I already detected this, In this series I forget to fixup the
patch that fixed this when I did the git rebase. It's is fixed in the
second version.

> and b) it
> looks the i2c host driver returning -EINVAL could be converted to use
> the quirk infrastructure? Which driver is it?
>
> Regards,
>
>    Wolfram
>

Regards,
  Enric

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
