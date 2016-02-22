From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [GIT PULL] remaining tpmdd fixes for Linux 4.5
Date: Mon, 22 Feb 2016 12:56:53 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1602221255210.4918@namei.org>
References: <20160220081705.GA12981@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1665246916-765228243-1456106213=:4918"
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160220081705.GA12981-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-765228243-1456106213=:4918
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by namei.org id
	u1M1urlh005387

On Sat, 20 Feb 2016, Jarkko Sakkinen wrote:

> Hi James,
>=20
> I'm sorry for the late pull request for 4.5. The reason for this was
> the latency in my previous one. I picked with care the absolutely
> critical fixes so that we can make a sound tpmdd release.
>=20
> I really hope you can still pick these as one of them is absolutely
> critical to get authorization policy sealing API right (kernel keeps
> it finger out of user space created objects).

Pushed to next for more testing and review.

This really is getting too late in the development cycle for so many=20
fixes.  It means the code was not ready to be merged in the first place.

Also, any idea why I'm seeing this:

drivers/char/tpm/tpm_tis.c:838: warning: =A1tpm_tis_resume=A2 defined but=
 not=20
used


--=20
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>

--1665246916-765228243-1456106213=:4918
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
--1665246916-765228243-1456106213=:4918
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--1665246916-765228243-1456106213=:4918--
