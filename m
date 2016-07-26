From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Tue, 26 Jul 2016 15:03:44 -0600
Message-ID: <20160726210344.GA18332@obsidianresearch.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
	<20160726203902.GA17730@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726203902.GA17730-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: George Wilson <ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 26, 2016 at 03:39:02PM -0500, George Wilson wrote:
> > Generally speaking probing is somewhat discouraged, currently we only
> > probe for PC platform tis (and even that might be a mistake), all
> > other drivers are designed to be explicit.
> 
> How should field upgradable/downgradable TPMs be handled since hardcoding
> the version in the device tree might give the wrong answer?  Would early
> firmware be expected to probe nonetheless and set the right device tree
> property?

Is that a real thing?

Yes, generally Linux expects DT to be set correctly by the boot
firmware. Early firmware needs to know the TPM type anyhow to do the
TPM setup, so this doesn't seem like a realistic scenario.

For TPM we made a somewhat arbitary choice that TPM2 has to be
explicit. If there are real systems that benefit from auto-probing it
could be revisited..

But, to be honest, I'm not certain how robust our probe technique is,
and I think we should avoid probing, since TCG didn't design an
approved detection sequence (??).

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
