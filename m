From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 03 Jan 2017 11:34:29 -0800
Message-ID: <1483472069.2464.24.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<1483421218.19261.4.camel@linux.vnet.ibm.com>
	<20170103134100.stgxkmzbckon4jfb@intel.com>
	<1483460095.2464.6.camel@linux.vnet.ibm.com>
	<20170103183602.ar5typcvy2rx7cjs@intel.com>
	<20170103191456.vpl6ny7rbgu3yigx@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170103191456.vpl6ny7rbgu3yigx-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-03 at 21:14 +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 03, 2017 at 08:36:02PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 03, 2017 at 08:14:55AM -0800, James Bottomley wrote:
> > > On Tue, 2017-01-03 at 15:41 +0200, Jarkko Sakkinen wrote:
[...]
> > > > Just thinking how to split up the non-RFC patch set. This was 
> > > > also what Jason suggested if I understood his remark correctly.
> > > 
> > > SUre ... let's get agreement on how we move forward first.  How 
> > > the patch is activated by the user has to be sorted out as well
> > > before it can go in, but it doesn't have to be the first thing we 
> > > do.  I'm happy to continue playing with the interfaces to see 
> > > what works and what doesn't.  My main current feedback is that I 
> > > think separate devices works way better than an ioctl becuase the 
> > > separate devices approach allows differing system policies for 
> > > who accesses the RM backed TPM vs who accesses the raw one.
> > 
> > I think I see your point. I would rather name the device as tpms0 
> > but otherwise I think we could do it in the way you suggest...

I'm not at all wedded to the name tpm0rm, so tpms0 is fine by me.

> I think one more stronger argument for tpms0 is that it keeps tpm0
> intact. Those who don't care about tpms0 don't have to worry about it
> causing regressions. Also it makes it cleaner to put the whole 
> feature under a compilation flag, which would make to me because that 
> gives distributions a choice to not enable in-kernel RM when it first 
> hits the mainline.

I wouldn't go that far: one of the evils we cause for distros is too
many compile options.  In this case, I can't think of a good reason to
have an option to disable this now the feature is segregated on to a
separate device.  If we get a regression, only users of the new device
will notice.  If it's a compile option, this is the same if the distro
enables it and if it's disabled, no user can test out the feature (and
distros eventually get complaints about it not working).

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
