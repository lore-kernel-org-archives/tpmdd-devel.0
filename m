From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Fri, 30 Sep 2016 20:42:13 -0600
Message-ID: <20161001024213.GA13028@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160930185742.GB9595@intel.com>
	<20160930191112.GA5722@obsidianresearch.com>
	<20160930194538.GA12710@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160930194538.GA12710-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Fri, Sep 30, 2016 at 10:45:38PM +0300, Jarkko Sakkinen wrote:

> Ok, this is interesting. What kind of refcounting bugs are related
> to existing approach?

IIRC it was because the log was being processed in an fops open()
callback, which itself was not properly serialized against chip
unregister. Avoiding doing any work with the pdev from under the
fops stuff makes the entire problem trivialy go away.

> > Since this is just referencing reserved system memory, could the
> > memcpy and allocation just be eliminated? Or is there too much
> > transformation?
> 
> Yeah, maybe the bigger reason is that I'm quite resistant to add
> stuff to struct tpm_chip without very good reasons.

Why? There is only 1 tpm event log and a few kb of memory means
nothing in a modern system.

> If you read the commit message, it basically says that this is done
> because of validation that the logs exist. As a simple minded person
> I then think of simplest thing that could work that sorts that out
> (in ACPI case check for existence of TCPA).

This is part of a larger theme to fix the event log processing stuff -
it is the last bit that hasn't been touched by the modernizing
efforts. It makes very little sense to reparse the log on every open
from user space and it makes zero sense to create the event log if the
log cannot parsed, plus the various issues with lifetime.

I personally am happy to burn small amounts of RAM if it makes the
code simpler and more obviously correct. Don't overoptimize this
stuff, it isn't worth it.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
