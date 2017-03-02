From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Re: [PATCH v2] tpm: Apply a sane minimum adapterlimit
 value for retransmission.
Date: Thu, 2 Mar 2017 18:24:19 +0100
Message-ID: <20170302172419.GA11265@lunn.ch>
References: <20170301153617.10106-1-enric.balletbo@collabora.com>
	<20170302125543.bsn7z5zkerabzh4u@intel.com>
	<BA3AA3EA-054E-4B65-82C2-C01EBD2849F2@gmx.de>
	<2c648dea-35df-cdf7-3882-40bb855d3573@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2c648dea-35df-cdf7-3882-40bb855d3573-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> >> Hi Enric
> >>
> >> Maybe you should remember that you need to use smaller transfers? If
> >> you don't remember, but use the full size message every time and only
> >> drop back on error, the i2c core is going to log rate limited
> >> messages. By remembering, there will only be one such message in the
> >> log.
> >>
> 

> Maybe I did not explain well but this is what the code does, when
> i2c-core fails with -EOPNOTSUPP because the msg is too long for this
> adapter it loop with a smaller chunk of fixed size, so you only see
> the i2c-core message once.

Hi Enric

Would it not be more accurate to say, that you only see the i2c-core
message once, for this transfer request. Is the next transfer request
again going to use the longer length? then fail, maybe generate
another i2c core message, depending on rate limiting, and then use the
lower message size? I think it does.

Which is why i suggested remembering the length.

      Andrew

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
