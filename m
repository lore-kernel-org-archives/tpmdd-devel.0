From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 23:26:52 +0530
Message-ID: <CANc+2y523PgF_-ynp2xuor_2RUGLFhnK14F-Wf5i5hwRDmk_Fw@mail.gmail.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com> <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com> <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
 <20171024155526.GA32250@obsidianresearch.com> <CANc+2y6-P9MvjbL18h02SPwNMPyk4_cPFfL6LKHDXiKSHfv00A@mail.gmail.com>
 <20171024161118.GA348@obsidianresearch.com> <CANc+2y4VYWUON2Uo5M7SyyxtrMPiyY1Ln0WEkFLzKsHJ0v_keA@mail.gmail.com>
 <20171024174637.GB1806@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171024174637.GB1806@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-integrity@vger.kernel.org, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user@lists.sourceforge.net>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Matt Mackall <mpm@selenic.com>open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

On 24 October 2017 at 23:16, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Tue, Oct 24, 2017 at 09:44:30PM +0530, PrasannaKumar Muralidharan wrote:
>
>> I am wondering why it is wrong. Isn't the chip id valid till it is
>> unregistered? If so the rfc is correct. Please explain, may be I am
>> missing something.
>
> The lifetime is a bit complicated, but the general rule in the kernel
> for things like this it to use pointers, not ids, and certainly not
> string ids.
>
> For that patch it could just use container_of to get the chip..
>
> Jason

hwrng requires a unique name for every device. In that patch
"tpm-rng-<chip_num>" is used. chip_num is nothing but dev->dev_num.
This way more than 1 tpm chip can be used as rng provider.
tpm_get_random uses chip_num as its parameter. This is why
chip->dev_num was used.

Is that reasoning correct?

Please feel free to correct me if I am wrong.

Thanks,
PrasannaKumar
