From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v6 0/9] tpm: cleanup/fixes in existing
	event log support
Date: Sat, 19 Nov 2016 11:36:27 -0700
Message-ID: <20161119183627.GC22775@obsidianresearch.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20161114223322.5uzdc7sob2vukwrq@intel.com>
	<20161115002514.qhweuyzg5mgebusq@intel.com>
	<20161115021543.d4wgjqid7fut4y4c@intel.com>
	<582A9EAE.5000505@linux.vnet.ibm.com>
	<20161115174012.3pfxzz2ugrdglj4o@intel.com>
	<20161115180610.GA1852@obsidianresearch.com>
	<20161115185453.e52miq2em7gj4qyi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161115185453.e52miq2em7gj4qyi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 10:54:53AM -0800, Jarkko Sakkinen wrote:
> On Tue, Nov 15, 2016 at 11:06:10AM -0700, Jason Gunthorpe wrote:
> > On Tue, Nov 15, 2016 at 09:40:12AM -0800, Jarkko Sakkinen wrote:
> > 
> > > I applied fix from Colin. I for OF specific patches in this patch set
> > > I do not have means to test the code paths that exercise OF specific
> > > functionality. This is what worries me a bit. If I had tested-by from
> > > someone running a system that can exercise those code paths, I would
> > > be less worried.
> > 
> > I can probably check it next week on my OF systems that do not use event log
> 
> Thanks Jason. I'll apppend your Tested-by's to the commits when you're
> done. Probably doing pull request in the latter part of next week.

What are we testing? Your master now? It will need the patch I just
sent or it will fail for me.

Jason

------------------------------------------------------------------------------
