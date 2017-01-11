From: Andreas Fuchs <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 11:00:43 +0100
Message-ID: <ee6c1e48-e21f-d05e-0939-473001224aba@sit.fraunhofer.de>
References: <kgoldman@us.ibm.com>
	<201701041612.v04GCfPK031525@wind.enjellic.com>
	<20170109231635.6wh25qoy7svcnys6@intel.com>
	<20170110200558.GA5102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170110200558.GA5102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


Am 10.01.2017 um 21:05 schrieb Jason Gunthorpe:
> On Tue, Jan 10, 2017 at 01:16:35AM +0200, Jarkko Sakkinen wrote:
>> On Wed, Jan 04, 2017 at 10:12:41AM -0600, Dr. Greg Wettstein wrote:
>>> The kernel needs a resource manager.  Everyone needs to think VERY
>>> hard and VERY, VERY carefully about what gets put into the kernel.  In
>>> making a decision, put the ABSOLUTE smallest amount of code into the
>>> kernel which allows various 'TPM2 personalities' to be implemented in
>>> userspace and functionally verified and protected by the physical
>>> instance.  The emergence of commodity TEE's (SGX, et.al) should be in
>>> the back of everyone's mind as a factor in the roadmap.
>> Here's my cuts for the kernel:
>>
>> - Kernel virtualizes handle areas. It's mechanical.
>> - Kernel does not virtualize bodies. It's not mechanical.
>> - At least the first version of the RM will not do other than session
>>    isolation for sessions.
>>
>> This keeps the core for RM inside the kernel small and tight.

You need to do virtualization inside bodies, because TPM2_FlushContext 
carries it's handles inside the parameter body.
Yep, huge blunder in the TPM spec, but hey, time for quirks... ;-)

> I think this makes sense.
>
> In addition the kernel should only permit RM operations that are known
> to be 100% correct with the RM.
>
> I think you should stick with your original design basic design,
> except instead of using an ioctl to switch modes, use an ioctl to
> execute the operation:
>
> struct tpm_ioctl_operation {
>     u16 mode;  // == TPM1_RAW,TPM2_RAW,TPM1_RM,TPM2_RM
>     u16 locality;
>     u32 txlen;
>     u32 rxlen;
>     const void *txbuf;
>     void *rxbuf;
> };

could we please get an ioctl, that switches the "mode" of the fd entirely.
I'd like to see the write()/read() support still intact.
All my current code uses main-loop based poll on the fd and I don't want
to be force to start using threads...

Thanks,
Andreas

>
> The userspace broker would be expected to use a mixture of RM and RAW
> operations.
>
> Let's deal with the idea of another cdev some other day when someone
> can figure out a comprehensive way to do that securely for unpriv..
>
> Jason
>
> ------------------------------------------------------------------------------
> Developer Access Program for Intel Xeon Phi Processors
> Access to Intel Xeon Phi processor-based developer platforms.
> With one year of Intel Parallel Studio XE.
> Training and support from Colfax.
> Order your platform today. http://sdm.link/xeonphi
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
