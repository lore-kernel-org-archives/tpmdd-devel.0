From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Mon, 18 Sep 2017 10:28:14 -0600
Message-ID: <20170918162814.GA32721@obsidianresearch.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-4-tweek@google.com>
 <20170911164750.GA2607@obsidianresearch.com>
 <20170912084851.z3ednbeojawnyxk2@google.com>
 <CA+zpnLe8hgSgBbjw8zF=pvykNo9mkVcyR65KY=vFckKf+XMb=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+zpnLe8hgSgBbjw8zF=pvykNo9mkVcyR65KY=vFckKf+XMb=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>
Cc: Ashley Lai <ashleydlai@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 18, 2017 at 02:38:03PM +0200, Thiebaud Weksteen wrote:
> On Tue, Sep 12, 2017 at 10:48 AM, Thiebaud Weksteen <tweek@google.com> wrote:
> > On Mon, Sep 11, 2017 at 10:47:50AM -0600, Jason Gunthorpe wrote:
> >> On Mon, Sep 11, 2017 at 12:00:22PM +0200, Thiebaud Weksteen wrote:
> >>
> >> >     chip->bin_log_seqops.chip = chip;
> >> > -   if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >> > +
> >> > +   if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
> >> > +       (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))
> >> >             chip->bin_log_seqops.seqops =
> >> >                     &tpm2_binary_b_measurements_seqops;
> >>
> >> Lets have all the read_log_* versions return the postitive log_version
> >> and get rid of the chip->flags check here.
> >>
> >> ie Doesn't ACPI always return the TPM 1 version?
> >
> > That is my understanding. Ashley, Nayna, could you confirm the format
> > version expected by tpm_of? Could it be both?
> >
> 
> I've changed the returned code for ACPI but not for DeviceTree.
> Without confirmation for tpm_of, I am reluctant to modify the current
> behaviour.

Move the TPM_CHIP_FLAG_TPM2 check into tpm_of to keep the current behavior
but still return the code..

Jason
