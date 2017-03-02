From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Re: [PATCH v2] tpm: Apply a sane minimum adapterlimit
 value for retransmission.
Date: Thu, 2 Mar 2017 01:27:10 +0100
Message-ID: <20170302002710.GA26136@lunn.ch>
References: <20170301153617.10106-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170301153617.10106-1-enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 01, 2017 at 04:36:17PM +0100, Enric Balletbo i Serra wrote:
> From: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> When the I2C Infineon part is attached to an I2C adapter that imposes
> a size limitation, large requests will fail with -EOPNOTSUPP. Retry
> them with a sane minimum size without re-issuing the 0x05 command
> as this appears to occasionally put the TPM in a bad state.
> 
> Signed-off-by: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> [rework the patch to adapt to the feedback received]
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> ---
> This is a reworked version of the original patch based on the
> suggestion made by Wolfram Sang to simply fall back to a sane minimum
> when the maximum fails.

Hi Enric

Maybe you should remember that you need to use smaller transfers? If
you don't remember, but use the full size message every time and only
drop back on error, the i2c core is going to log rate limited
messages. By remembering, there will only be one such message in the
log.

	  Andrew

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
