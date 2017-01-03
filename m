From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 14:32:34 -0700
Message-ID: <20170103213234.GB29656@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483374980.2458.13.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > This patch set adds support for TPM spaces that provide a context
> > for isolating and swapping transient objects. This patch set does
> > not yet include support for isolating policy and HMAC sessions but
> > it is trivial to add once the basic approach is settled (and that's
> > why I created an RFC patch set).
> 
> The approach looks fine to me.  The only basic query I have is about
> the default: shouldn't it be with resource manager on rather than off? 
>  I can't really think of a use case that wants the RM off (even if
> you're running your own, having another doesn't hurt anything, and it's
> still required to share with in-kernel uses).

I haven't looked too closely at TPM 2.0 stuff, but at least for 1.2 we
should have a kernel white-list of allowed commands within a RM
context, so having the RM on by default would break all of the user
space.

I really think the only way forward here is a new char dev that is
safe for unprivileged/concurrent use and migrate the user space stack
to use it instead.

> And with that, I've TPM 2 enabled both gnome-keyring and openssl:
> 
> https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/gnome-keyring
> https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/openssl_tpm_engine
 
> I'm running them in production on my day to day laptop and so far
> everything's working nicely (better than 1.2, in fact, since tcsd
> periodically crashes necessitating a restart of everything).

You granted your unprivileged user access to /dev/tpm0 then? FYI I
think that is a dangerous idea..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
