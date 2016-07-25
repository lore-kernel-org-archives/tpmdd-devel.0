From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: TPM2 Driver Support in distros (part 1)
Date: Mon, 25 Jul 2016 13:46:06 -0600
Message-ID: <20160725194606.GA20479@obsidianresearch.com>
References: <nn1ajt$rpd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <nn1ajt$rpd$1@ger.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jul 23, 2016 at 10:53:54PM -0400, Ken Goldman wrote:
> Is there a web site or other document that lists which distros or 
> kernels include a TPM 2.0 driver?
> 
> I support a TPM 2.0 user space TSS.  Not seeing /dev/tpm0 is a typical 
> error that prospective users see, and I'd like to give them some guidance.
> 
> If there is no such page, and people are willing to post information, 
> I'd be happy to include it on my TSS page.

You need to work with SuSE and Red Hat to make sure they are aware of
the need to backport this subsystem into their kernels. TPM has been
quiet for so long, nobody is likely paying attention.

It is technically feasible to make a stand alone back port module,
however it will not be able to integrate into the kernel's IMA, just
provide the /dev/tpm0. This would be alot of work for someone to do.

We have made so many huge changes since the old kernels the enterprise
distros are shipping that a simple driver backport is not feasible.

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
