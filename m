From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Tue, 8 Mar 2016 21:40:01 +0200
Message-ID: <20160308194001.GA27228@intel.com>
References: <20160306120537.GA22702@intel.com>
	<20160306121103.GA23480@intel.com>
	<20160306122816.GA24077@intel.com>
	<201603081724.u28HOrRB005375@d01av03.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201603081724.u28HOrRB005375-CUdSWdNILC7ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
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

On Tue, Mar 08, 2016 at 12:24:10PM -0500, Stefan Berger wrote:
>    Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/06/2016
>    07:28:16 AM:
> 
>    >
>    > On Sun, Mar 06, 2016 at 02:11:03PM +0200, Jarkko Sakkinen wrote:
>    > > On Sun, Mar 06, 2016 at 02:05:37PM +0200, Jarkko Sakkinen wrote:
>    > > > Hi
>    > > >
>    > > > Some follow-up question that have popped up while I've started to
>    > > > write a test program for this feature mainly about ioctl API.  It's
>    > > > better to be extremly cautious here because we will be stuck with
>    this
>    > > > ioctl forever.
>    > > >
>    > > > 1. Why the ioctl name is VTPM_NEW_DEV but the struct name is
>    > > >    vtpm_new_pair? It would be better if they both were either
>    > > >    VTPM_NEW_DEV and vtpm_new_dev or alternatively VTPM_NEW_PAIR
>    > > >    and vtpm_new_pair.
>    > > > 2. Is 'pair' or 'tuple' a better term?
>    > > > 3. Where is the documentation for the ioctl? I don't think I can
>    > > >    merge this to my next branch before it exists.
>    > > > 4. I have forgotten why the major and minor numbers were returned.
>    > > >    My guess is that they were returned so that a container could
>    > > >    replicate the device? This is one reason why documentation is
>    > > >    mandatory.
>    > >
>    > > 5. Is there any particular reason why 'tpm_dev_num' couldn't simply be
>    > >    'dev_num'?
>    >
>    > I think you should still send a patch set after documentation has been
>    > completed and we have addressed these items to the following mailing
>    > lists:
>    >
>    > * linux-kernel
>    > * linux-api
>    > * linux-doc
>    > * tpmdd
>    >
>    > Now these patches have circled only in the tpmdd mailing list which
>    > is not sufficient. I just realized this recently that the relevant
>    > mailing lists were completely missing (while starting to write a
>    > test program).
>    >
>    > For patches up to TPM_CHIP_FLAG_VIRTUAL you could downloaded patches
>    > from my repository before posting the patch set since they include
>    > also my reviewed/tested-by's.
> 
>    I will post a v6 tomorrow again with the 3 vtpm related patches cc'ed to
>    the above mailing lists. V6 addresses the errno's Jason has been
>    suggesting.

I've used today improving this:

git://git.infradead.org/users/jjs/buildroot-tpmdd.git

By doing

make tpmdd_defconfig
make

You get a file called 'tpmdd.img' that you can flash to a USB stick. The
image is both legacy and UEFI bootable. The kernel is my latest master
and perf is included for tracing.

The compiled kernel has vtpm enabled.

There's a scripts called board/tpmdd/image.sh that does the image
generation magic. I've only tested it in Ubuntu environment.

As the next step I'll finish my test script for vtpm and use it and
TPM 2.0 simulator to test your functionality.

>       Stefan

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://makebettercode.com/inteldaal-eval
