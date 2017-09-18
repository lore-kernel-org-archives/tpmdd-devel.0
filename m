From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi: call get_event_log before ExitBootServices
Date: Mon, 18 Sep 2017 20:56:28 +0300
Message-ID: <20170918175628.67evhsklb77nxbdk@linux.intel.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-3-tweek@google.com>
 <20170914184126.eevnstwq3i6fiq4j@linux.intel.com>
 <CACdnJuu2Aq1mvdvooBgC3-1jfi3CPnZ6WGysOGc2Xizm-mbU0w@mail.gmail.com>
 <20170914190247.rrbdzdexjjywxipf@linux.intel.com>
 <CA+zpnLfs=DhW6kgbLV63_XzmKS7VnGGE0ecbFBZ0bu4wx3Jf+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+zpnLfs=DhW6kgbLV63_XzmKS7VnGGE0ecbFBZ0bu4wx3Jf+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 18, 2017 at 02:28:45PM +0200, Thiebaud Weksteen wrote:
> On Thu, Sep 14, 2017 at 9:02 PM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Thu, Sep 14, 2017 at 11:48:54AM -0700, Matthew Garrett wrote:
> >> On Thu, Sep 14, 2017 at 11:43 AM, Jarkko Sakkinen
> >> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >> > On Mon, Sep 11, 2017 at 12:00:21PM +0200, Thiebaud Weksteen wrote:
> >> >> With TPM 2.0 specification, the event logs may only be accessible by
> >> >> calling an EFI Boot Service. Modify the EFI stub to copy the log area to
> >> >> a new Linux-specific EFI configuration table so it remains accessible
> >> >> once booted.
> >> >>
> >> >> When calling this service, it is possible to specify the expected format
> >> >> of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only the
> >> >> first format is retrieved.
> >> >>
> >> >> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >
> >> > With a quick skim the code change looks good but I remember from
> >> > Matthew's talk that there was this issue that ExitBootServices() would
> >> > cause a yet another event?
> >> >
> >> > I guess you could manually synthetize that event by reading the PCR
> >> > values right after ExitBootServices()?
> >>
> >> I think that would involve breaking SHA1… the information should be
> >
> > You are absolutely right, was not thinking clearly :-)
> >
> >> available in the TCG_TREE_FINAL_EVENTS configuration table, so it
> >> /should/ just be a matter of merging the events from that into the
> >> event log.
> >
> > Right, it is available through runtime services. Why this isn't part
> > of the patch set?
> 
> This is not included yet as this table
> (EFI_TCG2_FINAL_EVENTS_TABLE_GUID) relies on the TPM2 format for the
> log entries (TCG_PCR_EVENT2, "Crypto Agile"). I first plan to add the
> parsing of this log version (ie, efi_retrieve_tpm2_eventlog_2) before
> adding the merging of both tables. But these will be separate patch
> sets.

OK, this should be documented to the commit message to make it clear.

linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org is now up and running. I'm still
surviving from jetlag etc. so testing might be postponed either near end
of the week or next week.

Thanks for doing this. This is really important stuff in order to get the
Linux TPM 2.0 support feature complete.

/Jarkko
