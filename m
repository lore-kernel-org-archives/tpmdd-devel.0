From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after
	tpm_bios_log_setup
Date: Tue, 22 Nov 2016 18:48:22 +0200
Message-ID: <20161122164822.iwlz555zlhwcu2gd@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161118155249.sdxp2qfjfzfw4tzt@intel.com>
	<20161119182228.GA22775@obsidianresearch.com>
	<5831ED24.6070102@linux.vnet.ibm.com>
	<20161121171530.GB22237@obsidianresearch.com>
	<20161121202915.he2pgzoqza3rugnd@intel.com>
	<20161122163720.GB3956@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161122163720.GB3956-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 22, 2016 at 09:37:20AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 21, 2016 at 10:29:15PM +0200, Jarkko Sakkinen wrote:
> 
> > I just went through tpm_bios_log_setup(), tpm_read_log_of() and
> > tpm_read_log_acpi(). The error handling is sound now but the condition
> > should be in tpm_bios_log_setup(). Not in tpm_chip_register().
> > 
> > It is applied but if you don't mind I would like make a small commit
> > that moves the condition to that function.
> 
> I'm not particularly concerned where the check lives..

It's just a minor glitch but still an obvious inconsistency. Maybe
I'll ignore for th moment as everything is well tested.

There is still two commits in the series that are untested and
unreviewed.

/Jarkko

------------------------------------------------------------------------------
