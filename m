From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 11/11] A test program for vTPM
 devicecreation
Date: Fri, 11 Mar 2016 12:30:01 +0200
Message-ID: <20160311103001.GA13368@intel.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-12-git-send-email-stefanb@linux.vnet.ibm.com>
	<201603102058.u2AKw7Ie013400@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603102058.u2AKw7Ie013400-YREtIfBy6dDImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 10, 2016 at 03:57:58PM -0500, Stefan Berger wrote:
>    Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 03/09/2016 12:39:30
>    PM:
>    >
>    > This patch provides a program that is for testing purposes only.
>    >
>    > Build it using the following commands:
>    >
>    > make headers_install ARCH=x86_64  INSTALL_HDR_PATH=/usr
>    >
>    > gcc vtpmctrl.c -o vtpmctrl
>    >
>    > To use it:
>    >
>    > To create a device pair and have vtpmctrl listen for commands, display
>    > them and respond with TPM success messages do:
>    >
>    > Created TPM device /dev/tpm0; vTPM device has fd 4, major/minor =
>    10/224.
>    >
>    > In another shell do
>    >
>    > 00000000 00 c4 00 00 00 0a 00 00 00 00
>    > 00000012
> 
>    This test program is now available as part of a test suite at:
> 
>    https://github.com/stefanberger/linux-vtpm-tests

I've ported TPM 2.0 simulator proxy here

git://git.infradead.org/users/jjs/tpm2-scripts.git

At the moment it gets blocked on write() at client side and on read() at
server side. Haven't yet applied the timeouts patch but I'd expect
things to work without that patch since it's a separate patch

My environment is such that:

* I have built my environment with
  git://git.infradead.org/users/jjs/buildroot-tpmdd.git [1]
* I'm using QEMU.
* I have MS TPM 2.0 emulator running on the host side with wine.
* I use tpm2-simulator-vtpm script to connect the simulator to
  a tpm device.

If I run for example my tpm2-list-handles script it gets stuck
and read call to the returned fd inside my test script never
returns.

>       Stefan

[1] make tpmdd_defconfig && make and you will get a legacy/UEFI
    bootable tpmdd.img + bleeding edge kernel from my master
    branch.

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
