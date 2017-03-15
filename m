From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: select CONFIG_CRYPTO
Date: Wed, 15 Mar 2017 19:58:09 +0200
Message-ID: <20170315175809.3ebyzy3r54s6g4nm@intel.com>
References: <20170314214043.3895041-1-arnd@arndb.de>
 <20170315083024.loltipc7h3uxwfaa@intel.com>
 <CAK8P3a2QgsDAuK2F5kQYha+yMwFoLU8N-O1x9ovX+zkax5Xk7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2QgsDAuK2F5kQYha+yMwFoLU8N-O1x9ovX+zkax5Xk7Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, Christophe Ricard <christophe.ricard@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 15, 2017 at 12:39:16PM +0100, Arnd Bergmann wrote:
> On Wed, Mar 15, 2017 at 9:30 AM, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > Arnd,
> >
> > On Tue, Mar 14, 2017 at 10:40:24PM +0100, Arnd Bergmann wrote:
> >> As we need the CRYPTO_HASH_INFO implementation, we should also
> >> select CRYPTO itself to avoid this build warning:
> >>
> >> warning: (TCG_TPM && TRUSTED_KEYS && IMA) selects CRYPTO_HASH_INFO which has unmet direct dependencies (CRYPTO)
> >>
> >> Fixes: c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > I've already merged this and put to my next branch.
> 
> Ah, I see my mistake: I had made an identical patch earlier, which you merged
> into linux-next, and I dropped it from my series after rebasing on
> -next, but then
> rebased again on mainline and did the new patch without checking whether
> it was already fixed in -next.
> 
> I guess the warning is rare enough that we don't really need this in v4.11
> even though it does apply there.
> 
>     Arnd

Ah. Right, now that I remember that was my conclusion. I'm sorry that
I did not remember to respond :-) If you think this would make sense
for 4.11 I could send it to stable.

/Jarkko
