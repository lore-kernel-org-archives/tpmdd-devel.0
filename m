From: Laurent Bigonville <bigon-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: tpm device not showing up in /dev anymore
Date: Sat, 21 Oct 2017 10:53:55 +0200
Message-ID: <b63b765d-2477-d9fe-9d80-c2ea7e582bce@debian.org>
References: <f9526f55-df96-64fc-a4d6-877ce04e7156@debian.org>
 <dcad0104c46d4d5f88e642862bdb42c2@MUCSE603.infineon.com>
 <47c4300b-8701-79a6-1c58-3a5853f4c5e3@debian.org>
 <595efb25-8d87-f39d-037f-9c9a98462339@debian.org>
 <857106e4bb864bb8a68b1381fffc8f50@MUCSE603.infineon.com>
 <20170831164015.3ajgwydgxtippwoz@rhwork>
 <0d9be244-ace0-030d-6ff9-c4e94c63b7e9@debian.org>
 <20170906040555.fqedhmo5277sd6fq@linux.intel.com>
 <20171014081318.busge2fhteusfjwx@rhwork>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------A9FE3B2D3EA7C477C0DA4586"
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20171014081318.busge2fhteusfjwx@rhwork>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------A9FE3B2D3EA7C477C0DA4586
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Le 14/10/17 =C3=A0 10:13, Jerry Snitselaar a =C3=A9crit=C2=A0:
> On Wed Sep 06 17, Jarkko Sakkinen wrote:
>> On Fri, Sep 01, 2017 at 02:10:18PM +0200, Laurent Bigonville wrote:
>>> Le 31/08/17 =C3=A0 18:40, Jerry Snitselaar a =C3=A9crit=C2=A0:
>>> > On Thu Aug 31 17, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
>>> > > > Le 29/08/17 =C3=A0 18:35, Laurent Bigonville a =C3=A9crit=C2=A0=
:
>>> > > > > Le 29/08/17 =C3=A0 18:00, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org a =C3=
=A9crit=C2=A0:
>>> > > > >>> An idea how to troubleshoot this?
>>> > > > >> Can you run git bisect on the changes between 4.11 and=20
>>> 4.12, so that
>>> > > > >> we find the offending commit? It is probably sufficient to=20
>>> limit the
>>> > > > >> search to commits that touch something in drivers/char/tpm.
>>> > > > >
>>> > > > > I'll try and keep you posted.
>>> > > >
>>> > > > OK I've been able to bisect the problem and the bad commit is:
>>> > > >
>>> > > > e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3 is the first bad commi=
t
>>> > > > commit e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3
>>> > > > Author: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> > > > Date:=C2=A0=C2=A0 Mon Mar 27 08:46:04 2017 -0700
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 tpm_tis: convert to using locality cal=
lbacks
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 This patch converts tpm_tis to use of =
the new tpm class ops
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 request_locality, and relinquish_local=
ity.
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 With the move to using the callbacks, =
release_locality is
>>> > > > changed so
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 that we now release the locality even =
if there is no
>>> > > > request pending.
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 This required some changes to the tpm_=
tis_core_init code=20
>>> path to
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 make sure locality is requested when n=
eeded:
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - tpm2_probe code path wil=
l end up calling
>>> > > > request/release through
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 callbacks, so =
request_locality prior to tpm2_probe=20
>>> not needed.
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - probe_itpm makes calls t=
o tpm_tis_send_data which no
>>> > > > longer calls
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 request_locali=
ty, so add request_locality prior to
>>> > > > tpm_tis_send_data
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 calls. Also dr=
op release_locality call in middleof
>>> > > > probe_itpm, and
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 keep locality =
until release_locality called at end of
>>> > > > probe_itpm.
>>> > > >
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Cc: Jarkko Sakkinen <jarkko.sakkinen@l=
inux.intel.com>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Cc: Jason Gunthorpe <jgunthorpe@obsidi=
anresearch.com>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Cc: Marcel Selhorst <tpmdd-yWjUBOtONeeDGRHsOpWV0g@public.gmane.org=
t>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Signed-off-by: Jerry Snitselaar <jsnit=
sel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Reviewed-by: Jarkko Sakkinen=20
>>> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Tested-by: Jarkko Sakkinen <jarkko.sak=
kinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Signed-off-by: Jarkko Sakkinen=20
>>> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>> > > >
>>> > > > :040000 040000 70234365da69959d47076ebb40c8d17f520c3e44
>>> > > > 72f21b446e45ea1003de75902b0553deb99157fd M drivers
>>> > > >
>>> > >
>>> > > I've looked again at the code in question, but could not find
>>> > > anything that is obviously wrong there. Locality is now
>>> > > requested/released at slightly different points in the process th=
an
>>> > > before, but that's it. It does not seem to cause problems with th=
e
>>> > > majority of TPMs, since you are the first to report any, so=20
>>> maybe it
>>> > > is a quirk that only affects this device.
>>> > >
>>> > > Perhaps Jerry can help, since this is his change?
>>> > >
>>> > > Alexander
>>> >
>>> > Getting some caffeine in me, and starting to take a look. Adding
>>> > Jarkko as well since this might involve the general locality change=
s.
>>> >
>>> > Laurent, if I send you a patch with some debugging code added, woul=
d
>>> > you be able to run it on that system? I wasn't running into issues
>>> > on the system I had with a 1.2 device, but I no longer have access
>>> > to it. I'll see if I can find one in our labs and reproduce it ther=
e.
>>>
>>> Yes I should be able to do that
>>
>> Any findings?
>>
>> /Jarkko
>
> Okay, finally getting back to this. Looking at the code it isn't clear=20
> to me
> why the change is causing this. So while I stare at this some more=20
> Laurent
> could you reproduce it with this patch so I can see what the status and
> access registers look like? Does anyone else on here happen to have a=20
> Sinosun
> tpm device? The systems I have access to with TPM1.2 devices don't=20
> have this
> issue.
>
> --8<--
>
> diff --git a/drivers/char/tpm/tpm_tis_core.c=20
> b/drivers/char/tpm/tpm_tis_core.c
> index fdde971bc810..7d60a7e4b50a 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -258,6 +258,7 @@ static int tpm_tis_send_data(struct tpm_chip=20
> *chip, const u8 *buf, size_t len)
> =C2=A0=C2=A0=C2=A0=C2=A0int rc, status, burstcnt;
> =C2=A0=C2=A0=C2=A0=C2=A0size_t count =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0bool itpm =3D priv->flags & TPM_TIS_ITPM_WORKAR=
OUND;
> +=C2=A0=C2=A0=C2=A0 u8 access;
>
> =C2=A0=C2=A0=C2=A0=C2=A0status =3D tpm_tis_status(chip);
> =C2=A0=C2=A0=C2=A0=C2=A0if ((status & TPM_STS_COMMAND_READY) =3D=3D 0) =
{
> @@ -292,6 +293,11 @@ static int tpm_tis_send_data(struct tpm_chip=20
> *chip, const u8 *buf, size_t len)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 status =3D tpm_tis_status(ch=
ip);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!itpm && (status & TPM_S=
TS_DATA_EXPECT) =3D=3D 0) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =
=3D tpm_tis_read8(priv, TPM_ACCESS(priv->locality),=20
> &access);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(rc < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev_info(&chip->dev, "TPM_STS_DATA_EXPECT =3D=3D 0: re=
ad=20
> failure TPM_ACCESS(%d)\n", priv->locality);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 els=
e
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 dev_info(&chip->dev, "TPM_STS_DATA_EXPECT =3D=3D 0:=20
> locality: %d status: %x access: %x\n", priv->locality, status, access);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D=
 -EIO;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto=
 out_err;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> @@ -309,6 +315,11 @@ static int tpm_tis_send_data(struct tpm_chip=20
> *chip, const u8 *buf, size_t len)
> =C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0=C2=A0=C2=A0=C2=A0status =3D tpm_tis_status(chip);
> =C2=A0=C2=A0=C2=A0=C2=A0if (!itpm && (status & TPM_STS_DATA_EXPECT) !=3D=
 0) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D tpm_tis_read8(priv, =
TPM_ACCESS(priv->locality), &access);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev=
_info(&chip->dev, "TPM_STS_DATA_EXPECT !=3D 0: read=20
> failure TPM_ACCESS(%d)\n", priv->locality);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev=
_info(&chip->dev, "TPM_STS_DATA_EXPECT !=3D 0: locality:=20
> %d status: %x access: %x\n", priv->locality, status, access);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D -EIO;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_err;
> =C2=A0=C2=A0=C2=A0=C2=A0}

Please find here the dmesg output of the patched kernel

--------------A9FE3B2D3EA7C477C0DA4586
Content-Type: application/gzip;
 name="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.txt.gz"

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
--------------A9FE3B2D3EA7C477C0DA4586
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--------------A9FE3B2D3EA7C477C0DA4586
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--------------A9FE3B2D3EA7C477C0DA4586--
