From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/4] tpm: last minute critical fixes
	for Linux 4.5
Date: Sun, 14 Feb 2016 05:27:12 +0200
Message-ID: <20160214032712.GA3586@intel.com>
References: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<3032da9f-01c0-4c09-9acc-cc4fa3e41fa8@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3032da9f-01c0-4c09-9acc-cc4fa3e41fa8-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 13, 2016 at 02:55:56PM -0700, Jason Gunthorpe wrote:
> Hi Peter, =

> =

> Please don't grab my patch in this pull, it is broken.

Please send an updated fix. I'll check it through and include it to the
final pull request.

> Thanks
> Jason

/Jarkko

> =

> On Feb 13, 2016 6:47 AM, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org=
> wrote:
> >
> > These are critical to get to Linux 4.5 in order to get the chip refcoun=
t =

> > management stabilized and API/ABI for policy based sealing correct. =

> >
> > Harald Hoyer (1): =

> > =A0 tpm_eventlog.c: fix binary_bios_measurements =

> >
> > Jarkko Sakkinen (2): =

> > =A0 tpm: fix: keep auth session intact after unseal operation =

> > =A0 tpm: fix: rollback when devm_add_action() fails =

> >
> > Jason Gunthorpe (1): =

> > =A0 tpm: Hold the kref during tpm_chip_find_get =

> >
> > drivers/char/tpm/tpm-chip.c=A0=A0=A0=A0 |=A0 9 ++++++++- =

> > drivers/char/tpm/tpm.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 + =

> > drivers/char/tpm/tpm2-cmd.c=A0=A0=A0=A0 | 10 +++++++--- =

> > drivers/char/tpm/tpm_eventlog.c | 10 ++++++++-- =

> > 4 files changed, 24 insertions(+), 6 deletions(-) =

> >
> > -- =

> > 2.7.0 =

> >

---------------------------------------------------------------------------=
---
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=3D272487151&iu=3D/4140
