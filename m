From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3] tpm_crb: request and relinquish
	locality 0
Date: Fri, 17 Mar 2017 11:11:16 -0600
Message-ID: <20170317171116.GA29996@obsidianresearch.com>
References: <20170315055738.11088-1-jarkko.sakkinen@iki.fi>
	<87h92uvtce.fsf@redhat.com> <87fuidx5mt.fsf@redhat.com>
	<20170316115543.jw23imcvkcriaam5@intel.com>
	<878to3x2h2.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878to3x2h2.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 17, 2017 at 10:00:41AM -0700, Jerry Snitselaar wrote:

> > Changing the return value to -EBUSY was a stupid mistake from my side.
> >
> > I'll try revise this a bit in a way that the API will allow positive
> > value for stating that the given locality has been already taking.
> 
> Is there a big performance hit with requesting and releasing locality?
> If instead it just released it when release_locality is called I think
> the changes are pretty minor.

If you can measure please let us know :)

This is all very old it may not actually make any sense..

.. and as I said earlier if we want to 'cache' the locality for
performance then the core code should do it.

I kinda thought the point of releasing the locality was to allow other
platform things to access the TPM, so I'm confused why TIS wouldn't
always release it as well..

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
