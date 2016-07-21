From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: fix a race condition
	tpm2_unseal_trusted()
Date: Thu, 21 Jul 2016 10:25:36 -0600
Message-ID: <20160721162536.GC19849@obsidianresearch.com>
References: <1468973792-17598-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160720164818.GA21460@obsidianresearch.com>
	<20160720205314.GA6525@intel.com>
	<20160720211332.GA32417@obsidianresearch.com>
	<20160721090245.GA7999@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160721090245.GA7999-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 21, 2016 at 12:02:45PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jul 20, 2016 at 03:13:32PM -0600, Jason Gunthorpe wrote:
> > On Wed, Jul 20, 2016 at 11:53:14PM +0300, Jarkko Sakkinen wrote:
> > 
> > > The only use cases I see at the moment for it work this way:
> > > 
> > > 1. Call tpm_try_get_ops.
> > > 2. Send a TPM command.
> > > 3. Call tpm_put_ops.
> > 
> > Right, but that is just a reflection of what the in kernel users are
> > doing today, not necessarily what they should be doing.
> > 
> > We should not break the put/get semantics..
> > 
> > > I did not find any other form of use. The only use is to make sure that
> > > there are no transactions running before the ops are cleared. Or did I
> > > overlook something perhaps?
> > 
> > The put/get is intended to allow a kapi user to hold a ref to tpm
> > without it geting destroyed. It is not intended to be an exclusive lock.
> 
> These operations *are not* exposed to kapi. They are interal to the
> driver. That's why it does not make sense speak about kapi user.

Right now yes, but look at other subsystems and you will see
operations like that, because that is typical design pattern. When I
wrote them I made sure they could be used in that typical way.

We have issues in our kapi users with regards to hot plug and multiple
tpms. Fortunately that basically never happens, but it does indicate
the API is not sufficient..

> You are speaking how it could be used. I'm looking at how it's actually
> used. Shouldn't implementation reflect that rather than future
> prospects?

Well, there are common patterns in the kernel for how these things
work and the get/put stuff does not imply an exclusive lock. That is
why it is called get/put :)

> > Those sorts of compound ops should hold the tpm_mutex manually, not
> > through the get_ops scheme.
> 
> The next best option would be to have unlocked transmit_cmd function.

The locking needs a good scrub, it is one of the last legacy things
left now that doesn't make alot of sense, especially if we need to
lock these compound operations.

The get/put locking cleanup was just a small step toward something
more typical..

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
