From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: drop chip->is_open and
	chip->duration_adjusted
Date: Mon, 14 Nov 2016 21:11:54 -0800
Message-ID: <20161115051106.u2xoduwf2kpcznv3@intel.com>
References: <20161114234500.24839-1-jarkko.sakkinen@linux.intel.com>
	<20161115043001.GA22482@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161115043001.GA22482-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 09:30:01PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 14, 2016 at 03:44:58PM -0800, Jarkko Sakkinen wrote:
> > Use atomic bitops for chip->flags so that we do not need chip->is_open
> > and chip->duration_adjusted anymore.
> 
> I don't know if it s a really great idea to use atomic bit ops for
> things that do not need to be atomic.. It makes the locking scheme
> less clear. is open is genuinely different since it relies on the
> atomic for correctness.

The way I see it is one of the status flags bound to chip among the
others. I do not see this cause too much harm for clarity. It eases
debugging the driver a bit because you get more state out of 'flags'.

It also makes code little a bit more robust as flags is independent of
locks.

How strong is your opposition here? I do not see any exceptional damage
done but see some subtle but still significant benefits.

> Merging is_duration makes lots of sense though

Also timeout_adjusted should be merged (for some reason missed it).

> Jason

/Jarkko

------------------------------------------------------------------------------
