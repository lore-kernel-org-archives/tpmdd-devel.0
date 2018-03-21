From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: A subtle problem when resuming xen-front and using
 IMA and multiple TPM devices on the system
Date: Wed, 21 Mar 2018 19:27:00 -0400
Message-ID: <4a3240b7-32b2-7ee9-f4c4-89719070aeeb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

I tried to convert the IMA code to look up a TPM chip and use it until 
shutdown, when it releases it before device_shutdown(). Ideally this 
would work but because of xen-front's resume code it doesn't. There the 
chip is unregistered upon domU resume (tpmfront_resume calls 
tpmfron_remove) and for that reason IMA cannot be holding onto that chip 
until shutdown. Now the subtle problem comes into play when we were to 
use tpm_vtpm_proxy (with IMA namespaces for example some day) inside a 
domU that is resumed. Upon resume the domU looses its first chip, which 
would be the vTPM accessed via xen-front. IMA now uses 
tpm_pcr_extrend(NULL, ...) to extend a PCR and looks up the first chip 
due to the NULL parameter and now finds a tpm_vtpm_proxy's chip to 
extend the PCR into and this messes up the PCR. So that's bad and only 
in this particular configuration.

Due to how the xen-front works, the solution may be to:
- return -ENODEV from any public TPM API functions in case NULL is being 
passed as chip parameter; do not look up the chip, it will not return 
the one that was there before domU resume
- all subsystems that want to use a TPM have to look it up at the very 
beginning when there is only a hardware TPM there or the domU TPM
    - all these subsystems (looks like IMA and trusted keys) have to 
register a xen-release-tpm-device notifier that is invoked upon 
xen-front resume and causes the subsystems to release the device; upon 
domU resume these subsystems loose their TPM access

Another solution may be to introduce some flags that describe the chips 
and tpm_chip_find_get() would take these flags and check whether a chip 
has these flags set so that IMA and trusted keys wouldn't use a 
tpm_vtpm_proxy in that case.

Comments?

    Stefan






------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
