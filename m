From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: tpm device not showing up in /dev anymore
Date: Tue, 24 Oct 2017 15:51:23 +0200
Message-ID: <20171024135123.uqail7olnespun4k@linux.intel.com>
References: <47c4300b-8701-79a6-1c58-3a5853f4c5e3@debian.org>
 <595efb25-8d87-f39d-037f-9c9a98462339@debian.org>
 <857106e4bb864bb8a68b1381fffc8f50@MUCSE603.infineon.com>
 <20170831164015.3ajgwydgxtippwoz@rhwork>
 <0d9be244-ace0-030d-6ff9-c4e94c63b7e9@debian.org>
 <20170906040555.fqedhmo5277sd6fq@linux.intel.com>
 <20171014081318.busge2fhteusfjwx@rhwork>
 <b63b765d-2477-d9fe-9d80-c2ea7e582bce@debian.org>
 <20171023132346.jbqgokwv3ah2oqjo@linux.intel.com>
 <20171023134515.56siz3m6lhrhnovv@rhwork>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023134515.56siz3m6lhrhnovv@rhwork>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 23, 2017 at 06:45:15AM -0700, Jerry Snitselaar wrote:
> On Mon Oct 23 17, Jarkko Sakkinen wrote:
> > On Sat, Oct 21, 2017 at 10:53:55AM +0200, Laurent Bigonville wrote:
> > > Le 14/10/17 =E0 10:13, Jerry Snitselaar a =E9crit=A0:
> > > > On Wed Sep 06 17, Jarkko Sakkinen wrote:
> > > > > On Fri, Sep 01, 2017 at 02:10:18PM +0200, Laurent Bigonville wrot=
e:
> > > > > > Le 31/08/17 =E0 18:40, Jerry Snitselaar a =E9crit=A0:
> > > > > > > On Thu Aug 31 17, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > > > > > > > > Le 29/08/17 =E0 18:35, Laurent Bigonville a =E9crit=A0:
> > > > > > > > > > Le 29/08/17 =E0 18:00, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org a=
 =E9crit=A0:
> > > > > > > > > >>> An idea how to troubleshoot this?
> > > > > > > > > >> Can you run git bisect on the changes between 4.11 and
> > > > > > 4.12, so that
> > > > > > > > > >> we find the offending commit? It is probably sufficient
> > > > > > to limit the
> > > > > > > > > >> search to commits that touch something in drivers/char=
/tpm.
> > > > > > > > > >
> > > > > > > > > > I'll try and keep you posted.
> > > > > > > > >
> > > > > > > > > OK I've been able to bisect the problem and the bad commi=
t is:
> > > > > > > > >
> > > > > > > > > e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3 is the first bad=
 commit
> > > > > > > > > commit e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3
> > > > > > > > > Author: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > > > > > > Date:=A0=A0 Mon Mar 27 08:46:04 2017 -0700
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0 tpm_tis: convert to using locality callbacks
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0 This patch converts tpm_tis to use of the ne=
w tpm class ops
> > > > > > > > > =A0=A0=A0=A0 request_locality, and relinquish_locality.
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0 With the move to using the callbacks, releas=
e_locality is
> > > > > > > > > changed so
> > > > > > > > > =A0=A0=A0=A0 that we now release the locality even if the=
re is no
> > > > > > > > > request pending.
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0 This required some changes to the tpm_tis_co=
re_init
> > > > > > code path to
> > > > > > > > > =A0=A0=A0=A0 make sure locality is requested when needed:
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0=A0=A0 - tpm2_probe code path will end up cal=
ling
> > > > > > > > > request/release through
> > > > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 callbacks, so request_locality p=
rior to
> > > > > > tpm2_probe not needed.
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0=A0=A0 - probe_itpm makes calls to tpm_tis_se=
nd_data which no
> > > > > > > > > longer calls
> > > > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 request_locality, so add request=
_locality prior to
> > > > > > > > > tpm_tis_send_data
> > > > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 calls. Also drop release_localit=
y call in middleof
> > > > > > > > > probe_itpm, and
> > > > > > > > > =A0=A0=A0=A0=A0=A0=A0=A0 keep locality until release_loca=
lity called at end of
> > > > > > > > > probe_itpm.
> > > > > > > > >
> > > > > > > > > =A0=A0=A0=A0 Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> > > > > > > > > =A0=A0=A0=A0 Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.i=
ntel.com>
> > > > > > > > > =A0=A0=A0=A0 Cc: Jason Gunthorpe <jgunthorpe@obsidianrese=
arch.com>
> > > > > > > > > =A0=A0=A0=A0 Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
> > > > > > > > > =A0=A0=A0=A0 Signed-off-by: Jerry Snitselaar <jsnitsel@re=
dhat.com>
> > > > > > > > > =A0=A0=A0=A0 Reviewed-by: Jarkko Sakkinen
> > > > > > <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > > > > =A0=A0=A0=A0 Tested-by: Jarkko Sakkinen <jarkko.sakkinen@=
linux.intel.com>
> > > > > > > > > =A0=A0=A0=A0 Signed-off-by: Jarkko Sakkinen
> > > > > > <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > > > >
> > > > > > > > > :040000 040000 70234365da69959d47076ebb40c8d17f520c3e44
> > > > > > > > > 72f21b446e45ea1003de75902b0553deb99157fd M drivers
> > > > > > > > >
> > > > > > > >
> > > > > > > > I've looked again at the code in question, but could not fi=
nd
> > > > > > > > anything that is obviously wrong there. Locality is now
> > > > > > > > requested/released at slightly different points in the proc=
ess than
> > > > > > > > before, but that's it. It does not seem to cause problems w=
ith the
> > > > > > > > majority of TPMs, since you are the first to report any, so
> > > > > > maybe it
> > > > > > > > is a quirk that only affects this device.
> > > > > > > >
> > > > > > > > Perhaps Jerry can help, since this is his change?
> > > > > > > >
> > > > > > > > Alexander
> > > > > > >
> > > > > > > Getting some caffeine in me, and starting to take a look. Add=
ing
> > > > > > > Jarkko as well since this might involve the general locality =
changes.
> > > > > > >
> > > > > > > Laurent, if I send you a patch with some debugging code added=
, would
> > > > > > > you be able to run it on that system? I wasn't running into i=
ssues
> > > > > > > on the system I had with a 1.2 device, but I no longer have a=
ccess
> > > > > > > to it. I'll see if I can find one in our labs and reproduce i=
t there.
> > > > > >
> > > > > > Yes I should be able to do that
> > > > >
> > > > > Any findings?
> > > > >
> > > > > /Jarkko
> > > >
> > > > Okay, finally getting back to this. Looking at the code it isn't cl=
ear
> > > > to me
> > > > why the change is causing this. So while I stare at this some more
> > > > Laurent
> > > > could you reproduce it with this patch so I can see what the status=
 and
