From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 9 Feb 2017 12:04:26 -0700
Message-ID: <20170209190426.GA1104@obsidianresearch.com>
References: <jarkko.sakkinen@linux.intel.com>
	<201702090906.v1996c6a015552@wind.enjellic.com>
	<20170209151922.cqo32h4io5dqyvvw@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170209151922.cqo32h4io5dqyvvw-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 09, 2017 at 05:19:22PM +0200, Jarkko Sakkinen wrote:
> > userspace instance with subsequent relinquishment of privilege.  At
> > that point one has the freedom to implement all sorts of policy.
> 
> If you look at the patch set that I sent yesterday it exactly has a
> feature that makes it more lean for a privileged process to implement
> a resource manager.

I continue to think, based on comments like this, that you should not
implement tmps0 in the first revision either. That is also something
we have to live with forever, and it can never become the 'policy
limited' or 'unpriv safe' access point to the kernel.  ie go back to
something based on tmp0 with ioctl.

This series should focus on allowing a user space RM to co-exist with
the in-kernel services - lets try and tackle the idea of a
policy-restricted or unpriv-safe cdev when someone comes up with a
comprehensive proposal..

> The current patch set does not define policy. The simple policy
> addition that could be added soon is the limit of connections
> because it is easy to implement in non-intrusive way.

It is also trivial for a userspace RM to limit the number of sessions
or connections or otherwise to manage this limitation. It is hard to
see why we'd need kernel support for this.

The main issue from the kernel perspecitive is how to allow sessions
to be used in-kernel and continue to make progress when they start to
run out.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
