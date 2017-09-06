From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: tpm device not showing up in /dev anymore
Date: Wed, 6 Sep 2017 07:05:55 +0300
Message-ID: <20170906040555.fqedhmo5277sd6fq@linux.intel.com>
References: <f9526f55-df96-64fc-a4d6-877ce04e7156@debian.org>
 <dcad0104c46d4d5f88e642862bdb42c2@MUCSE603.infineon.com>
 <47c4300b-8701-79a6-1c58-3a5853f4c5e3@debian.org>
 <595efb25-8d87-f39d-037f-9c9a98462339@debian.org>
 <857106e4bb864bb8a68b1381fffc8f50@MUCSE603.infineon.com>
 <20170831164015.3ajgwydgxtippwoz@rhwork>
 <0d9be244-ace0-030d-6ff9-c4e94c63b7e9@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d9be244-ace0-030d-6ff9-c4e94c63b7e9-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Laurent Bigonville <bigon-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 01, 2017 at 02:10:18PM +0200, Laurent Bigonville wrote:
> Le 31/08/17 =E0 18:40, Jerry Snitselaar a =E9crit=A0:
> > On Thu Aug 31 17, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > > > Le 29/08/17 =E0 18:35, Laurent Bigonville a =E9crit=A0:
> > > > > Le 29/08/17 =E0 18:00, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org a =E9crit=
=A0:
> > > > >>> An idea how to troubleshoot this?
> > > > >> Can you run git bisect on the changes between 4.11 and 4.12, so =
that
> > > > >> we find the offending commit? It is probably sufficient to limit=
 the
> > > > >> search to commits that touch something in drivers/char/tpm.
> > > > >
> > > > > I'll try and keep you posted.
> > > > =

> > > > OK I've been able to bisect the problem and the bad commit is:
> > > > =

> > > > e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3 is the first bad commit
> > > > commit e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3
> > > > Author: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > Date:=A0=A0 Mon Mar 27 08:46:04 2017 -0700
> > > > =

> > > > =A0=A0=A0=A0 tpm_tis: convert to using locality callbacks
> > > > =

> > > > =A0=A0=A0=A0 This patch converts tpm_tis to use of the new tpm clas=
s ops
> > > > =A0=A0=A0=A0 request_locality, and relinquish_locality.
> > > > =

> > > > =A0=A0=A0=A0 With the move to using the callbacks, release_locality=
 is
> > > > changed so
> > > > =A0=A0=A0=A0 that we now release the locality even if there is no
> > > > request pending.
> > > > =

> > > > =A0=A0=A0=A0 This required some changes to the tpm_tis_core_init co=
de path to
> > > > =A0=A0=A0=A0 make sure locality is requested when needed:
> > > > =

> > > > =A0=A0=A0=A0=A0=A0 - tpm2_probe code path will end up calling
> > > > request/release through
> > > > =A0=A0=A0=A0=A0=A0=A0=A0 callbacks, so request_locality prior to tp=
m2_probe not needed.
> > > > =

> > > > =A0=A0=A0=A0=A0=A0 - probe_itpm makes calls to tpm_tis_send_data wh=
ich no
> > > > longer calls
> > > > =A0=A0=A0=A0=A0=A0=A0=A0 request_locality, so add request_locality =
prior to
> > > > tpm_tis_send_data
> > > > =A0=A0=A0=A0=A0=A0=A0=A0 calls. Also drop release_locality call in =
middleof
> > > > probe_itpm, and
> > > > =A0=A0=A0=A0=A0=A0=A0=A0 keep locality until release_locality calle=
d at end of
> > > > probe_itpm.
> > > > =

> > > > =A0=A0=A0=A0 Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> > > > =A0=A0=A0=A0 Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > =A0=A0=A0=A0 Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > > =A0=A0=A0=A0 Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
> > > > =A0=A0=A0=A0 Signed-off-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > =A0=A0=A0=A0 Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1560@public.gmane.org=
tel.com>
> > > > =A0=A0=A0=A0 Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563N0uC3ymp8PA@public.gmane.org=
l.com>
> > > > =A0=A0=A0=A0 Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.=
intel.com>
> > > > =

> > > > :040000 040000 70234365da69959d47076ebb40c8d17f520c3e44
> > > > 72f21b446e45ea1003de75902b0553deb99157fd M=A0=A0=A0 drivers
> > > > =

> > > =

> > > I've looked again at the code in question, but could not find
> > > anything that is obviously wrong there. Locality is now
> > > requested/released at slightly different points in the process than
> > > before, but that's it. It does not seem to cause problems with the
> > > majority of TPMs, since you are the first to report any, so maybe it
> > > is a quirk that only affects this device.
> > > =

> > > Perhaps Jerry can help, since this is his change?
> > > =

> > > Alexander
> > =

> > Getting some caffeine in me, and starting to take a look. Adding
> > Jarkko as well since this might involve the general locality changes.
> > =

> > Laurent, if I send you a patch with some debugging code added, would
> > you be able to run it on that system? I wasn't running into issues
> > on the system I had with a 1.2 device, but I no longer have access
> > to it. I'll see if I can find one in our labs and reproduce it there.
> =

> Yes I should be able to do that

Any findings?

/Jarkko

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
