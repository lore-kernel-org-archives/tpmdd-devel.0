From: Vicky <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Wed, 1 Feb 2017 23:40:33 -0500
Message-ID: <F14AC3E9-E04F-4EF0-9C7E-999D481EA577@linux.vnet.ibm.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
	<20170126220536.GB31937@obsidianresearch.com>
	<024dadba-a75c-ab59-9d12-a9bea81f9bda@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <024dadba-a75c-ab59-9d12-a9bea81f9bda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Michal Such??nek <msuchanek-l3A5Bk7waGM@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


> On Jan 26, 2017, at 5:58 PM, Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> =

> Adding Vicky from IBM.
> =

> =

> On 01/26/2017 04:05 PM, Jason Gunthorpe wrote:
>> On Thu, Jan 26, 2017 at 09:22:48PM +0100, Michal Such??nek wrote:
>> =

>>> This is repeated a few times in the driver so I added memset to quiet
>>> gcc and make behavior deterministic in case the unused fields get some
>>> meaning in the future.
>> Yep, reserved certainly needs to be zeroed.. Can you send a patch?
>> memset is overkill...
>> =

>>> However, in tpm_ibmvtpm_send the structure is initialized as
>>> =

>>> 	struct ibmvtpm_crq crq;
>>>         __be64 *word =3D (__be64 *)&crq;
>>> ...
>>>         crq.valid =3D (u8)IBMVTPM_VALID_CMD;
>>>         crq.msg =3D (u8)VTPM_TPM_COMMAND;
>>>         crq.len =3D cpu_to_be16(count);
>>>         crq.data =3D cpu_to_be32(ibmvtpm->rtce_dma_handle);
>>> =

>>> and submitted with
>>> =

>>> 	rc =3D ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
>>>                               be64_to_cpu(word[1]));
>>> meaning it is swapped twice.
>> No idea, Nayna may know.
>> =

>> My guess is that '__be64 *word' should be 'u64 *word'...
>> =

>> Jason
> =


I don=92t think we want =91word' to be changed back to be of type =91u64=92=
.   Please see commit 62dfd912ab3b5405b6fe72d0135c37e9648071f1


Vicky

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
