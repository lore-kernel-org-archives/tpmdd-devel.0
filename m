From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: tpm device not showing up in /dev anymore
Date: Thu, 9 Nov 2017 16:50:05 -0700
Message-ID: <20171109235005.pmklfw6zkjirahfa@localhost.localdomain>
References: <20170906040555.fqedhmo5277sd6fq@linux.intel.com>
 <20171014081318.busge2fhteusfjwx@rhwork>
 <b63b765d-2477-d9fe-9d80-c2ea7e582bce@debian.org>
 <20171023132346.jbqgokwv3ah2oqjo@linux.intel.com>
 <20171023134515.56siz3m6lhrhnovv@rhwork>
 <20171024135123.uqail7olnespun4k@linux.intel.com>
 <20171024145706.na56ff34w5agzo2t@rhwork>
 <20171024160725.r6kj452jdzpkbb6o@linux.intel.com>
 <8f4df9a9-c8cd-832f-4c3f-5305fabab7a8@debian.org>
 <0a6e4771-f871-b3ca-b5b0-26dbd9efa8b1@debian.org>
Reply-To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a6e4771-f871-b3ca-b5b0-26dbd9efa8b1-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Laurent Bigonville <bigon-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu Nov 09 17, Laurent Bigonville wrote:
>Le 09/11/17 =E0 01:04, Laurent Bigonville a =E9crit=A0:
>>
>>
>>Le 24/10/17 =E0 18:07, Jarkko Sakkinen a =E9crit=A0:
>>>On Tue, Oct 24, 2017 at 07:57:06AM -0700, Jerry Snitselaar wrote:
>>>>On Tue Oct 24 17, Jarkko Sakkinen wrote:
>>>>>On Mon, Oct 23, 2017 at 06:45:15AM -0700, Jerry Snitselaar wrote:
>>>>>>On Mon Oct 23 17, Jarkko Sakkinen wrote:
>>>>>>>On Sat, Oct 21, 2017 at 10:53:55AM +0200, Laurent Bigonville wrote:
>>>>>>>>Le 14/10/17 =E0 10:13, Jerry Snitselaar a =E9crit=A0:
>>>>>>>>>On Wed Sep 06 17, Jarkko Sakkinen wrote:
>>>>>>>>>>On Fri, Sep 01, 2017 at 02:10:18PM +0200, Laurent =

>>>>>>>>>>Bigonville wrote:
>>>>>>>>>>>Le 31/08/17 =E0 18:40, Jerry Snitselaar a =E9crit=A0:
>>>>>>>>>>>>On Thu Aug 31 17, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
>>>>>>>>>>>>>>Le 29/08/17 =E0 18:35, Laurent Bigonville a =E9crit=A0:
>>>>>>>>>>>>>>>Le 29/08/17 =E0 18:00, =

>>>>>>>>>>>>>>>Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org a =E9crit=A0:
>>>>>>>>>>>>>>>>>An idea how to troubleshoot this?
>>>>>>>>>>>>>>>>Can you run git bisect on the changes between 4.11 and
>>>>>>>>>>>4.12, so that
>>>>>>>>>>>>>>>>we find the offending commit? It is probably sufficient
>>>>>>>>>>>to limit the
>>>>>>>>>>>>>>>>search to commits that touch something in drivers/char/tpm.
>>>>>>>>>>>>>>>I'll try and keep you posted.
>>>>>>>>>>>>>>OK I've been able to bisect the problem and =

>>>>>>>>>>>>>>the bad commit is:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3 is =

>>>>>>>>>>>>>>the first bad commit
>>>>>>>>>>>>>>commit e6aef069b6e97790cb127d5eeb86ae9ff0b7b0e3
>>>>>>>>>>>>>>Author: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>>>>>>>>>>Date:=A0=A0 Mon Mar 27 08:46:04 2017 -0700
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 tpm_tis: convert to using locality callbacks
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 This patch converts tpm_tis to use of =

>>>>>>>>>>>>>>the new tpm class ops
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 request_locality, and relinquish_locality.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 With the move to using the callbacks, =

>>>>>>>>>>>>>>release_locality is
>>>>>>>>>>>>>>changed so
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 that we now release the locality even if ther=
e is no
>>>>>>>>>>>>>>request pending.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 This required some changes to the tpm_tis_cor=
e_init
>>>>>>>>>>>code path to
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 make sure locality is requested when needed:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0 - tpm2_probe code path will end up call=
ing
>>>>>>>>>>>>>>request/release through
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 callbacks, so request_locality pr=
ior to
>>>>>>>>>>>tpm2_probe not needed.
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0 - probe_itpm makes calls to =

>>>>>>>>>>>>>>tpm_tis_send_data which no
>>>>>>>>>>>>>>longer calls
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 request_locality, so add request_=
locality prior to
>>>>>>>>>>>>>>tpm_tis_send_data
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 calls. Also drop release_locality=
 call in middleof
