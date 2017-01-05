From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 5 Jan 2017 12:20:25 -0700
Message-ID: <20170105192025.GB12587@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483641223.2515.62.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 05, 2017 at 10:33:43AM -0800, James Bottomley wrote:

> > A combo ioctl that could setup the session, issue an operation in it
> > and then delete the session, for instance.
> 
> This would work for encryption or HMAC sessions, but probably not for
> policy sessions, because they can have an arbitrarily large command
> sequence to construct them.

I'd rather give up features (eg policy sessions, if necessary) for the
unpriv fd than give up security of the unpriv fd.

We always have the out that special stuff can go down the priv path.

> The other issue we're likely to run into if we do it this way is
> delayed error reporting.

Not sure I follow.

> How about a more traditional approach which would be leasing (basically
> what we use for NFS).  Any application opening a session would have

Doesn't this just change the DOS vector? Now the attacker has to delay
execution of TPM commands long enough to force session leases to time
out. That isn't too hard to do, asking the TPM to make a RSA key can
take seconds, for instance.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
