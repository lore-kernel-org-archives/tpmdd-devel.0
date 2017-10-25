From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Wed, 25 Oct 2017 20:21:16 +0530
Message-ID: <CANc+2y4BtQGqtC8RJL1Srrz_kWwhyveV3HBpfO1kikFj+0mHaA@mail.gmail.com>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
 <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com>
 <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
 <20171024162359.tf5xulhlhokmuxh5@linux.intel.com>
 <CANc+2y4vtr+kbhC_7Rv=rHA2LgEVBHLFEu+DYYK1UmpU63PCgQ@mail.gmail.com>
 <20171024182235.d7b3oajc5zcjs57v@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20171024182235.d7b3oajc5zcjs57v-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Hi Jarkko,

On 24 October 2017 at 23:52, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Tue, Oct 24, 2017 at 10:05:20PM +0530, PrasannaKumar Muralidharan wrote:
>> > 1. Every user in the kernel is using TPM_ANY_NUM, which means there are
>> >    no other users.
>>
>> Completely agree that there is no in kernel users yet.
>
> And should never be. It's a bogus parameter that makes no sense.

I understood that after seeing latest patch that uses struct tpm_chip.
Sorry for the noise.

>> > 2. Moving struct tpm_rng to the TPM client is architecturally
>> >    uacceptable.
>>
>> As there was no response to the patch there is no way to know whether
>> it is acceptable or not.
>
> I like the idea of removing the tpm rng driver as discussed in other
> emails in this thread.

Thank you.

>> > 3. Using zero deos not give you any better guarantees on anything than
>> >    just using TPM_ANY_NUM.
>>
>> Chip id is used, not zero.
>
> Sorry I misread the patch first time. Anyway it's not any kind of ID to
> be trusted.

Okay.

>> > Why this patch is not CC'd to linux-integrity? It modifies the TPM
>> > driver. And in the worst way.
>>
>> TPM list is moderated and the moderator has not approved it yet.
>> get_maintainer script did not say about linux-integrity mailing list.
>>
>> It could be doing things in worst way but it is not known until some
>> one says. If no one tells it is the case I don't think it is possible
>> to fix. Which is what happened.
>
> Understood. We've moved to linux-integrity-u79uwXL29TaiAVqoAR/hOA@public.gmane.org MAINTAINERS
> update is in the queue for the next kernel release.

Sorry I never knew this.

>> > Implementing the ideas that Jason explained is the senseful way to
>> > get stable access. modules.dep makes sure that the modules are loaded
>> > in the correct order.
>>
>> If that is sensible then it is the way to go.
>>
>> There must be a reason to believe what is sensible and what is not.
>> Looks like this RFC has helped in judging that.
>>
>> Regards,
>> PrasannaKumar
>
> Would you be interested to work on patch set that would remove the
> existing tpm rng driver and make the TPM driver the customer? It's not
> that far away from the work you've been doing already.
>
> /Jarkko

I am late to the party. Jason has sent a patch doing that by the time
I read this email.

Thanks and regards,
PrasannaKumar

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
