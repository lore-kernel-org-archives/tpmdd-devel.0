From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm-emulator: add a TPM emulator pass
 through
Date: Sun, 15 Jan 2017 21:25:08 -0500
Message-ID: <2b98d20d-3321-a986-f4f5-a0bd9add6244@linux.vnet.ibm.com>
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
	<c59ebdec-d1e1-b8d6-53b2-81973ea3e64f@linux.vnet.ibm.com>
	<1483992413.2398.16.camel@HansenPartnership.com>
	<7fa906c5-081f-f095-6730-dfcb35cda661@linux.vnet.ibm.com>
	<1484509202.2405.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1484509202.2405.18.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On 01/15/2017 02:40 PM, James Bottomley wrote:
> On Sun, 2017-01-15 at 14:18 -0500, Stefan Berger wrote:
>> On 01/09/2017 03:06 PM, James Bottomley wrote:
>>>>
>>>> Thanks. I fixed this now to make it at least compilable. The more
>>>> recent branch is the tpm2-preview.rev138, which makes that other
>>>> branch more or less obsolete.
>>> OK, with this branch, I can get a mostly successful run of the
>>> smoke tests.  The failure looks to be a dispute over who handles
>>> TPM_RC_RETRY
>> The following now also works after a (forced) updated on the swtpm
>> TPM2 preview branch:
>>
>> swtpm chardev --vtpm-proxy --tpmstate dir=/tmp --tpm2
>> swtpm chardev --vtpm-proxy --tpmstate dir=/tmp
> What would it take to get this into the master branch and released, so
> those of us who use standard distribution tools can get it?

The problem lies in the code that writes the TPM 2 state in host format 
rather than in Big Endian format, which would make the state portable 
and likely that is the preferred format for QEMU integration. Besides 
that there is some functionality missing for suspending the volatile 
state of the TPM 2.


https://github.com/stefanberger/libtpms/wiki

     Stefan



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
