From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 20:40:47 +0200
Message-ID: <BE0E16D6-DEC9-4640-89D3-6609A877B8CD@gmx.de>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
 <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com>
 <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
 <20171024155526.GA32250@obsidianresearch.com>
 <CANc+2y6-P9MvjbL18h02SPwNMPyk4_cPFfL6LKHDXiKSHfv00A@mail.gmail.com>
 <20171024161118.GA348@obsidianresearch.com>
 <CAKdAkRT9sLux6S1qdd=j0nbXSBdnYGG_hvjny=ic0YJLVNnxzA@mail.gmail.com>
 <20171024181512.iaxtzgxexhki7aqr@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20171024181512.iaxtzgxexhki7aqr-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, David Safford <safford-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "open list:KEYS-TRUSTED" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



Am 24. Oktober 2017 20:15:12 MESZ schrieb Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
>On Tue, Oct 24, 2017 at 10:02:00AM -0700, Dmitry Torokhov wrote:
>> On Tue, Oct 24, 2017 at 9:11 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Tue, Oct 24, 2017 at 09:37:33PM +0530, PrasannaKumar
>Muralidharan wrote:
>> >> Hi Jason,
>> >>
>> >> On 24 October 2017 at 21:25, Jason Gunthorpe
>> >> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> >> > On Tue, Oct 24, 2017 at 09:21:15PM +0530, PrasannaKumar
>Muralidharan wrote:
>> >> >
>> >> >> Please check the RFC [1]. It does use chip id. The rfc has
>issues and
>> >> >> has to be fixed but still there could be users of the API.
>> >> >>
>> >> >> 1. https://www.spinics.net/lists/linux-crypto/msg28282.html
>> >> >
>> >> > That patch isn't safe at all. You need to store a kref to th
>chip in
>> >> > the hwrng, not parse a string.
>> >>
>> >> The drivers/char/hw_random/tpm-rng.c module does not store the
>chip
>> >> reference so I guess the usage is safe.
>> >
>> > It is using the default TPM, it is always safe to use the default
>tpm.
>> 
>> tpm-rng is abomination that should be kicked out as soon as possible.
>> It wrecks havoc with the power management (TPM chip drivers may go
>> into suspend state, but tpm_rng does not do any power management and
>> happily forwards requests to suspended hardware) and may be available
>> when there is no TPM at all yet (the drivers have not been probed
>yet,
>> or have gotten a deferral, etc).
>> 
>> TPM core should register HWRNGs when chips are ready.
>> 
>> Thanks.
>> 
>> -- 
>> Dmitry
>
>I'm fine to review a two patch set where:
>
>1. Patch 1 removes the existing TPM rng driver
>2. Patch 2 makes the TPM driver as rng producer

Yes, but tpm must be kept a hwrng source.
This is imho an important use case.

>
>Unrelate to patch that I'm proposing now but this sounds sensible.
>
>/Jarkko

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