> > > > access registers look like? Does anyone else on here happen to have=
 a
> > > > Sinosun
> > > > tpm device? The systems I have access to with TPM1.2 devices don't =
have
> > > > this
> > > > issue.
> > > >
> > > > --8<--
> > > >
> > > > diff --git a/drivers/char/tpm/tpm_tis_core.c
> > > > b/drivers/char/tpm/tpm_tis_core.c
> > > > index fdde971bc810..7d60a7e4b50a 100644
> > > > --- a/drivers/char/tpm/tpm_tis_core.c
> > > > +++ b/drivers/char/tpm/tpm_tis_core.c
> > > > @@ -258,6 +258,7 @@ static int tpm_tis_send_data(struct tpm_chip *c=
hip,
> > > > const u8 *buf, size_t len)
> > > > =A0=A0=A0=A0int rc, status, burstcnt;
> > > > =A0=A0=A0=A0size_t count =3D 0;
> > > > =A0=A0=A0=A0bool itpm =3D priv->flags & TPM_TIS_ITPM_WORKAROUND;
> > > > +=A0=A0=A0 u8 access;
> > > >
> > > > =A0=A0=A0=A0status =3D tpm_tis_status(chip);
> > > > =A0=A0=A0=A0if ((status & TPM_STS_COMMAND_READY) =3D=3D 0) {
> > > > @@ -292,6 +293,11 @@ static int tpm_tis_send_data(struct tpm_chip *=
chip,
> > > > const u8 *buf, size_t len)
> > > > =A0=A0=A0=A0=A0=A0=A0 }
> > > > =A0=A0=A0=A0=A0=A0=A0 status =3D tpm_tis_status(chip);
> > > > =A0=A0=A0=A0=A0=A0=A0 if (!itpm && (status & TPM_STS_DATA_EXPECT) =
=3D=3D 0) {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D tpm_tis_read8(priv, TPM_A=
CCESS(priv->locality),
> > > > &access);
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev,=
 "TPM_STS_DATA_EXPECT =3D=3D 0: read
> > > > failure TPM_ACCESS(%d)\n", priv->locality);
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev,=
 "TPM_STS_DATA_EXPECT =3D=3D 0:
> > > > locality: %d status: %x access: %x\n", priv->locality, status, acce=
ss);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EIO;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_err;
> > > > =A0=A0=A0=A0=A0=A0=A0 }
> > > > @@ -309,6 +315,11 @@ static int tpm_tis_send_data(struct tpm_chip *=
chip,
> > > > const u8 *buf, size_t len)
> > > > =A0=A0=A0=A0}
> > > > =A0=A0=A0=A0status =3D tpm_tis_status(chip);
> > > > =A0=A0=A0=A0if (!itpm && (status & TPM_STS_DATA_EXPECT) !=3D 0) {
> > > > +=A0=A0=A0=A0=A0=A0=A0 rc =3D tpm_tis_read8(priv, TPM_ACCESS(priv->=
locality), &access);
> > > > +=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev, "TPM_STS_DA=
TA_EXPECT !=3D 0: read
> > > > failure TPM_ACCESS(%d)\n", priv->locality);
> > > > +=A0=A0=A0=A0=A0=A0=A0 else
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev, "TPM_STS_DA=
TA_EXPECT !=3D 0: locality:
> > > > %d status: %x access: %x\n", priv->locality, status, access);
> > > > =A0=A0=A0=A0=A0=A0=A0 rc =3D -EIO;
> > > > =A0=A0=A0=A0=A0=A0=A0 goto out_err;
> > > > =A0=A0=A0=A0}
> > > =

> > > Please find here the dmesg output of the patched kernel
> > =

> > At least 0xff is corrupted value in senseful way. CPU fills the read
> > with ones for example for unaligned bus read. See table 19 in PC client
> > spec. This can happen when you do unaligned read for example.
> > =

> > Maybe TPM is unreachable i.e. powered off. Bit busy with stuff ATM but
> > would probably make sense to compare that 0x81 to table 18 in the same
> > spec.
> > =

> > /Jarkko
> =

> 0x81 is saying the access register status is valid, and the locality
> is not active. That first bit means A Dynamic OS has not been previously
> established on the platform. Normally we would see 0xa1, which would
> mean valid register status, and the locality is active.

I think the important thing to note here is that STS has bits set that
should never be set. So we can conclude that TPM might be either

1. Powered off
2. In some transition state?

/Jarkko

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
