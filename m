From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/1] tpm_tis: convert to use locality
	callbacks
Date: Sat, 25 Mar 2017 13:05:20 -0700
Message-ID: <20170325200521.19224-1-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is an attempt to convert tpm_tis over to using the locality
callbacks added by Jarkko's tpm_crb patch. Requires the patch
currently on tpmdd/locality which has moved the need_locality
assignment inside the mutex in tpm_transmit.

This is pretty much the same as Jarkko's earlier patch (I think),
with the addition of my changes to probe_itpm and tpm_tis_core_init.
If this looks good Jarkko, if you want to split it out and have my
changes go on top of your patch, or fold my changes into your patch
that is fine.

Tested on TPM2.0 based tpm_tis device. Will test on TPM1.2 device
this afternoon when I dig out the laptop and switch it over to
the discrete tpm.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
