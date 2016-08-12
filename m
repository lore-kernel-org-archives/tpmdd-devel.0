From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: TPM microconf at Linux Plumbers Conference?
Date: Fri, 12 Aug 2016 12:14:34 +0300
Message-ID: <20160812091434.GA23740@intel.com>
References: <20160606185712.GA10754@srcf.ucam.org>
	<20160607131954.GB3855@intel.com> <20160809071030.GA5955@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160809071030.GA5955-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 10:10:30AM +0300, Jarkko Sakkinen wrote:
> On Tue, Jun 07, 2016 at 04:19:54PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Jun 06, 2016 at 07:57:13PM +0100, Matthew Garrett wrote:
> > > Hi,
> > > 
> > > I'm looking into running a TPM microconference at the Linux Plubmers 
> > > Conference in Santa Fe the first week of November. Right now we have a 
> > > bunch of individual pieces of TPM-related technology, but little overall 
> > > coherence - almost nobody ships working TPM-enabled bootloaders, we have 
> > > no known-good PCR values available, distributions are unclear on what 
> > > the appropriate TPM 2.0 userlands to ship are, we don't even have a spec 
> > > for how PCRs should be used under Linux.
> > > 
> > > If this seems like it'd be useful, please add your name to 
> > > http://wiki.linuxplumbersconf.org/2016:tpms along with any additional 
> > > topics you'd like to discuss - and if you'd like to lead a short 
> > > discussion session, drop me an email with a description.
> > 
> > I'd be interested to join. If I get budget for this from my employer,
> > I'll be definitely here.
> 
> I can now confirm to be present here.

PS. One related topic worth of discussing would be event log handover
from boot loader to the OS. We need to find some defacto approach for
it shared by different boot loaders as TCG hasn't standardized anything
similar to TCPA for TPM2.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
