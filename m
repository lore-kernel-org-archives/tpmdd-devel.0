From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] tpm_crb: Fix AMD Zen on-chip fTPM
 detection
Date: Fri, 16 Jun 2017 14:27:18 -0600
Message-ID: <20170616202718.GB1624@obsidianresearch.com>
References: <20170616182951.398757-1-manuel.lauss@gmail.com>
	<20170616192544.GA31769@obsidianresearch.com>
	<CAOLZvyEeiRQ8LfCmq1p70xv9worYfTXDPTgEZrhFcqUev1+h+Q@mail.gmail.com>
	<20170616195748.GA1624@obsidianresearch.com>
	<CAOLZvyFUS+Foj0ZycrZS=yWp+=x1mi8yL1-3Bq+mhcav9iesYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOLZvyFUS+Foj0ZycrZS=yWp+=x1mi8yL1-3Bq+mhcav9iesYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Manuel Lauss <manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 16, 2017 at 10:08:41PM +0200, Manuel Lauss wrote:
> On Fri, Jun 16, 2017 at 9:57 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Fri, Jun 16, 2017 at 09:41:38PM +0200, Manuel Lauss wrote:
> >> On Fri, Jun 16, 2017 at 9:25 PM, Jason Gunthorpe
> >> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >> > On Fri, Jun 16, 2017 at 08:29:51PM +0200, Manuel Lauss wrote:
> >> >> This RFC patch fixes 2 issues which prevent the fTPM device from being initialized
> >> >> by the tpm_crb driver:
> >> >>
> >> >> 1) use devm_ioremap() instead of devm_ioremap_resource() to fix the following error
> >> >> due to it not allowing overlapping resources:
> >> >>
> >> >> tpm_crb MSFT0101:00: can't request region for resource [mem 0xdd84f000-0xdd84ffff]
> >> >> tpm_crb: probe of MSFT0101:00 failed with error -16
> >> >
> >> > No, we can't do this, it breaks other situations that rely on
> >> > request_resource.
> >> >
> >> > We already put a work around for a very similar problem on a different
> >> > system, do you have commit?
> >> >
> >> > commit b4e2eb0651ac3180a942d378b040c5cc045113ee
> >> > Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >> > Date:   Tue Feb 21 14:14:24 2017 -0700
> >> >
> >> >     tpm crb: Work around BIOS's that report the wrong ACPI region size
> >> >
> >>
> >> Yes, that was actually the third problem I encountered on 4.11.5, but this
> >> patch does not fix point 1) above.
> >>
> >> /proc/iomem looks like this before the probe attempt:
> >> dd759000-dd868fff : ACPI Non-volatile Storage
> >>   dd84b000-dd84bfff : MSFT0101:00
> >>   dd84f000-dd84ffff : MSFT0101:00
> >>
> >> I have no idea yet why devm_request_mem_region() fails here. Is it because
> >> the ACPI NVS parent is already marked busy by the previous mapping
> >> of b000-bfff?
> >
> > Hum. I wonder what does
> >
> > static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
> >                       struct acpi_table_tpm2 *buf)
> > {
> >         ret = acpi_dev_get_resources(device, &resources, crb_check_resource,
> >                                      &io_res);
> >
> > return in io_res for this arrangment? I'm guessing it isn't
> > dd759000-dd868fff ?
> 
> It returns dd84b000-dd84bfff.  mapping that fails already.

Erm, okay, that is what guessed.

What do you mean 'mapping that fails already' ? The report you gave
above shows the failure is on the other region:

 tpm_crb MSFT0101:00: can't request region for resource [mem 0xdd84f000-0xdd84ffff]

Which supports my guess that the problem here is the multiple regions
and the fix is to map them all, as I described.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
