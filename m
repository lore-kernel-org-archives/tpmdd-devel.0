From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [Linux-ima-devel] [tpmdd-devel] TPM microconf
 at Linux Plumbers Conference?
Date: Fri, 12 Aug 2016 13:37:06 -0700
Message-ID: <1471034226.2407.74.camel@linux.vnet.ibm.com>
References: <20160606185712.GA10754@srcf.ucam.org>
	<20160607131954.GB3855@intel.com> <20160809071030.GA5955@intel.com>
	<20160812091434.GA23740@intel.com>
	<1471004721.4156.32.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-users-bounces@lists.sourceforge.net>
In-Reply-To: <1471004721.4156.32.camel@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-users>,
	<mailto:trousers-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-users>
List-Post: <mailto:trousers-users@lists.sourceforge.net>
List-Help: <mailto:trousers-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-users>,
	<mailto:trousers-users-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-users-bounces@lists.sourceforge.net
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-ima-devel@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, philip.b.tricca@intel.com, trousers-users@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2016-08-12 at 08:25 -0400, Mimi Zohar wrote:
> Hi Jarkko,
> 
> On Fri, 2016-08-12 at 12:14 +0300, Jarkko Sakkinen wrote:
> > On Tue, Aug 09, 2016 at 10:10:30AM +0300, Jarkko Sakkinen wrote:
> 
> > PS. One related topic worth of discussing would be event log 
> > handover from boot loader to the OS. We need to find some defacto 
> > approach for it shared by different boot loaders as TCG hasn't 
> > standardized anything similar to TCPA for TPM2.
> 
> Is there a reference for "TCPA"?

TCPA just means Trusted Computing Platform Alliance.  I'm not sure if
this is what you're looking for but it's the TCPA architecture spec:

http://www.trustedcomputinggroup.org/tcpa-main-specification-version-1-1b/

James



------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
