From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 15:41:00 +0200
Message-ID: <20170103134100.stgxkmzbckon4jfb@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<1483421218.19261.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483421218.19261.4.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 09:26:58PM -0800, James Bottomley wrote:
> On Mon, 2017-01-02 at 13:40 -0800, James Bottomley wrote:
> > On Mon, 2017-01-02 at 21:33 +0200, Jarkko Sakkinen wrote:
> > > On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > > > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > > > This patch set adds support for TPM spaces that provide a 
> > > > > context for isolating and swapping transient objects. This 
> > > > > patch set does not yet include support for isolating policy and 
> > > > > HMAC sessions but it is trivial to add once the basic approach 
> > > > > is settled (and that's why I created an RFC patch set).
> > > > 
> > > > The approach looks fine to me.  The only basic query I have is 
> > > > about the default: shouldn't it be with resource manager on 
> > > > rather than off?  I can't really think of a use case that wants 
> > > > the RM off (even if you're running your own, having another 
> > > > doesn't hurt anything, and it's still required to share with in
> > > > -kernel uses).
> > > 
> > > This is a valid question and here's a longish explanation.
> > > 
> > > In TPM2_GetCapability and maybe couple of other commands you can 
> > > get handles in the response body. I do not want to have special 
> > > cases in the kernel for response bodies because there is no a 
> > > generic way to do the substitution. What's worse, new commands in 
> > > the standard future revisions could have such commands requiring 
> > > special cases. In addition, vendor specific commans could have 
> > > handles in the response bodies.
> > 
> > OK, in general I buy this ... what you're effectively saying is that 
> > we need a non-RM interface for certain management type commands.
> > 
> > However, let me expand a bit on why I'm fretting about the non-RM use
> > case.  Right at the moment, we have a single TPM device which you use
> > for access to the kernel TPM.  The current tss2 just makes direct use
> > of this, meaning it has to have 0666 permissions.  This means that 
> > any local user can simply DoS the TPM by running us out of transient
> > resources if they don't activate the RM.  If they get a connection
> > always via the RM, this isn't a worry.  Perhaps the best way of 
> > fixing this is to expose two separate device nodes: one raw to the 
> > TPM which we could keep at 0600 and one with an always RM connection 
> > which we can set to 0666.  That would mean that access to the non-RM 
> > connection is either root only or governed by a system set ACL.
> 
> OK, so I put a patch together that does this (see below). It all works
> nicely (with a udev script that sets the resource manager device to
> 0666):

This is not yet a comment about this suggestion but I guess one thing
is clear: the stuff in tpm2-space.c and tpm-interface.c changes are the
thing that we can mostly agree on and the area of argumentation is the
user space interface to it?

Just thinking how to split up the non-RFC patch set. This was also what
Jason suggested if I understood his remark correctly.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
