From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Subject: Re: Regression between Linux 3.16 and 4.8/4.9 on
 Lenovo X60 with coreboot
Date: Wed, 5 Apr 2017 13:03:42 +0200
Message-ID: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
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
To: pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GNUtoo-n+LsquliYkMdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Paul,

> tpm tpm0: Unable to read burstcount
> tpm tpm0: tpm_transmit: tpm_send: error -16
> tpm_tis tpm_tis: Could not get TPM timeouts and durations

This looks like a regression I had on ThinkPad X61S.

You can try with a patch from the following commit
which fixed it for me:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1d70fe9d9c3a4c627f9757cbba5d628687b121c1

It is included in mainline kernel 4.10.2.

Maciej


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
