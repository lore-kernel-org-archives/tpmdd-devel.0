From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 05/23] TPM: Use struct tpm_chip rather
 than chip number as interface parameter
Date: Fri, 24 Aug 2018 10:42:21 +0300
Message-ID: <20180824074221.GF3584@linux.intel.com>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
 <153486704294.13066.8818198038331415342.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <153486704294.13066.8818198038331415342.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 21, 2018 at 04:57:22PM +0100, David Howells wrote:
> Use struct tpm_chip rather than chip number as interface parameter for most
> interface functions.  This allows the client to be sure about the consistency
> of what device it uses.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  drivers/char/tpm/tpm-interface.c    |   76 ++++++++-------------------------
>  drivers/char/tpm/tpm-sysfs.c        |    2 -
>  include/linux/tpm.h                 |   16 ++++---
>  security/integrity/ima/ima.h        |    2 -
>  security/integrity/ima/ima_crypto.c |    4 +-
>  security/integrity/ima/ima_init.c   |   19 +++++---
>  security/integrity/ima/ima_queue.c  |    4 +-
>  security/keys/trusted.c             |   80 ++++++++++++++++++++++-------------
>  8 files changed, 96 insertions(+), 107 deletions(-)

Should be split at least to three patches and TPM side is
already in the upstream.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
