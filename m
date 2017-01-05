From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 5 Jan 2017 10:27:26 -0700
Message-ID: <20170105172726.GA11680@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DC7C149F6-pTbww/UJF9iZbMGAS439G2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 05, 2017 at 03:52:02PM +0000, Fuchs, Andreas wrote:
> Great to see this coming along so well. Thanks a lot to Jarkko !

> The TPM allows an application to get the list of currently loaded
> handles TPM2_GetCapabilities(TPM_CAP_HANDLES).  It would be great to
> have the RM be as transparent to userspace as possible. The RM spec
> of TCG therefore says that you need to intercept and override this

I'd rather just ban unnecessary stuff like this on the RM fd.
Tracking active handles can be done in userspace by the app
itself. Debugging can be done by using the non-RM fd or debugfs.

IMHO we need to focus narrowly on enabling *specific* unpriviledged
user space use models and safe co-existence with kernel users.

> - Constant session handles (hurray):

> Sessions do not change their handles on contextsave/contextload, so
> you do not need to virtualize session handles.

The kernel still needs to track them, so they can be cleaned up and
access controlled.

> - Session Limits (here it gets ugly):

> Even thought the TPM supports the same swapping-scheme for sessions
> as it does for transient objects, it only allows for a limited
> number of session to be opened (64 in case of PC-Client), called
> active sessions.  This means that a single process can still DoS the
> TPM if it allocates 64 sessions, or 64 processes can DoS the TPM if

Well, if we have an unpriv fd then it should not be able to DOS the
system - that would suggest either that FD cannot use sessions or we
need some kernel solution to guarentee the DOS is not possible.

A combo ioctl that could setup the session, issue an operation in it
and then delete the session, for instance.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
