From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 0/4] tpm: last minute critical fixes for Linux 4.5
Date: Sun, 14 Feb 2016 05:30:30 +0200
Message-ID: <20160214033030.GA5367@intel.com>
References: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <3032da9f-01c0-4c09-9acc-cc4fa3e41fa8@email.android.com>
 <20160214032712.GA3586@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160214032712.GA3586@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: David Howells <dhowells@redhat.com>, Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org, jmorris@namei.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Feb 14, 2016 at 05:27:12AM +0200, Jarkko Sakkinen wrote:
> On Sat, Feb 13, 2016 at 02:55:56PM -0700, Jason Gunthorpe wrote:
> > Hi Peter,=20
> >=20
> > Please don't grab my patch in this pull, it is broken.
>=20
> Please send an updated fix. I'll check it through and include it to t=
he
> final pull request.

I'm still waiting for James to pick my previous pull request so take
your time and prepare an updated patch!

/Jarkko

> > Thanks
> > Jason
>=20
> /Jarkko
>=20
> >=20
> > On Feb 13, 2016 6:47 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.int=
el.com> wrote:
> > >
> > > These are critical to get to Linux 4.5 in order to get the chip r=
efcount=20
> > > management stabilized and API/ABI for policy based sealing correc=
t.=20
> > >
> > > Harald Hoyer (1):=20
> > > =A0 tpm_eventlog.c: fix binary_bios_measurements=20
> > >
> > > Jarkko Sakkinen (2):=20
> > > =A0 tpm: fix: keep auth session intact after unseal operation=20
> > > =A0 tpm: fix: rollback when devm_add_action() fails=20
> > >
> > > Jason Gunthorpe (1):=20
> > > =A0 tpm: Hold the kref during tpm_chip_find_get=20
> > >
> > > drivers/char/tpm/tpm-chip.c=A0=A0=A0=A0 |=A0 9 ++++++++-=20
> > > drivers/char/tpm/tpm.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +=20
> > > drivers/char/tpm/tpm2-cmd.c=A0=A0=A0=A0 | 10 +++++++---=20
> > > drivers/char/tpm/tpm_eventlog.c | 10 ++++++++--=20
> > > 4 files changed, 24 insertions(+), 6 deletions(-)=20
> > >
> > > --=20
> > > 2.7.0=20
> > >
