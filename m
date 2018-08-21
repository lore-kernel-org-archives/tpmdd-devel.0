From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 04/23] TPM: Expose struct tpm_chip and
 related find_get and put functions
Date: Tue, 21 Aug 2018 12:31:08 -0600
Message-ID: <20180821183108.GC25543@ziepe.ca>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
 <153486703636.13066.16209594327379341518.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <153486703636.13066.16209594327379341518.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 21, 2018 at 04:57:16PM +0100, David Howells wrote:
> Expose struct tpm_chip and related find_get and put functions so that
> TPM-using code can make sure it uses the same TPM for any related set of
> operations.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

>  drivers/char/tpm/tpm-interface.c |   19 ++++++++++++++++---
>  drivers/char/tpm/tpm.h           |    5 -----
>  include/linux/tpm.h              |   10 ++++++++++
>  3 files changed, 26 insertions(+), 8 deletions(-)

I think this is already in the kernel .. Stephen did it.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
