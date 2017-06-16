From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] Add "shutdown" to "struct class".
Date: Fri, 16 Jun 2017 10:57:47 +0200
Message-ID: <20170616085747.c2wkkgsdjuyju6vm@intel.com>
References: <CAHSjozA+xfUM-NmbP7Kb5B=T+u6qaEFzMWeF6OxX2N7-xHLAVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozA+xfUM-NmbP7Kb5B=T+u6qaEFzMWeF6OxX2N7-xHLAVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 01, 2017 at 09:33:43AM -0700, Josh Zimmerman wrote:
> The TPM class has some common shutdown code that must be executed for
> all drivers. This adds some needed functionality for that.
> 
> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> -----
> v2: Add Signed-off-by.
> v3: Remove logically separate change.
> v4: Add "acked-by" and "cc".
> v5: Execute only one of the class/bus/driver's shutdown functions.

This breaks the patch.

> ---

The changelog should be here.

>  drivers/base/core.c    | 6 +++++-
>  include/linux/device.h | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
