From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Sat, 1 Oct 2016 17:28:46 +0300
Message-ID: <20161001142846.GA31552@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161001120125.GC8664-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 01, 2016 at 03:01:25PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 28, 2016 at 04:34:37AM -0400, Nayna Jain wrote:
> > Currently, the securityfs pseudo files for obtaining the firmware
> > event log are created whether the event log properties exist or not.
> > This patch creates ascii and bios measurements pseudo files
> > only if read_log() is successful.
> 
> Re-reviewing this. The commit message should mention about preventing
> a race condition.
> 
> I think Jason was right. It makes code much more manageable with a
> small price of memory consumption.
> 
> > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm.h          |  6 +++++
> >  drivers/char/tpm/tpm_acpi.c     | 12 +++++++---
> >  drivers/char/tpm/tpm_eventlog.c | 53 +++++++++++++++++++----------------------
> >  drivers/char/tpm/tpm_eventlog.h |  7 +++++-
> >  drivers/char/tpm/tpm_of.c       |  4 +++-
> >  5 files changed, 48 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index b5866bb..68630cd 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -35,6 +35,8 @@
> >  #include <linux/cdev.h>
> >  #include <linux/highmem.h>
> >  
> > +#include "tpm_eventlog.h"
> > +
> >  enum tpm_const {
> >  	TPM_MINOR = 224,	/* officially assigned */
> >  	TPM_BUFSIZE = 4096,
> > @@ -156,6 +158,10 @@ struct tpm_chip {
> >  	struct rw_semaphore ops_sem;
> >  	const struct tpm_class_ops *ops;
> >  
> > +	struct tpm_bios_log log;
> 
> struct tpm_bios_log should be renamed as struct tpm_event_log in some
> commit of this patch set as tpm_bios_log is a misleading name.
> 
> > +	struct tpm_securityfs_data bin_sfs_data;
> > +	struct tpm_securityfs_data ascii_sfs_data;
> 
> I think this is otherwise right but the struct name is very clunky.
> First of all it doesn't own the data and IMHO now it kind of implies
> of owning.
> 
> Maybe something like tpm_event_log_fd would a better name. It's a
> description of the event log file essentially.

That's not a good name either because who knows if we have
new files there at some point. I would propose to use simply
struct tpmfs_fd for this data type.

Then the declariots would be simply:

struct tpmfs_fd binary_measurements_fd;
struct tpmfs_fd ascii_measurements_fd;

I think here the long descriptive names would be good use because
these fields are not heavily used in the soure code.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
