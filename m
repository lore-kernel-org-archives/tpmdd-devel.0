From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH v9 2/2] tpm: add securityfs
 support, for TPM 2.0 firmware event log
Date: Mon, 30 Jan 2017 15:08:42 +0530
Message-ID: <588F09A2.4090502@linux.vnet.ibm.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
	<CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> From: "Ken Goldman" <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
> <mailto:kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>>
> Date: 26-Jan-2017 2:53 AM
> Subject: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs
> support,for TPM 2.0 firmware event log
> To: <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> <mailto:linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>>,
> <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> <mailto:linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>>,
> <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>>
> Cc:
>
>     You do not need to send a new patch set version as long as this
>     one gets peer tested. And it needs to be tested without hacks
>     like plumbing TCPA with TPM 2.0 in QEMU. OF code paths needs to
>     be peer tested to be more specific.
>
>     For me the code itself looks good but I simply cannot take it in
>     in the current situation.
>
>     /Jarkko
>
>
> Tested-by: Kenneth Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
> <mailto:kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>>
>
> I validated a firmware event log taken from a Power 8 against PCR 0-7
> values for the SHA-1 and SHA-256 banks from a Nuvoton TPM 2.0 chip on
> that same platform.
>

Thank You Ken.

Jarkko, I hope now these patches can be accepted for 4.11.

Thanks & Regards,
    - Nayna


> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> <mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> <http://vger.kernel.org/majordomo-info.html>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
