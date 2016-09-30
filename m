From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Fri, 30 Sep 2016 13:11:12 -0600
Message-ID: <20160930191112.GA5722@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160930185742.GB9595@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160930185742.GB9595-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 30, 2016 at 09:57:43PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 28, 2016 at 04:34:37AM -0400, Nayna Jain wrote:
> > Currently, the securityfs pseudo files for obtaining the firmware
> > event log are created whether the event log properties exist or not.
> > This patch creates ascii and bios measurements pseudo files
> > only if read_log() is successful.
> > 
> > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> I'm not going to accept this commit as this increases permanent memory
> consumption of the subsystem.

How much memory is this?

The patch set is supposed to change things so the permanent log is
used for all the accessor functions which avoids re-parsing every time
the log file sysfs is opened. Since the log never changes this is an
overall saner approach to handling the sysfs files. IIRC this was also
a simple way to solve some ref counting bugs in the current code.

Since this is just referencing reserved system memory, could the
memcpy and allocation just be eliminated? Or is there too much
transformation?

> You don't need to read the log in order check if it is there.

I disagree, a full parse is necessary, so it does need to be read.

We could throw it away and read it again and again at every use..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
