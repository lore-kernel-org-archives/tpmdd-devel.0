From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Wed, 27 Jul 2016 10:31:52 -0600
Message-ID: <20160727163152.GA27915@obsidianresearch.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
	<20160726203902.GA17730@us.ibm.com>
	<20160726210344.GA18332@obsidianresearch.com>
	<20160727160511.GA26597@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160727160511.GA26597-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: George Wilson <ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 27, 2016 at 11:05:14AM -0500, George Wilson wrote:

> > Yes, generally Linux expects DT to be set correctly by the boot
> > firmware. Early firmware needs to know the TPM type anyhow to do the
> > TPM setup, so this doesn't seem like a realistic scenario.
> 
> A reset is required after upgrade/downgrade.  But the version still
> needs to be detected by the firmware somehow.  It could be configured
> manually in firmware state after the upgrade/downgrade to properly set
> the property, which seems much less desirable than a probe.

Well, the firmware has to take care of this. If the firmware wants to
support switchable firmware it needs to be able to do probe that works
with all the firmware versions.

ACPI and DT both expect the TPM version to be passed to the OS, it is
up to the firmware to do that correctly..

The fact you've already seen TPM2 probing failures makes me very
reluctant to turn it on more broadly, and maybe even think we should
get rid of it from tis too..

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
