From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [TrouSerS-users] [Linux-ima-devel] TPM microconf
 at Linux Plumbers Conference?
Date: Tue, 16 Aug 2016 00:20:20 +0300
Message-ID: <20160815212020.GB25212@intel.com>
References: <20160606185712.GA10754@srcf.ucam.org>
	<20160607131954.GB3855@intel.com> <20160809071030.GA5955@intel.com>
	<20160812091434.GA23740@intel.com>
	<1471004721.4156.32.camel@linux.vnet.ibm.com>
	<1471034226.2407.74.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471034226.2407.74.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, trousers-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 12, 2016 at 01:37:06PM -0700, James Bottomley wrote:
> On Fri, 2016-08-12 at 08:25 -0400, Mimi Zohar wrote:
> > Hi Jarkko,
> > 
> > On Fri, 2016-08-12 at 12:14 +0300, Jarkko Sakkinen wrote:
> > > On Tue, Aug 09, 2016 at 10:10:30AM +0300, Jarkko Sakkinen wrote:
> > 
> > > PS. One related topic worth of discussing would be event log 
> > > handover from boot loader to the OS. We need to find some defacto 
> > > approach for it shared by different boot loaders as TCG hasn't 
> > > standardized anything similar to TCPA for TPM2.
> > 
> > Is there a reference for "TCPA"?
> 
> TCPA just means Trusted Computing Platform Alliance.  I'm not sure if
> this is what you're looking for but it's the TCPA architecture spec:
> 
> http://www.trustedcomputinggroup.org/tcpa-main-specification-version-1-1b/

I stated things bit incorrectly in my original response.

The ACPI table called TCPA is a kind of counter part for TPM2 ACPI table
with TPM 1.x chips. The key problem with TPM2 table is that it does not
have a memory reference for the event log.

The problem to discuss is how could boot loaders handover such data to the
OS.

> James

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
