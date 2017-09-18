From: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Mon, 18 Sep 2017 14:38:03 +0200
Message-ID: <CA+zpnLe8hgSgBbjw8zF=pvykNo9mkVcyR65KY=vFckKf+XMb=Q@mail.gmail.com>
References: <20170911100022.7251-1-tweek@google.com> <20170911100022.7251-4-tweek@google.com>
 <20170911164750.GA2607@obsidianresearch.com> <20170912084851.z3ednbeojawnyxk2@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170912084851.z3ednbeojawnyxk2-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Sep 12, 2017 at 10:48 AM, Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Sep 11, 2017 at 10:47:50AM -0600, Jason Gunthorpe wrote:
>> On Mon, Sep 11, 2017 at 12:00:22PM +0200, Thiebaud Weksteen wrote:
>>
>> >     chip->bin_log_seqops.chip = chip;
>> > -   if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> > +
>> > +   if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
>> > +       (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))
>> >             chip->bin_log_seqops.seqops =
>> >                     &tpm2_binary_b_measurements_seqops;
>>
>> Lets have all the read_log_* versions return the postitive log_version
>> and get rid of the chip->flags check here.
>>
>> ie Doesn't ACPI always return the TPM 1 version?
>
> That is my understanding. Ashley, Nayna, could you confirm the format
> version expected by tpm_of? Could it be both?
>

I've changed the returned code for ACPI but not for DeviceTree.
Without confirmation for tpm_of, I am reluctant to modify the current
behaviour.

>>
>> Jason
