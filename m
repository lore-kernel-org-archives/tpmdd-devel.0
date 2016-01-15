From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Multi-instance vTPM driver
Date: Fri, 15 Jan 2016 12:11:46 +0200
Message-ID: <20160115101146.GA11987@intel.com>
References: <1452787318-29610-1-git-send-email-stefanb@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452787318-29610-1-git-send-email-stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 14, 2016 at 11:01:54AM -0500, Stefan Berger wrote:
> From: Stefan Berger <stefanb-0rqouEpbLJlpnrxNGchxj0EOCMrvLtNR@public.gmane.org>
> 
> The following series of patches implements a multi-instance vTPM driver
> that can dynamically create TPM 'server' and client device pairs.
> 
> Using ioctl's on the provided /dev/vtpmx, a server and a client
> side vTPM device can be created. The server side offers a /dev/vtpms%d
> device and a TPM emulator must be started on it to listen for TPM commands
> that are written to /dev/vtpmc%d, which is created by the core TPM driver.
> 
> The primary goal of this series of patches is enabling vTPM for containers
> and hooking them up to a (future) namespaced IMA. However, the driver can
> also be used for simulating a hardware TPM on the host.
> 
> The last patch provides a test program for controlling device pairs.

I like the idea. Looking into this in more detail after the next pull
request. Thanks!

>    Stefan

/Jarkko

> 
> 
> Stefan Berger (4):
>   New flags for TPM chip avoiding filesystem registrations
>   Allow to provide a name pattern of the device
>   Implement driver for supporting multiple emulated TPMs
>   A test program for vTPM device creation
> 
>  drivers/char/tpm/Kconfig    |  10 +
>  drivers/char/tpm/Makefile   |   1 +
>  drivers/char/tpm/tpm-chip.c |  42 ++-
>  drivers/char/tpm/tpm-vtpm.c | 855 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm-vtpm.h |  58 +++
>  drivers/char/tpm/tpm.h      |   8 +-
>  include/uapi/linux/Kbuild   |   1 +
>  include/uapi/linux/vtpm.h   |  52 +++
>  vtpmctrl.c                  | 369 +++++++++++++++++++
>  9 files changed, 1386 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-vtpm.c
>  create mode 100644 drivers/char/tpm/tpm-vtpm.h
>  create mode 100644 include/uapi/linux/vtpm.h
>  create mode 100644 vtpmctrl.c
> 
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
