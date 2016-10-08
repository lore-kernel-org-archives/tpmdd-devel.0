From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically
 allocated bios_dir with a static array
Date: Sat, 8 Oct 2016 14:01:24 +0300
Message-ID: <20161008110124.GB7351@intel.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20161002212801.GC25872@obsidianresearch.com>
	<20161003122135.GB9990@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161003122135.GB9990-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 03, 2016 at 03:21:35PM +0300, Jarkko Sakkinen wrote:
> On Sun, Oct 02, 2016 at 03:28:01PM -0600, Jason Gunthorpe wrote:
> > On Sat, Oct 01, 2016 at 10:25:25PM +0300, Jarkko Sakkinen wrote:
> > 
> > > +	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> > > +		if (chip->bios_dir[i])
> > 
> > The entries can't actually be null here, right?
> 
> They can because this function is called as a rollbcak procedure for
> tpm_bios_log_setup.

I've tested these with Dell E6400 laptop and IvyBridge NUC both with TPM
1.2 chip by repeating this a few iterations:

1. modprobe tpm_tis
2. Outputted sysfs attributes
3. Outputted measurement files.
4. rmmod tpm_tis

I think these three commits could be applied at any point and would help
with the event log series (shrunk it a bit).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
