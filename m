From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: tpm device not showing up in /dev anymore
Date: Tue, 29 Aug 2017 16:00:49 +0000
Message-ID: <dcad0104c46d4d5f88e642862bdb42c2@MUCSE603.infineon.com>
References: <f9526f55-df96-64fc-a4d6-877ce04e7156@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <f9526f55-df96-64fc-a4d6-877ce04e7156-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: bigon-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Laurent,

> Since the version 4.12 (I also tested with 4.13-rc5) of the kernel, the tpm
> device is not showing up in /dev/. In dmesg I can see the following
> lines:

Do you know what TPM you are using exactly (model number, firmware version, etc.)?

> > [    1.772153] tpm_tis 00:06: 1.2 TPM (device-id 0x6871, rev-id 1) [
> > 1.788106] tpm tpm0: tpm_transmit: tpm_send: error -5 [    1.788146]
> > tpm tpm0: A TPM error (-5) occurred attempting to determine the
> > timeouts [    1.788194] tpm_tis: probe of 00:06 failed with error -5 [
> > 1.796865] ima: No TPM chip found, activating TPM-bypass! (rc=-19) [
> > 10.085245] tpm_inf_pnp 00:06: Found TPM with ID IFX0102
> 
> If I'm reverting to 4.11, everything is working fine.

Error -5 is EIO, which is as far as I can tell only used in few places (related to expect flag checks) in the tpm_transmit code path that first reports that error. If this is what causes the problem, then it only tells us that the TPM did not understand the command correctly (it received not enough/too much data). I cannot see any obvious changes between 4.11 and 4.12 that might affect the behavior in that region.

> An idea how to troubleshoot this?

Can you run git bisect on the changes between 4.11 and 4.12, so that we find the offending commit? It is probably sufficient to limit the search to commits that touch something in drivers/char/tpm.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
