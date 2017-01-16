From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v8 2/2] tpm: add securityfs support for TPM
 2.0 firmware event log
Date: Mon, 16 Jan 2017 11:38:16 +0200
Message-ID: <20170116093816.7pzmpmcmlj4t5zr6@intel.com>
References: <1484121262-25732-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1484121262-25732-3-git-send-email-nayna@linux.vnet.ibm.com>
 <9c605b61-bd5f-eb74-8fc0-ac3587852808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9c605b61-bd5f-eb74-8fc0-ac3587852808@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 01:09:29PM -0500, Stefan Berger wrote:
> On 01/11/2017 02:54 AM, Nayna Jain wrote:
> > Unlike the device driver support for TPM 1.2, the TPM 2.0 does
> > not support the securityfs pseudo files for displaying the
> > firmware event log.
> > 
> > This patch enables support for providing the TPM 2.0 event log in
> > binary form. TPM 2.0 event log supports a crypto agile format that
> > records multiple digests, which is different from TPM 1.2. This
> > patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
> > event log parser which understand the TPM 2.0 crypto agile format.
> > 
> > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > ---
> >   drivers/char/tpm/Makefile                          |   2 +-
> >   .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
> >   drivers/char/tpm/tpm2_eventlog.c                   | 203 +++++++++++++++++++++
> >   drivers/char/tpm/tpm_acpi.c                        |   3 +
> >   drivers/char/tpm/tpm_eventlog.h                    |  63 +++++++
> >   5 files changed, 291 insertions(+), 15 deletions(-)
> >   rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
> >   create mode 100644 drivers/char/tpm/tpm2_eventlog.c
> > 
> > 
> > diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> > index b7718c9..169edf3 100644
> > --- a/drivers/char/tpm/tpm_acpi.c
> > +++ b/drivers/char/tpm/tpm_acpi.c
> > @@ -54,6 +54,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
> >   	u64 len, start;
> >   	struct tpm_bios_log *log;
> > 
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		return -ENODEV;
> > +
> 
> 
> Works with SeaBIOS when this check is disabled.

What about OF call paths?

>    Stefan

/Jarkko
