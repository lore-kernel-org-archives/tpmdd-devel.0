From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/4] Improve handling of TPM2 event logs
Date: Wed, 5 Apr 2017 14:46:50 +0300
Message-ID: <20170405114650.c2kkkz2th2emalcc@intel.com>
References: <20170329074330.b2rbsbt2zc7o22q7@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329074330.b2rbsbt2zc7o22q7-WbvboCQVrrgDIl+Cyo8nDyLysJ1jNyTM@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 29, 2017 at 12:43:30AM -0700, Petr Vandrovec wrote:
> From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> When TPM2 log has entries with more than 3 digests, or with digests
> not listed in the log header, log gets misparsed, eventually
> leading to kernel complaint that code tried to vmalloc 512MB of
> memory (I have no idea what would happen on bigger system).

It would be easier to follow this if you would give a concrete
example of such situation. Since you are contributing this, you
must must have bumped into this, haven't you?

> So code should not parse only first 3 digests: both event header
> and event itself are already in memory, so we can parse any number
> of digests, as long as we do not try to parse whole memory when
> given count of 0xFFFFFFFF.
> 
> So this change:
> 
> * Rejects event entry with more digests than log header describes.
>   Digest types should be unique, and all should be described in
>   log header, so there cannot be more digests in the event than in
>   the header.
> 
> * Reject event entry with digest that is not described in the
>   log header.  In theory code could hardcode information about
>   digest IDs already assigned by TCG, but if firmware authors
>   cannot get event log format right, why should anyone believe
>   that they got event log content right.


I have to say that I really didn't what this change is doing after
reading these. I only undestood what this commit is doing by reading
the code change.

So we have a constant for banks and you are reading the number of banks
from the event to make it more dynamic? Why it requires such a complicated 
explanation? And what is your short summary trying to say?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
