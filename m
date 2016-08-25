From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Thu, 25 Aug 2016 17:13:04 -0400
Message-ID: <20160825211304.GC8658@intel.com>
References: <57AC5802.1090109@linux.vnet.ibm.com>
	<20160811125818.GA9303@intel.com>
	<57ADC1C0.4030406@linux.vnet.ibm.com>
	<20160815212612.GC25212@intel.com>
	<57B36698.7040904@linux.vnet.ibm.com>
	<20160816194853.GA26364@intel.com>
	<20160817041502.GA8656@intel.com>
	<57B3FD1B.9040606@linux.vnet.ibm.com>
	<20160817080914.GA8384@intel.com>
	<20160818195900.GD3676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160818195900.GD3676-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 18, 2016 at 01:59:00PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 17, 2016 at 11:09:14AM +0300, Jarkko Sakkinen wrote:
> 
> > 1. Does TCG have a standard for this I2C binding in a DT like they have
> >    for ACPI?
> > 2. Can I expect that the binding has the same fields with the same names
> >    in some other platform that POWER? For example, what if there was an
> >    ARM based platform. Would the same binding work there?
> > 
> > I'm looking for document or something where you got your information.
> > Right now your code is based on nothing from my point of view.
> 
> There is no real standards body for device tree right now.
> 
> Submitting a Docuemtation patch to the device tree maintainers is the
> best we have today, and we as the TPM community should review it to
> ensure it makes sense from our perspective.
> 
> Other DT platforms like ARM will use the bindings defined in
> Documentation/DeviceTree.

So how do I know that this the right way to specify the attibutes for a
TPM device and all vendors would like to have the attributes like this?

> Jason

/Jarkko

------------------------------------------------------------------------------
