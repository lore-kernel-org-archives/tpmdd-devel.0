From: George Wilson <ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Wed, 27 Jul 2016 11:05:14 -0500
Message-ID: <20160727160511.GA26597@us.ibm.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
	<20160726203902.GA17730@us.ibm.com>
	<20160726210344.GA18332@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726210344.GA18332-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 26, 2016 at 03:03:44PM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 26, 2016 at 03:39:02PM -0500, George Wilson wrote:
> > > Generally speaking probing is somewhat discouraged, currently we only
> > > probe for PC platform tis (and even that might be a mistake), all
> > > other drivers are designed to be explicit.
> > 
> > How should field upgradable/downgradable TPMs be handled since hardcoding
> > the version in the device tree might give the wrong answer?  Would early
> > firmware be expected to probe nonetheless and set the right device tree
> > property?
> 
> Is that a real thing?

Yep, it's a thing.  I know of at least 2 parts from 2 different
suppliers that are field upgradable/downgradable.

> 
> Yes, generally Linux expects DT to be set correctly by the boot
> firmware. Early firmware needs to know the TPM type anyhow to do the
> TPM setup, so this doesn't seem like a realistic scenario.

A reset is required after upgrade/downgrade.  But the version still
needs to be detected by the firmware somehow.  It could be configured
manually in firmware state after the upgrade/downgrade to properly set
the property, which seems much less desirable than a probe.

> 
> For TPM we made a somewhat arbitary choice that TPM2 has to be
> explicit. If there are real systems that benefit from auto-probing it
> could be revisited..

I think it's as necessary - at least at the firmware level - as for
x86_64.

> 
> But, to be honest, I'm not certain how robust our probe technique is,
> and I think we should avoid probing, since TCG didn't design an
> approved detection sequence (??).

We did see issues with some older 1.2 TPMs that hung when probed by the
kernel with the wrong device driver but that hasn't been an issue for
some time.  It looks like UEFI ultimately does probe and likely that's
required for other platforms.  I don't think it's safe to assume a
TPM is always loaded with a particular firmware version across hard
resets.

> 
> Jason
> 

-- 
George Wilson
IBM Linux Technology Center
Security Development


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