>>>>>>>>>>>>>>probe_itpm, and
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0 keep locality until =

>>>>>>>>>>>>>>release_locality called at end of
>>>>>>>>>>>>>>probe_itpm.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1560@public.gmane.org=
tel.com>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Cc: Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Signed-off-by: Jerry Snitselaar <jsnitsel@red=
hat.com>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Reviewed-by: Jarkko Sakkinen
>>>>>>>>>>><jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Tested-by: Jarkko Sakkinen =

>>>>>>>>>>>>>><jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>>>>>>>>>>>>=A0=A0=A0=A0=A0 Signed-off-by: Jarkko Sakkinen
>>>>>>>>>>><jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>>>>>>>>>>>>:040000 040000 70234365da69959d47076ebb40c8d17f520c3e44
>>>>>>>>>>>>>>72f21b446e45ea1003de75902b0553deb99157fd M drivers
>>>>>>>>>>>>>>
>>>>>>>>>>>>>I've looked again at the code in question, but could not find
>>>>>>>>>>>>>anything that is obviously wrong there. Locality is now
>>>>>>>>>>>>>requested/released at slightly different =

>>>>>>>>>>>>>points in the process than
>>>>>>>>>>>>>before, but that's it. It does not seem to =

>>>>>>>>>>>>>cause problems with the
>>>>>>>>>>>>>majority of TPMs, since you are the first to report any, so
>>>>>>>>>>>maybe it
>>>>>>>>>>>>>is a quirk that only affects this device.
>>>>>>>>>>>>>
>>>>>>>>>>>>>Perhaps Jerry can help, since this is his change?
>>>>>>>>>>>>>
>>>>>>>>>>>>>Alexander
>>>>>>>>>>>>Getting some caffeine in me, and starting to =

>>>>>>>>>>>>take a look. Adding
>>>>>>>>>>>>Jarkko as well since this might involve the =

>>>>>>>>>>>>general locality changes.
>>>>>>>>>>>>
>>>>>>>>>>>>Laurent, if I send you a patch with some =

>>>>>>>>>>>>debugging code added, would
>>>>>>>>>>>>you be able to run it on that system? I wasn't =

>>>>>>>>>>>>running into issues
>>>>>>>>>>>>on the system I had with a 1.2 device, but I no =

>>>>>>>>>>>>longer have access
>>>>>>>>>>>>to it. I'll see if I can find one in our labs =

>>>>>>>>>>>>and reproduce it there.
>>>>>>>>>>>Yes I should be able to do that
>>>>>>>>>>Any findings?
>>>>>>>>>>
>>>>>>>>>>/Jarkko
>>>>>>>>>Okay, finally getting back to this. Looking at the =

>>>>>>>>>code it isn't clear
>>>>>>>>>to me
>>>>>>>>>why the change is causing this. So while I stare at this some more
>>>>>>>>>Laurent
>>>>>>>>>could you reproduce it with this patch so I can see =

>>>>>>>>>what the status and
>>>>>>>>>access registers look like? Does anyone else on here =

>>>>>>>>>happen to have a
>>>>>>>>>Sinosun
>>>>>>>>>tpm device? The systems I have access to with TPM1.2 =

>>>>>>>>>devices don't have
>>>>>>>>>this
>>>>>>>>>issue.
>>>>>>>>>
>>>>>>>>>--8<--
>>>>>>>>>
>>>>>>>>>diff --git a/drivers/char/tpm/tpm_tis_core.c
>>>>>>>>>b/drivers/char/tpm/tpm_tis_core.c
>>>>>>>>>index fdde971bc810..7d60a7e4b50a 100644
>>>>>>>>>--- a/drivers/char/tpm/tpm_tis_core.c
>>>>>>>>>+++ b/drivers/char/tpm/tpm_tis_core.c
>>>>>>>>>@@ -258,6 +258,7 @@ static int =

>>>>>>>>>tpm_tis_send_data(struct tpm_chip *chip,
>>>>>>>>>const u8 *buf, size_t len)
>>>>>>>>>=A0=A0=A0=A0=A0int rc, status, burstcnt;
>>>>>>>>>=A0=A0=A0=A0=A0size_t count =3D 0;
>>>>>>>>>=A0=A0=A0=A0=A0bool itpm =3D priv->flags & TPM_TIS_ITPM_WORKAROUND;
>>>>>>>>>+=A0=A0=A0 u8 access;
>>>>>>>>>
>>>>>>>>>=A0=A0=A0=A0=A0status =3D tpm_tis_status(chip);
>>>>>>>>>=A0=A0=A0=A0=A0if ((status & TPM_STS_COMMAND_READY) =3D=3D 0) {
>>>>>>>>>@@ -292,6 +293,11 @@ static int =

>>>>>>>>>tpm_tis_send_data(struct tpm_chip *chip,
>>>>>>>>>const u8 *buf, size_t len)
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 }
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 status =3D tpm_tis_status(chip);
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 if (!itpm && (status & TPM_STS_DATA_EXPEC=
T) =3D=3D 0) {
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D tpm_tis_read8(priv, TPM_=
ACCESS(priv->locality),
>>>>>>>>>&access);
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev=
, =

>>>>>>>>>"TPM_STS_DATA_EXPECT =3D=3D 0: read
>>>>>>>>>failure TPM_ACCESS(%d)\n", priv->locality);
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev=
, "TPM_STS_DATA_EXPECT =3D=3D 0:
>>>>>>>>>locality: %d status: %x access: %x\n", priv->locality, =

>>>>>>>>>status, access);
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EIO;
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_err;
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 }
>>>>>>>>>@@ -309,6 +315,11 @@ static int =

