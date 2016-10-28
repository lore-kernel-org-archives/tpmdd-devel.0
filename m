From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: tpm_tis regression in 4.9?
Date: Thu, 27 Oct 2016 21:09:16 -0600
Message-ID: <20161028030916.GA29851@obsidianresearch.com>
References: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 27, 2016 at 05:33:57PM -0700, Andy Lutomirski wrote:
> Hi-
> 
> I think this error on my laptop is new on 4.9 kernels:
> 
> [  +0.014696] tpm_tis 00:09: 1.2 TPM (device-id 0xFE, rev-id 2)
> [  +0.012228] tpm tpm0: TPM self test failed
> [  +0.000019] tpm_tis: probe of 00:09 failed with error -14
> 
> Is this known?

I think this patch from Jarkko's next is the fix:

http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7ddcdd8990e4783d09c7e86d90ccb4121

Jarkko? Can you hurry that along to go in for -rc?

> At the very least, shouldn't the error message include rc?

Yes.

Thanks,
Jason

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
