From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] tpm_crb: Fix AMD Zen on-chip fTPM
 detection
Date: Fri, 16 Jun 2017 14:41:56 -0600
Message-ID: <20170616204156.GA4151@obsidianresearch.com>
References: <20170616182951.398757-1-manuel.lauss@gmail.com>
	<20170616192544.GA31769@obsidianresearch.com>
	<CAOLZvyEeiRQ8LfCmq1p70xv9worYfTXDPTgEZrhFcqUev1+h+Q@mail.gmail.com>
	<20170616195748.GA1624@obsidianresearch.com>
	<CAOLZvyFUS+Foj0ZycrZS=yWp+=x1mi8yL1-3Bq+mhcav9iesYA@mail.gmail.com>
	<20170616202718.GB1624@obsidianresearch.com>
	<CAOLZvyH2rG3RpqPfiMOf68yHC91DdO8UEHXYh4FCb0ZqKJf1dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOLZvyH2rG3RpqPfiMOf68yHC91DdO8UEHXYh4FCb0ZqKJf1dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Fri, Jun 16, 2017 at 10:35:11PM +0200, Manuel Lauss wrote:

> > What do you mean 'mapping that fails already' ? The report you gave
> > above shows the failure is on the other region:
> >
> >  tpm_crb MSFT0101:00: can't request region for resource [mem 0xdd84f000-0xdd84ffff]
> 
> the address seems to change every boot (it's one of the two MSFT0101 devices)
> but it's always the first call to devm_ioremap_resource() in tpm_crb.c
>  line 454 that fails:
> 
>         priv->iobase = devm_ioremap_resource(dev, &io_res);

I have no idea why that would fail, based on your proc file it should
not, you need to figure out what is going on..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