>>>>>>>>>tpm_tis_send_data(struct tpm_chip *chip,
>>>>>>>>>const u8 *buf, size_t len)
>>>>>>>>>=A0=A0=A0=A0=A0}
>>>>>>>>>=A0=A0=A0=A0=A0status =3D tpm_tis_status(chip);
>>>>>>>>>=A0=A0=A0=A0=A0if (!itpm && (status & TPM_STS_DATA_EXPECT) !=3D 0)=
 {
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0 rc =3D tpm_tis_read8(priv, =

>>>>>>>>>TPM_ACCESS(priv->locality), &access);
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0 if (rc < 0)
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev, "TPM_STS_D=
ATA_EXPECT !=3D 0: read
>>>>>>>>>failure TPM_ACCESS(%d)\n", priv->locality);
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0 else
>>>>>>>>>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_info(&chip->dev, "TPM_STS_D=
ATA_EXPECT =

>>>>>>>>>!=3D 0: locality:
>>>>>>>>>%d status: %x access: %x\n", priv->locality, status, access);
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D -EIO;
>>>>>>>>>=A0=A0=A0=A0=A0=A0=A0=A0 goto out_err;
>>>>>>>>>=A0=A0=A0=A0=A0}
>>>>>>>>Please find here the dmesg output of the patched kernel
>>>>>>>At least 0xff is corrupted value in senseful way. CPU fills the read
>>>>>>>with ones for example for unaligned bus read. See table 19 =

>>>>>>>in PC client
>>>>>>>spec. This can happen when you do unaligned read for example.
>>>>>>>
>>>>>>>Maybe TPM is unreachable i.e. powered off. Bit busy with =

>>>>>>>stuff ATM but
>>>>>>>would probably make sense to compare that 0x81 to table 18 =

>>>>>>>in the same
>>>>>>>spec.
>>>>>>>
>>>>>>>/Jarkko
>>>>>>0x81 is saying the access register status is valid, and the locality
>>>>>>is not active. That first bit means A Dynamic OS has not =

>>>>>>been previously
>>>>>>established on the platform. Normally we would see 0xa1, which would
>>>>>>mean valid register status, and the locality is active.
>>>>>I think the important thing to note here is that STS has bits set that
>>>>>should never be set. So we can conclude that TPM might be either
>>>>>
>>>>>1. Powered off
>>>>>2. In some transition state?
>>>>>
>>>>>/Jarkko
>>>>If it was powered off would we be getting a valid read from the access
>>>>register?
>>>I think there is no universal answer to that :-)
>>>
>>>Maybe adding a extra delay would be next test to make? If for random
>>>reason it is in-between states...
>>Any more ideas?
>>
>>The chip is definitely in a weird state :/ I tried several ways to =

>>reset the chip (windows, tpm-tools,...).
>>
>>I've been able to reset the chip via the bios (which now shows =

>>unowned) but chip is still locked apparently.
>>
>>But still with < 4.12 I'm able to get /some/ information Public EK, =

>>PCR,... out of the chip so it's not completely broken...
>
>OK correction the TPM is now unlocked (I let the computer running for =

>more than 24h with nothing accessing the TPM) and with 4.9 I've been =

>able to take the ownership again.
>
>Under 4.12 I still have the same errors as mentioned originally


Still thinking about how to attack this. I don't think extending the timeout
would change anything because it is reading the register, and thinking the
status is valid because it reads 0xff. So it would still have that problem,
right?

Maybe a sanity check could be added to wait_for_tpm_stat() to
first check that it didn't read 0xff before checking for the value it
is looking for. Would that make sense Jarkko?

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interf=
ace.c
index 1d6729be4cd6..8b77fa2003ce 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1087,7 +1087,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask,=
 unsigned long timeout,
                do {
                        tpm_msleep(TPM_TIMEOUT);
                        status =3D chip->ops->status(chip);
-                       if ((status & mask) =3D=3D mask)
+                       if ((status !=3D 0xff) && (status & mask) =3D=3D ma=
sk)
                                return 0;
                } while (time_before(jiffies, stop));
        }


---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
