From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] tpm_crb: Fix AMD Zen on-chip fTPM
 detection
Date: Fri, 16 Jun 2017 13:25:44 -0600
Message-ID: <20170616192544.GA31769@obsidianresearch.com>
References: <20170616182951.398757-1-manuel.lauss@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170616182951.398757-1-manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Manuel Lauss <manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jun 16, 2017 at 08:29:51PM +0200, Manuel Lauss wrote:
> This RFC patch fixes 2 issues which prevent the fTPM device from being initialized
> by the tpm_crb driver:
> 
> 1) use devm_ioremap() instead of devm_ioremap_resource() to fix the following error
> due to it not allowing overlapping resources:
> 
> tpm_crb MSFT0101:00: can't request region for resource [mem 0xdd84f000-0xdd84ffff]
> tpm_crb: probe of MSFT0101:00 failed with error -16

No, we can't do this, it breaks other situations that rely on
request_resource.

We already put a work around for a very similar problem on a different
system, do you have commit?

commit b4e2eb0651ac3180a942d378b040c5cc045113ee
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Tue Feb 21 14:14:24 2017 -0700

    tpm crb: Work around BIOS's that report the wrong ACPI region size


> 2) The fTPM uses different buffer addresses for command and response, so the
>    priv->cmd_size member never gets initialized.  Move this initialization
>    to right after succesfully mapping the cmd buffer.

Yes for this though, can you prepare a seperate patch and include a
proper Fixes line refering to aa77ea0e43dc5bb0c1dcc9bad76afaa7faca8cab
?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
