From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 27 Jan 2017 15:48:53 -0800
Message-ID: <1485560933.3229.36.camel@HansenPartnership.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<20170127233513.GA28995@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170127233513.GA28995-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-27 at 16:35 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 27, 2017 at 02:04:59PM -0800, James Bottomley wrote:
> 
> > if I look at the code I've written, I don't know what the session
> > number is, I just save sessionHandle in a variable for later use 
> > (lets say to v1).  If I got the same session number returned at a 
> > later time and placed it in v2, all I'd notice is that an 
> > authorization using v1 would fail.
> 
> Is there any way that could be used to cause an op thinking it is
> using v1 to authorize something it shouldn't?

Not really: in the parameter or HMAC case, you have to compute based on
the initial nonce given by the TPM when the session was created. 
 Assuming the initial nonce belonged to the evicted session, the HMAC
will now fail because the nonce of the v2 session is different.  There
is a corner case where you track the nonce in a table indexed by
handle, so when v2 is created, its nonce replaces the old v1 nonce in
the table.  Now you can use v1 and v2 without error (because use picks
up the correct nonce) and effectively they're interchangeable as the
same session.  Even in this case, you're not authorising something you
shouldn't, you're just using one session for the authorisations where
you thought you had two.

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
