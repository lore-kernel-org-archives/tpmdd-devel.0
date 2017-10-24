From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 21:37:33 +0530
Message-ID: <CANc+2y6-P9MvjbL18h02SPwNMPyk4_cPFfL6LKHDXiKSHfv00A@mail.gmail.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com> <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com> <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
 <20171024155526.GA32250@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20171024155526.GA32250@obsidianresearch.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-integrity@vger.kernel.org, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user@lists.sourceforge.net>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Matt Mackall <mpm@selenic.com>open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

On 24 October 2017 at 21:25, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Tue, Oct 24, 2017 at 09:21:15PM +0530, PrasannaKumar Muralidharan wrote:
>
>> Please check the RFC [1]. It does use chip id. The rfc has issues and
>> has to be fixed but still there could be users of the API.
>>
>> 1. https://www.spinics.net/lists/linux-crypto/msg28282.html
>
> That patch isn't safe at all. You need to store a kref to th chip in
> the hwrng, not parse a string.

The drivers/char/hw_random/tpm-rng.c module does not store the chip
reference so I guess the usage is safe. The RFC is just a sample use
case of the API.

Regards,
PrasannaKumar
