From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 0/2] fixes to char/tpm: Introduce native
	SPI TIS/FIFO driver
Date: Tue, 29 Dec 2015 19:40:17 +0100
Message-ID: <201512291940.17950.PeterHuewe@gmx.de>
References: <1451413985-21362-1-git-send-email-bfreed@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1451413985-21362-1-git-send-email-bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org, semenzato-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Bryan,

Am Dienstag, 29. Dezember 2015, 19:33:03 schrieb Bryan Freed:
> We have applied your "char/tpm: Introduce native SPI TIS/FIFO driver" patch
> to our tree (v3.18 with appropriate patches to v4.3-rc7).  We have a couple
> minor patches.
> 
> I am curious to know the status of breaking it up into pieces as you
> mentioned in your 10/30 submission email.

Thanks for your patches -- about the status, I originally intended to have it 
complete for 4.5, however since a lot of rework/refactoring went into that 
latest pull request I simply waited it out.

I'll cc you on the next update.

Shall/may I squash your patches into the next version?

Thanks,
Peter


> 
> Thanks,
> 
> bryan.
> 
> Bryan Freed (1):
>   tpm: Restore the dependancy of TCG_TIS on X86.
> 
> Suresh Rajashekara (1):
>   tpm: Fix a TPM print format / build error.
> 
>  drivers/char/tpm/Kconfig          | 1 +
>  drivers/char/tpm/tpm_tis_common.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)


------------------------------------------------------------------------------
