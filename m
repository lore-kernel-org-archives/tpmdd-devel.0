From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2] Add "shutdown" to "struct class".
Date: Sat, 13 May 2017 07:33:45 +0200
Message-ID: <20170513053345.GA22283@kroah.com>
References: <20170512233831.25449-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170512233831.25449-1-joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, May 12, 2017 at 04:38:31PM -0700, Josh Zimmerman wrote:
> The TPM class has some common shutdown code that must be executed for
> all drivers. This adds some needed functionality for that.
> 
> (In addition, update a comment to reflect an out-of-date path.)

Change that in a different patch please.

> 
> Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

What changed from v1?  Always put that below here.

And if you can also show how this will be used, that would be great, I
don't want to add new apis with no users.

thanks,

greg k-h

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
