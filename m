From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Mon, 28 Aug 2017 17:15:58 +0000
Message-ID: <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170825172021.lw3ycxqw63ubrcm2-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> On Thu, Aug 24, 2017 at 10:37:14AM +0200, Alexander Steffen wrote:
> > When one of the commands during the auto_startup sequences does not
> > return TPM_RC_SUCCESS, tpm_chip_register misleadingly returns
> ENODEV,
> > even though a TPM device is definitely present.
> >
> > An error response during those sequences is indeed unexpected, so to
> > prevent subsequent errors, the kernel should not make use of the TPM
> > device. But user space applications still might be able to communicate
> > with the TPM, so they can be used to further diagnose and/or fix the
> > problem. To allow this, with this patch the device is still exported
> > to user space, even if a TPM error code has been received, but the
> > kernel itself will not be allowed to use the device for anything.
> >
> > This is not a hypothetical scenario, but there are devices in the wild
> > that show this behavior. With this fix, those devices can be recovered
> > from their failed state.
> >
> > Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> 
> I can understand the benefits but you could make the same argument for
> any class devices that kernel handles.

In a similar situation I probably would make that argument for other devices as well :-)

> I don't think it is that common to let user space access malfunctioning
> devices.

But is that just because nobody bothered to implement the necessary logic or for some other reason?

In my opinion, it strongly depends on the effects of the malfunction. If the device does not respond at all or returns only garbage, it is of course not useful to make it available. But the case that I want to handle here has a TPM that communicates correctly, i.e. the TIS layer works fine, it just does not return the application-level responses that the kernel expects. I'd like to think of it more as a transparent communication channel that the kernel provides to user space applications, without interfering with the data that is transmitted, similar to how a TCP socket is a transparent channel, that does not care about HTTP 500 codes being transmitted. So it is okay for the kernel to refuse to use such a device internally (the kernel knows there is nothing it can do with a broken device),
  but why assume that no user space application can use it either?

I'd rather argue that user space applications already need to be prepared to handle TPM errors/malfunctions at any time, so removing this one check does not put them into a worse position. The TPM driver just checks *at startup* that the TPM seems to be okay (i.e. executes all self tests correctly). But if you keep your machine running for two years the TPM may fail at any point and the driver never checks it again, so an application may never assume that simply because /dev/tpm0 exists it can send arbitrary commands there that will always work (in fact, such a look-before-you-leap approach can never be guaranteed to succeed).

Also, what would be the alternative? Your TPM is broken in a way that the kernel does not export it, how do you debug/fix the problem? You cannot even execute a TPM2_GetTestResult to get more detailed error information. So at the moment, we have user space applications bypassing the kernel driver completely, by accessing /dev/mem and reimplementing all the TIS logic. But this is just duplicated code (with its own set of problems, for example, if the kernel driver is active at the same time, there is nothing that prevents concurrent accesses), so nobody wants to implement a similar solution for SPI, and I2C, and all the other interfaces that might be necessary in the future.

> PS. You should have in *all* patches that you don't tag as RFC have linux-
> kernel-u79uwXL29TaiAVqoAR/hOA@public.gmane.org Now you have it in *none* of your patches.
> When you don't have RFC you are saying out loud that this is production
> ready code that should be included to the mainline kernel.
> 
> PPS. This patch set should be obviously RFC. It's  avery questionable and
> intrusive change. That's why I didn't include linux-kernel.

Sorry, thanks for explaining, will do that next time.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
