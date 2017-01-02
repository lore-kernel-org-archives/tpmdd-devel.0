From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Mon, 02 Jan 2017 13:40:48 -0800
Message-ID: <1483393248.2458.32.camel@HansenPartnership.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102193320.trawto65nkjccbao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Mon, 2017-01-02 at 21:33 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > This patch set adds support for TPM spaces that provide a context
> > > for isolating and swapping transient objects. This patch set does
> > > not yet include support for isolating policy and HMAC sessions 
> > > but it is trivial to add once the basic approach is settled (and
> > > that's why I created an RFC patch set).
> > 
> > The approach looks fine to me.  The only basic query I have is 
> > about the default: shouldn't it be with resource manager on rather 
> > than off?  I can't really think of a use case that wants the RM off 
> > (even if you're running your own, having another doesn't hurt 
> > anything, and it's still required to share with in-kernel uses).
> 
> This is a valid question and here's a longish explanation.
> 
> In TPM2_GetCapability and maybe couple of other commands you can get
> handles in the response body. I do not want to have special cases in 
> the kernel for response bodies because there is no a generic way to 
> do the substitution. What's worse, new commands in the standard 
> future revisions could have such commands requiring special cases. In
> addition, vendor specific commans could have handles in the response
> bodies.

OK, in general I buy this ... what you're effectively saying is that we
need a non-RM interface for certain management type commands.

However, let me expand a bit on why I'm fretting about the non-RM use
case.  Right at the moment, we have a single TPM device which you use
for access to the kernel TPM.  The current tss2 just makes direct use
of this, meaning it has to have 0666 permissions.  This means that any
local user can simply DoS the TPM by running us out of transient
resources if they don't activate the RM.  If they get a connection
always via the RM, this isn't a worry.  Perhaps the best way of fixing
this is to expose two separate device nodes: one raw to the TPM which
we could keep at 0600 and one with an always RM connection which we can
set to 0666.  That would mean that access to the non-RM connection is
either root only or governed by a system set ACL.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
