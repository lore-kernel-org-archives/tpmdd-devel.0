From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] tpm: select CONFIG_CRYPTO
Date: Wed, 15 Mar 2017 12:39:16 +0100
Message-ID: <CAK8P3a2QgsDAuK2F5kQYha+yMwFoLU8N-O1x9ovX+zkax5Xk7Q@mail.gmail.com>
References: <20170314214043.3895041-1-arnd@arndb.de>
	<20170315083024.loltipc7h3uxwfaa@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170315083024.loltipc7h3uxwfaa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 15, 2017 at 9:30 AM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Arnd,
>
> On Tue, Mar 14, 2017 at 10:40:24PM +0100, Arnd Bergmann wrote:
>> As we need the CRYPTO_HASH_INFO implementation, we should also
>> select CRYPTO itself to avoid this build warning:
>>
>> warning: (TCG_TPM && TRUSTED_KEYS && IMA) selects CRYPTO_HASH_INFO which has unmet direct dependencies (CRYPTO)
>>
>> Fixes: c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>
> I've already merged this and put to my next branch.

Ah, I see my mistake: I had made an identical patch earlier, which you merged
into linux-next, and I dropped it from my series after rebasing on
-next, but then
rebased again on mainline and did the new patch without checking whether
it was already fixed in -next.

I guess the warning is rare enough that we don't really need this in v4.11
even though it does apply there.

    Arnd

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
