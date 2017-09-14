From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 2/3] efi: call get_event_log before ExitBootServices
Date: Thu, 14 Sep 2017 12:02:47 -0700
Message-ID: <20170914190247.rrbdzdexjjywxipf@linux.intel.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-3-tweek@google.com>
 <20170914184126.eevnstwq3i6fiq4j@linux.intel.com>
 <CACdnJuu2Aq1mvdvooBgC3-1jfi3CPnZ6WGysOGc2Xizm-mbU0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuu2Aq1mvdvooBgC3-1jfi3CPnZ6WGysOGc2Xizm-mbU0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, jgunthorpe@obsidianresearch.com, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 14, 2017 at 11:48:54AM -0700, Matthew Garrett wrote:
> On Thu, Sep 14, 2017 at 11:43 AM, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > On Mon, Sep 11, 2017 at 12:00:21PM +0200, Thiebaud Weksteen wrote:
> >> With TPM 2.0 specification, the event logs may only be accessible by
> >> calling an EFI Boot Service. Modify the EFI stub to copy the log area to
> >> a new Linux-specific EFI configuration table so it remains accessible
> >> once booted.
> >>
> >> When calling this service, it is possible to specify the expected format
> >> of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only the
> >> first format is retrieved.
> >>
> >> Signed-off-by: Thiebaud Weksteen <tweek@google.com>
> >
> > With a quick skim the code change looks good but I remember from
> > Matthew's talk that there was this issue that ExitBootServices() would
> > cause a yet another event?
> >
> > I guess you could manually synthetize that event by reading the PCR
> > values right after ExitBootServices()?
> 
> I think that would involve breaking SHA1… the information should be

You are absolutely right, was not thinking clearly :-)

> available in the TCG_TREE_FINAL_EVENTS configuration table, so it
> /should/ just be a matter of merging the events from that into the
> event log.

Right, it is available through runtime services. Why this isn't part
of the patch set?

/Jrakko

/Jarkko
