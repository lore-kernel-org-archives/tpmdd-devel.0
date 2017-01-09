From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm-emulator: add a TPM emulator pass
 through
Date: Mon, 9 Jan 2017 14:37:11 -0500
Message-ID: <c59ebdec-d1e1-b8d6-53b2-81973ea3e64f@linux.vnet.ibm.com>
References: <1483923513.2644.1.camel@HansenPartnership.com>
	<20170109154945.GA28023@obsidianresearch.com>
	<1483978982.2448.7.camel@HansenPartnership.com>
	<20170109165416.GA13960@obsidianresearch.com>
	<1483981445.2398.4.camel@HansenPartnership.com>
	<20170109171430.GA18648@obsidianresearch.com>
	<7bef4616-cd69-2798-fc1f-f7eee2fb8c98@linux.vnet.ibm.com>
	<1483986287.2398.5.camel@HansenPartnership.com>
	<1e9d8540-63b9-e6fe-d643-30705030d49c@linux.vnet.ibm.com>
	<1483987877.2398.9.camel@HansenPartnership.com>
	<fdbd3976-e457-f17e-faed-e40e749f5a21@linux.vnet.ibm.com>
	<1483989503.2398.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1483989503.2398.13.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/09/2017 02:18 PM, James Bottomley wrote:
> On Mon, 2017-01-09 at 13:52 -0500, Stefan Berger wrote:
>> On 01/09/2017 01:51 PM, James Bottomley wrote:
>>> On Mon, 2017-01-09 at 13:41 -0500, Stefan Berger wrote:
>>>> On 01/09/2017 01:24 PM, James Bottomley wrote:
>>>>> On Mon, 2017-01-09 at 13:03 -0500, Stefan Berger wrote:
>>>>>> Examples:
>>>>>> ./src/vtpmctrl --tpm2 \
>>>>>>       --spawn /bin/swtpm chardev --tpm2 --fd %fd --tpmstate
>>>>>> dir=/tmp
>>>>> git head for swtpm is giving
>>>>>
>>>>> Created TPM device /dev/tpm1; vTPM device has fd 4, major/minor
>>>>> =
>>>>> 247/1.
>>>>> chardev: unrecognized option '--tpm2'
>>>> You need the tpm2-preview branches of libtpms and swtpm. Why you
>>>> need
>>>> them is related to the format in which the persistent data are
>>>> written by the TPM 2 implementation. For QEMU it should probably
>>>> big
>>>> endian, but so far it's not.
>>>>
>>>> Here's a short wiki of libtpms pointing out the issues.
>>>>
>>>> https://github.com/stefanberger/libtpms/wiki
>>>>
>>>> https://github.com/stefanberger/libtpms/tree/tpm2-previewa.rev138
>>>> https://github.com/stefanberger/swtpm/tree/tpm2-preview
>>> Basically the synopsis is that it's not yet working well enough to
>>> run the resource manager smoke tests and I need to continue using
>>> the ibmswtpm2 as the emulator or run against the real thing for the
>>> time being.
>> Have you tried it ?
> Git head of the tpm2-preview branch of libtpms isn't building for me:
>
> tpm2/ExecCommand.c: In function 'ExecuteCommand':
> tpm2/ExecCommand.c:434:37: error: 'commandIndex' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
>       buffer = MemoryGetResponseBuffer(commandIndex);
>                                       ^
> cc1: all warnings being treated as errors
>
> I also think you probably need this patch
>
> James
>
> ---
>
> diff --git a/configure.ac b/configure.ac
> index e84bc0f..4ab149d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -125,7 +125,7 @@ openssl)
>   esac
>
>   AC_ARG_WITH([tpm2],
> -	AC_HELP_STRING([--wih-tpm2],
> +	AC_HELP_STRING([--with-tpm2],
>                          [build libtpms with TPM2 support (experimental)]),
>           AC_MSG_RESULT([Building with TPM2 support])
>           #if test "x$cryptolib" = "xfreebl"; then


Thanks. I fixed this now to make it at least compilable. The more recent 
branch is the tpm2-preview.rev138, which makes that other branch more or 
less obsolete.

    Stefan



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
