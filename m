From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Fri, 30 Sep 2016 22:45:38 +0300
Message-ID: <20160930194538.GA12710@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160930185742.GB9595@intel.com>
	<20160930191112.GA5722@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160930191112.GA5722-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 30, 2016 at 01:11:12PM -0600, Jason Gunthorpe wrote:
> On Fri, Sep 30, 2016 at 09:57:43PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 28, 2016 at 04:34:37AM -0400, Nayna Jain wrote:
> > > Currently, the securityfs pseudo files for obtaining the firmware
> > > event log are created whether the event log properties exist or not.
> > > This patch creates ascii and bios measurements pseudo files
> > > only if read_log() is successful.
> > > 
> > > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > 
> > I'm not going to accept this commit as this increases permanent memory
> > consumption of the subsystem.
> 
> How much memory is this?
> 
> The patch set is supposed to change things so the permanent log is
> used for all the accessor functions which avoids re-parsing every time
> the log file sysfs is opened. Since the log never changes this is an
> overall saner approach to handling the sysfs files. IIRC this was also
> a simple way to solve some ref counting bugs in the current code.

Ok, this is interesting. What kind of refcounting bugs are related
to existing approach?

> Since this is just referencing reserved system memory, could the
> memcpy and allocation just be eliminated? Or is there too much
> transformation?

Yeah, maybe the bigger reason is that I'm quite resistant to add
stuff to struct tpm_chip without very good reasons.

If there are good reasons, then why not.

If you read the commit message, it basically says that this is done
because of validation that the logs exist. As a simple minded person
I then think of simplest thing that could work that sorts that out
(in ACPI case check for existence of TCPA).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
