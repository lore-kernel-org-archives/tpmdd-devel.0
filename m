From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Wed, 10 Aug 2016 14:32:43 +0300
Message-ID: <20160810113243.GF13929@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470771295-15680-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 03:34:52PM -0400, Nayna Jain wrote:
> Overview:
> =========
> 
> This patch adds support for enabling securityfs for TPM2.0, currently
> driver has eventlog support only for TPM1.2.
> The patch currently adds support for only binary_bios_measurements.
> 
> The structure for TPM2.0 is compliant with TCG Spec for 2.0 family.
> Also , the reading of data has the assumption that writer would have
> followed TCG Spec and so everything is in little-endian.
> 
> The tpm device driver code has been refactored to:
> * Identify the TPM version - 1.2 or 2.0
> * Calls corresponding compatible seq_ops for iterating over eventlog.
> 
> Files Description:
> ===================
> 
> * tpm-chip.c : Adds call to setup bios log for TPM2.0.
> 
> * tpm2_of.c : Reads the device tree entries to find the location
> and size of event.
> 
> * tpm_eventlog_init.c : Provides common initialization functions
>  between TPM2.0 and TPM1.2 to setup securityfs entries and seq_ops
>   iterator.  The functions has been moved from tpm_eventlog.c into this file.
> 
>   * tpm_eventlog.c : Provides functions only specific to TPM1.2
>   version. Common initialization functions are moved to tpm_eventlog_init.c
> 
>   * tpm2_eventlog.c : Provides functions specific only for TPM2.0
>   eventlog format.
> 
>   * tpm2.h : Header file for TPM2.0 structures and functions.

diffstat shows changed files. Your commit messages will give detailed
descriptions. Please remove this. Cover letter would be the right place
to tell about missing ACPI support.

BTW, how this can be tested?

/Jarkko

> Changelog v2:
> =============
> 
> 	* Fixes issues as given in feedback by Jason.
> 	* Adds documentation for device tree.
> 
> Nayna Jain (3):
>   TPM2.0: Refactored eventlog init functions.
>   TPM2.0: TPM Device Tree Documentation
>   TPM2.0:Adds securityfs support for TPM2.0 eventlog
> 
>  Documentation/devicetree/bindings/i2c/i2c-tpm.txt |  31 +++
>  drivers/char/tpm/Makefile                         |   8 +-
>  drivers/char/tpm/tpm-chip.c                       |  22 +--
>  drivers/char/tpm/tpm.h                            |   2 +-
>  drivers/char/tpm/tpm2.h                           |  85 ++++++++
>  drivers/char/tpm/tpm2_eventlog.c                  | 224 ++++++++++++++++++++++
>  drivers/char/tpm/tpm_acpi.c                       |   2 +-
>  drivers/char/tpm/tpm_eventlog.c                   | 156 +--------------
>  drivers/char/tpm/tpm_eventlog.h                   |  18 +-
>  drivers/char/tpm/tpm_eventlog_init.c              | 174 +++++++++++++++++
>  drivers/char/tpm/tpm_of.c                         |  39 ++--
>  11 files changed, 570 insertions(+), 191 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-tpm.txt
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>  create mode 100644 drivers/char/tpm/tpm_eventlog_init.c
> 
> -- 
> 2.5.0
> 
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity 
> planning reports. http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
