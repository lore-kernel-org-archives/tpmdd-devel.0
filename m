From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Fri, 26 Aug 2016 12:12:21 -0400
Message-ID: <20160826161221.GA21990@intel.com>
References: <57B36698.7040904@linux.vnet.ibm.com>
	<20160816194853.GA26364@intel.com>
	<20160817041502.GA8656@intel.com>
	<57B3FD1B.9040606@linux.vnet.ibm.com>
	<20160817080914.GA8384@intel.com>
	<20160818195900.GD3676@obsidianresearch.com>
	<20160825211304.GC8658@intel.com>
	<20160825212038.GB8502@obsidianresearch.com>
	<20160826012536.GA16846@intel.com>
	<20160826114316.GA18279@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160826114316.GA18279-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 26, 2016 at 07:43:16AM -0400, Jarkko Sakkinen wrote:
> On Thu, Aug 25, 2016 at 09:25:36PM -0400, Jarkko Sakkinen wrote:
> > On Thu, Aug 25, 2016 at 03:20:38PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Aug 25, 2016 at 05:13:04PM -0400, Jarkko Sakkinen wrote:
> > > > > Other DT platforms like ARM will use the bindings defined in
> > > > > Documentation/DeviceTree.
> > > > 
> > > > So how do I know that this the right way to specify the attibutes for a
> > > > TPM device and all vendors would like to have the attributes like this?
> > > 
> > > If you accept the patch it becomes the right way for DT.
> > 
> > OK, thanks for educating me with this! My knowledge of DT is thin. I wasn't
> > aware that things where so unstandardized.
> > 
> > I'll take that point of view for the next version of the patch set and
> > just try to make sense whether the attributes make sense to me.
> 
> I asked my employer to order me a Raspberry PI 3 in order to have a
> device that utilizes a device tree instead of ACPI (and also to have
> something to test SPI and I2C connected TPMs). I'm looking forward to
> use that to test this patch set.

Or actually after some investigation Minnowboard is a better choice.
It's quite trivial to test either ACPI or DT with it, it seems.

/Jarkko

------------------------------------------------------------------------------
