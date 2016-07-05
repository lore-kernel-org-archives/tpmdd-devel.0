From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ops_sem and tpm_mutex
Date: Tue, 5 Jul 2016 10:01:00 -0600
Message-ID: <20160705160100.GA715@obsidianresearch.com>
References: <20160705110647.GA28275@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160705110647.GA28275-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 05, 2016 at 02:06:47PM +0300, Jarkko Sakkinen wrote:

> This is the basic pattern. Basically we always loose the benefit of
> RW-lock because in every use case we also lock a mutex.

The only purpose of the rw lock is protect against unregister, and
that is the benifit it provides.

> What I was thinking that maybe we could have kref for ops instead
> of lock. In the places where we now use read lock you could use
> kref_get_unless_zero() to avoid races with tpm_chip_unregister().

No, it needs to be a lock, the unregister path must block and sleep,
and a kref cannot do that alone, by the time you build in the locking
you've made something more expensive than a rwlock.

The performance alternative is to use srcu for the rwlock, but since
we don't really have a performance concern in TPM I would rather not
see such complexity.

Another alternative would be to merge the rw-lock and mutex together
(ie hold mutex before touching ops at all), however this semantically
changes things by linking the lifetime and concurrancy models
together.

I belive I looked at that before doing the rwsem and decided it was a
huge amount of tricky work.

Jason

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
