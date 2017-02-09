From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 9 Feb 2017 14:54:41 -0700
Message-ID: <20170209215441.GA3131@obsidianresearch.com>
References: <jarkko.sakkinen@linux.intel.com>
	<201702090906.v1996c6a015552@wind.enjellic.com>
	<20170209151922.cqo32h4io5dqyvvw@intel.com>
	<20170209190426.GA1104@obsidianresearch.com>
	<1486668591.2616.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486668591.2616.45.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 09, 2017 at 11:29:51AM -0800, James Bottomley wrote:
> On Thu, 2017-02-09 at 12:04 -0700, Jason Gunthorpe wrote:
> > On Thu, Feb 09, 2017 at 05:19:22PM +0200, Jarkko Sakkinen wrote:
> > > The current patch set does not define policy. The simple policy
> > > addition that could be added soon is the limit of connections
> > > because it is easy to implement in non-intrusive way.
> > 
> > It is also trivial for a userspace RM to limit the number of sessions
> > or connections or otherwise to manage this limitation. It is hard to
> > see why we'd need kernel support for this.
> 
> Because the kernel is a primary TPM user.

When I said 'this' I meant a kernel policy to limit the number of
user connections.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
