From: George Wilson <ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Regarding recently Added TPM2.0 support to the
 Nuvoton i2c driver
Date: Tue, 26 Jul 2016 15:39:02 -0500
Message-ID: <20160726203902.GA17730@us.ibm.com>
References: <5797A893.9020205@linux.vnet.ibm.com>
	<20160726201711.GA17742@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726201711.GA17742-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Andrew Azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 26, 2016 at 02:17:11PM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 26, 2016 at 11:44:43PM +0530, Nayna wrote:
> > I got these questions while testing some TPM2.0 stuff using the kernel 
> > code from repo having this patch and am using Nuvoton TPM.
> > 
> > #1. It seems that support is added only for following device-ids.
> >          {.compatible = "nuvoton,npct501"},
> >          {.compatible = "winbond,wpct301"},
> >          {.compatible = "nuvoton,npct601", .data = OF_IS_TPM2},
> > 
> > So, was wondering about why device id nuvoton,npct650  wasn't added for 
> > the support ?
> 
> Yes, that was the device ID list for Nuvoton.
> 
> It is convention in device tree to include older device IDs if the
> device is compatible.
> 
> So you might do
> 
>  compatible = "nuvoton,npct650", "nuvoton,npct601"
> 
> Andrew, is 601 even the right name?
> 
> > Was it expected to work with some wild-card type device-id as specified 
> > in the first line of description comment of file i.e. npct6XX. ?
> 
> No.
> 
> > So, why is there hard-coded checking and not using tpm2_probe() method 
> > which is itself based on direct TPM hardware response for setting the 
> > TPM2 flag. ? Is there something I am missing in the design which 
> > mandates to have .data set as OF_IS_TPM2.
> 
> Generally speaking probing is somewhat discouraged, currently we only
> probe for PC platform tis (and even that might be a mistake), all
> other drivers are designed to be explicit.

How should field upgradable/downgradable TPMs be handled since hardcoding
the version in the device tree might give the wrong answer?  Would early
firmware be expected to probe nonetheless and set the right device tree
property?

> 
> Jason
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity planning
> reports.http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
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
