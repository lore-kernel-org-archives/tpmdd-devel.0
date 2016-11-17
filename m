From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's event log
Date: Thu, 17 Nov 2016 12:37:43 -0800
Message-ID: <20161117203743.odzdpwwynzlqyt5m@intel.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161116153731.pmmnxiai7ouuj6qf@intel.com>
 <3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
 <65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
 <20161116200759.GA19593@obsidianresearch.com>
 <ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, nayna@linux.vnet.ibm.com, linux-acpi@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 07:35:05AM -0500, Stefan Berger wrote:
> On 11/16/2016 03:07 PM, Jason Gunthorpe wrote:
> > On Wed, Nov 16, 2016 at 12:07:23PM -0500, Stefan Berger wrote:
> > > The culprit seems to be 'tpm: fix the missing .owner in
> > > tpm_bios_measurements_ops'
> > That is unlikely, it is probably the patch before which calls read_log
> > unconditionally now. That suggests the crashing is a little random..
> 
> I ran the vtpm driver test suite (with -j32) a few times at that patch and
> it didn't crash. It crashes severely with later patches applied. Here's the
> current experimental patch that fixes these problems:
> 
> iff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index 0cb43ef..a73295a 100644
> --- a/drivers/char/tpm/tpm_acpi.c
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -56,6 +56,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
> 
>      log = &chip->log;
> 
> +    if (!chip->acpi_dev_handle)
> +        return 0;
> +

If there is a problem in the TPM driver, this does not fix the
problem. It will mask the problem. Maybe there's an ACPI regression
in the rc tree?

This is a funky situation because those lines need to be there but
I do not want them before it is root caused that it is not a TPM
bug.

/Jarkko
