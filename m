From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Tue, 12 Sep 2017 10:48:51 +0200
Message-ID: <20170912084851.z3ednbeojawnyxk2@google.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-4-tweek@google.com>
 <20170911164750.GA2607@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170911164750.GA2607@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Ashley Lai <ashleydlai@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, linux-kernel@vger.kernel.org, mjg59@google.com, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 11, 2017 at 10:47:50AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 11, 2017 at 12:00:22PM +0200, Thiebaud Weksteen wrote:
>   
> >  	chip->bin_log_seqops.chip = chip;
> > -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +
> > +	if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
> > +	    (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))
> >  		chip->bin_log_seqops.seqops =
> >  			&tpm2_binary_b_measurements_seqops;
> 
> Lets have all the read_log_* versions return the postitive log_version
> and get rid of the chip->flags check here.
> 
> ie Doesn't ACPI always return the TPM 1 version?

That is my understanding. Ashley, Nayna, could you confirm the format
version expected by tpm_of? Could it be both?

> 
> Jason
