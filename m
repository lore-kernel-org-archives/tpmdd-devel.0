From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Apply an adapterlimit for
	retransmission.
Date: Wed, 22 Feb 2017 13:39:33 +0100
Message-ID: <2A0398AC-64F2-493C-9717-01E5366C2159@gmx.de>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
	<20170221162948.GD25818@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170221162948.GD25818-g2DYL2Zd6BY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: apronin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



Am 21. Februar 2017 17:29:48 MEZ schrieb Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>:
>On Tue, Feb 21, 2017 at 03:44:59PM +0100, Enric Balletbo i Serra wrote:
>> From: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> 
>> When the I2C Infineon part is attached to an I2C adapter that imposes
>> a size limitation, large requests will fail -EINVAL.
>> Retry them with size backoff without re-issuing the 0x05 command
>> as this appears to occasionally put the TPM in a bad state.
>
>Hi Enric
>
>Rather than trying small and smaller transfers, would it not be better
>to get the i2c core to expose the quirk info about transfer limits?
>
+1
I think that would be the better idea.
Peter
>   Andrew

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
