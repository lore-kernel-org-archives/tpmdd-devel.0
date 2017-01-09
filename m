From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm-emulator: add a TPM emulator pass
 through
Date: Mon, 9 Jan 2017 13:03:55 -0500
Message-ID: <7bef4616-cd69-2798-fc1f-f7eee2fb8c98@linux.vnet.ibm.com>
References: <1483923513.2644.1.camel@HansenPartnership.com>
	<20170109154945.GA28023@obsidianresearch.com>
	<1483978982.2448.7.camel@HansenPartnership.com>
	<20170109165416.GA13960@obsidianresearch.com>
	<1483981445.2398.4.camel@HansenPartnership.com>
	<20170109171430.GA18648@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170109171430.GA18648-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/09/2017 12:14 PM, Jason Gunthorpe wrote:
>>> Not sure I see it, surely running a program in userspace is simpler
>>> than patching the kernel?
>> Heh, is that a serious question to a kernel developer?  If the program
>> actually existed, sure, but does it?
> Stefan has something to connect vtpm to a TPM2 emulator.

https://github.com/stefanberger/linux-vtpm-tests

#> ./src/vtpmctrl --help

This is a test tool for the Linux vTPM proxy driver

Usage: ./src/vtpmctrl options

The following options are supported:
--tpm2                 : A TPM 2 is used

--exit-on-user-request : The tool exits upon a request issued by the user.

--spawn program prg-params...
                        : Spawn the given program and pass to it the
                          file descriptor on which to listen for TPM
                          commands. If a parameter '%fd' appears among
                          the prg-params passed to the program, it will
                          be replaced by that file descriptor number.

                          This option must be the last option passed.

--help|-h|-?           : Display this help screen and exit.

Examples:
./src/vtpmctrl --tpm2 \
   --spawn /bin/swtpm chardev --tpm2 --fd %fd --tpmstate dir=/tmp

./src/vtpmctrl \
   --spawn /bin/swtpm chardev --fd %fd --tpmstate dir=/tmp



     Stefan


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
