From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] hwrng: meson: Fix module autoload for OF registration
Date: Mon, 17 Oct 2016 16:53:31 -0300
Message-ID: <82c306bc-4214-b923-ea45-f6358ed49722@osg.samsung.com>
References: <1476733214-19044-1-git-send-email-javier@osg.samsung.com>
 <CAOMZO5B+iDyNJ-heFU2Th-HQHocLS3Lz5zV7hFhiLs7ESJt2gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAOMZO5B+iDyNJ-heFU2Th-HQHocLS3Lz5zV7hFhiLs7ESJt2gw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Fabio Estevam <festevam@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Neil Armstrong <narmstrong@baylibre.com>, Kevin Hilman <khilman@baylibre.com>, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>, Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>, Carlo Caione <carlo@caione.org>, linux-amlogic@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hello Fabio,

On 10/17/2016 04:45 PM, Fabio Estevam wrote:
> On Mon, Oct 17, 2016 at 5:40 PM, Javier Martinez Canillas
> <javier@osg.samsung.com> wrote:
> 
>> --- a/drivers/char/tpm/Kconfig
>> +++ b/drivers/char/tpm/Kconfig
>> @@ -32,7 +32,7 @@ config TCG_TIS_CORE
>>
>>  config TCG_TIS
>>         tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
>> -       depends on X86
>> +       depends on X86 || COMPILE_TEST
> 
> This is a separate change.
> 

Yes, I did a commit by mistake. Sorry about that.

Jason already pointed out and I posted a v2.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
