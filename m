From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 21:21:15 +0530
Message-ID: <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
 <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20171024154440.3jeupmus43jcgbbz-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Safford <safford-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "open list:KEYS-TRUSTED" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 24 October 2017 at 21:14, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Mon, Oct 23, 2017 at 10:31:39AM -0600, Jason Gunthorpe wrote:
>> On Mon, Oct 23, 2017 at 10:07:31AM -0400, Stefan Berger wrote:
>>
>> > >-int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>> > >+int tpm_pcr_extend(int pcr_idx, const u8 *hash)
>> > >  {
>> >
>> >
>> > I think every kernel internal TPM driver API should be called with the
>> > tpm_chip as a parameter. This is in foresight of namespacing of IMA where we
>> > want to provide the flexibility of passing a dedicated vTPM to each
>> > namespace and IMA would use the chip as a parameter to all of these
>> > functions to talk to the right tpm_vtpm_proxy instance. From that
>> > perspective this patch goes into the wrong direction.
>>
>> Yes, we should ultimately try and get to there.. Someday the
>> tpm_chip_find_get() will need to become namespace aware.
>>
>> But this patch is along the right path, eliminating the chip_num is
>> the right thing to do..
>>
>> > >-  tpm2 = tpm_is_tpm2(TPM_ANY_NUM);
>> > >+  tpm2 = tpm_is_tpm2();
>> > >   if (tpm2 < 0)
>> > >           return tpm2;
>> > >
>> > >@@ -1008,7 +1007,7 @@ static int trusted_instantiate(struct key *key,
>> > >   switch (key_cmd) {
>> > >   case Opt_load:
>> > >           if (tpm2)
>> > >-                  ret = tpm_unseal_trusted(TPM_ANY_NUM, payload, options);
>> > >+                  ret = tpm_unseal_trusted(payload, options);
>>
>> Sequences like this are sketchy.
>>
>> It should be
>>
>> struct tpm_chip *tpm;
>>
>> tpm = tpm_chip_find_get()
>> tpm2 = tpm_is_tpm2(tpm);
>>
>> [..]
>>
>> if (tpm2)
>>      ret = tpm_unseal_trusted(tpm, payload, options);
>>
>> [..]
>>
>> tpm_put_chip(tpm);
>>
>> As hot plug could alter the 'tpm' between the two tpm calls.
>>
>> Jason
>
> This patch just removes bunch of dead code. It does not change existing
> semantics. What you are saying should be done after the dead code has
> been removed. This commit is first step to that direction.
>
> /Jarkko

Please check the RFC [1]. It does use chip id. The rfc has issues and
has to be fixed but still there could be users of the API.

1. https://www.spinics.net/lists/linux-crypto/msg28282.html

Regards,
PrasannaKumar

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
